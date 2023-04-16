import { HardhatUserConfig } from 'hardhat/types';
import { task } from 'hardhat/config';
import '@nomiclabs/hardhat-waffle';
import 'hardhat-typechain';
import '@nomiclabs/hardhat-ethers';
import 'hardhat-deploy';
import 'hardhat-gas-reporter';
import '@openzeppelin/hardhat-upgrades';
// import dotenv from 'dotenv';
// dotenv.config();

const DEFAULT_COMPILER_SETTINGS = {
  version: '0.8.17',
  paths: {
    sources: './contracts',
  },
  settings: {
    viaIR: true,
    evmVersion: 'istanbul',
    optimizer: {
      enabled: true,
      runs: 200,
    },
    metadata: {
      bytecodeHash: 'ipfs',
    },
  },
  allowUnlimitedContractSize: true,
};

const config: HardhatUserConfig = {
  defaultNetwork: 'hardhat',
  solidity: {
    compilers: [DEFAULT_COMPILER_SETTINGS],
  },
  // gasReporter: {
  //   enabled: true,
  //   currency: 'USD',
  //   gasPrice: 22,
  //   coinmarketcap: '43385a6b-53bf-41c1-82c5-09bb89fe203f',
  // },
};

export default config;
