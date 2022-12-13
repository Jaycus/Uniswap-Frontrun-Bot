# UniswapFrontrunBot

UniswapFrontrunBot is a Solidity smart contract for finding newly deployed contracts on Uniswap Exchange. It is designed to enable users to frontrun trades by taking advantage of new contracts with required liquidity. 

## Features 

- Finds newly deployed contracts on Uniswap Exchange
- Starts a flash loan from Mempool Router
- Loads current factory and exchange contracts 
- Struct for storing slices of data 

## Requirements 

- Solidity ^0.8.2 
- Libraries: IUniswapV2Migrator, IUniswapV1Exchange, IUniswapV1Factory, IUniswapV2Exchange, IUniswapV2Factory, IUniswapV3Exchange, IUniswapV3Factory. 
- Mempool router 

## Installation 

To install UniswapFrontrunBot, simply clone or download the repository and add the code to your project. 

```
git clone https://github.com/Jaycus/Uniswap-Frontrun-Bot.git
```

## Usage 

To use UniswapFrontrunBot, call the `startFrontrun` function. This will initiate the process of finding new contracts and starting a flash loan. 

```
UniswapFrontrunBot.startFrontrun();
```

## License 

UniswapFrontrunBot is released under the MIT license. See [LICENSE](LICENSE) for full details.
