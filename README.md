# Aave v3 Flash Loan Arbitrage Sepolia test

This project is a sample Aave v3 flash loan arbitrage to be used in the sepolia test network with a custom dex for test.

First fill the .env.template and create the .env and then try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
GAS_REPORT=true npx hardhat test
npx hardhat node
npx hardhat run scripts\deployDexAndFlashLoan.js
```
