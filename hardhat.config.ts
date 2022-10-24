require('@openzeppelin/hardhat-upgrades');
require('hardhat-abi-exporter');
// require("hardhat-gas-reporter");
import "hardhat-gas-reporter"
import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";


dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

abiExporter: [
  {
    path: './abi/pretty',
    pretty: true,
  },
  {
    path: './abi/ugly',
    pretty: false,
  },
]

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  solidity: "0.8.4",
  
  networks: {
    hardhat : {
      // allowUnlimitedContractSize : true,
    },
    ropsten: {
      url: process.env.ROPSTEN_URL || "",
      accounts:
        process.env.ROPSTEN_PRIVATE_KEY !== undefined ? [process.env.ROPSTEN_PRIVATE_KEY] : [],
    },
    rinkeby: {
      // allowUnlimitedContractSize : true,
      url: process.env.RINKEBY_URL || "",
      accounts:
        process.env.RINKEBY_PRIVATE_KEY !== undefined ? [process.env.RINKEBY_PRIVATE_KEY] : [],
    },
    ganache: {
      // allowUnlimitedContractSize : true,
      // allowUnlimitedContractSize: true,
      url: process.env.GANACHE_URL || "",
      accounts:
        process.env.GANACHE_PRIVATE_KEY !== undefined ? [process.env.GANACHE_PRIVATE_KEY] : [],
    },
    matic: {
      // url: "https://polygon-mainnet.infura.io/v3/605cc3bbb6b2412fa0399ee07e8bbb49",
      url: process.env.MATIC_URL || "",
      accounts:
        process.env.MATIC_PRIVATE_KEY !== undefined ? [process.env.MATIC_PRIVATE_KEY] : [],
    },
    goerli: {
      // url: "https://polygon-mainnet.infura.io/v3/605cc3bbb6b2412fa0399ee07e8bbb49",
      url: process.env.GOERLI_URL || "",
      accounts:
        process.env.GOERLI_PRIVATE_KEY !== undefined ? [process.env.GOERLI_PRIVATE_KEY] : [],
    },
    mumbai: {
      // url: "https://polygon-mainnet.infura.io/v3/605cc3bbb6b2412fa0399ee07e8bbb49",
      url: process.env.MUMBAI_URL || "",
      accounts:
        process.env.MUMBAI_PRIVATE_KEY !== undefined ? [process.env.MUMBAI_PRIVATE_KEY] : [],
    },
  },
  gasReporter: {
    // enabled: process.env.REPORT_GAS !== undefined,
    enabled: false,
    // enabled: true,
    currency: "USD",
  },
  etherscan: {
    // apiKey: process.env.ETHERSCAN_API_KEY,
    apiKey: process.env.MATIC_API_KEY,
  },
};

export default config;
