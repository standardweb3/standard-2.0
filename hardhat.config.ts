import "dotenv/config";
import "@nomiclabs/hardhat-etherscan";
import "hardhat-contract-sizer";
import "@nomiclabs/hardhat-solhint";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-ethers";
import "hardhat-contract-sizer";
import "hardhat-deploy";
import "hardhat-gas-reporter";
import "hardhat-interface-generator";
import "hardhat-spdx-license-identifier";
import "hardhat-watcher";
import "solidity-coverage";
import "@tenderly/hardhat-tenderly";
import "@typechain/hardhat";
import "hardhat-tracer";
import "@primitivefi/hardhat-marmite";
import "hardhat-abi-exporter";
import "./cli";
import * as tdly from "@tenderly/hardhat-tenderly";
tdly.setup();

import { HardhatUserConfig } from "hardhat/config";
import { removeConsoleLog } from "hardhat-preprocessor";
import {
  HardhatNetworkAccountsConfig,
  HardhatNetworkChainsConfig,
  HardhatNetworkForkingConfig,
  HardhatNetworkMiningConfig,
} from "hardhat/types";

const accounts = [process.env.DEPLOYER_KEY || "0x00"];

const config = {
  defaultNetwork: "hardhat",

  etherscan: {
    apiKey: {
      mainnet: process.env.ETHERSCAN_API_KEY!,
      rinkeby: process.env.ETHERSCAN_API_KEY!,
      ropsten: process.env.ETHERSCAN_API_KEY!,
      polygon: process.env.POLYGONSCAN_API_KEY!,
      polygonMumbai: process.env.POLYGONSCAN_API_KEY!,
    },
    customChains: [],
  },
  gasReporter: {
    coinmarketcap: process.env.COINMARKETCAP_API_KEY,
    currency: "USD",
    token: "ETH",
    gasPrice: 100,
    enabled: process.env.REPORT_GAS === "true",
    excludeContracts: ["ERC20Mock", "WETH9"],
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    dev: {
      default: 1,
    },
    alice: {
      default: 2,
    },
    bob: {
      default: 3,
    },
    carol: {
      default: 4,
    },
    dave: {
      default: 5,
    },
    eve: {
      default: 6,
    },
    feeTo: {
      default: 7,
    },
  },
  tenderly: {
    username: "hskang9",
    project: "standard-evm",
  },
  networks: {
    local: {
      url: "http://127.0.0.1:8545",
    },
    localhost: {
      url: "http://0.0.0.0:8545",
    },
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com/",
      accounts,
      chainId: 80001,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasMultiplier: 2,
    },
    /*
    mainnet: {
      url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts,
      chainId: 1,
      live: true,
      saveDeployments: true,
      gasPrice: "auto",
      tags: ["staging"],
    },
    hardhat: {
      forking: {
        enabled: process.env.FORKING === "true",
        url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
        blockNumber: 13000000,
      },
      allowUnlimitedContractSize: true,
      live: false,
      saveDeployments: true,
      tags: ["test", "local"],
      // Solidity-coverage overrides gasPrice to 1 which is not compatible with EIP1559
      hardfork: process.env.CODE_COVERAGE ? "berlin" : "london",
    },
    */
    /*
    ropsten: {
      url: `https://ropsten.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts,
      chainId: 3,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasPrice: 5000000000,
      gasMultiplier: 2,
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts,
      chainId: 4,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasPrice: 5000000000,
      gasMultiplier: 2,
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts,
      chainId: 5,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasPrice: 5000000000,
      gasMultiplier: 2,
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts,
      chainId: 42,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasPrice: 20000000000,
      gasMultiplier: 2,
    },
    fantom: {
      url: "https://rpcapi.fantom.network",
      accounts,
      chainId: 250,
      live: true,
      saveDeployments: true,
      gasPrice: 22000000000,
    },
    matic: {
      url: "https://rpc-mainnet.maticvigil.com",
      accounts,
      chainId: 137,
      live: true,
      saveDeployments: true,
    },
   
    xdai: {
      url: "https://rpc.xdaichain.com",
      accounts,
      chainId: 100,
      live: true,
      saveDeployments: true,
    },
    bsc: {
      url: "https://bsc-dataseed.binance.org",
      accounts,
      chainId: 56,
      live: true,
      saveDeployments: true,
    },
    "bsc-testnet": {
      url: "https://data-seed-prebsc-2-s3.binance.org:8545",
      accounts,
      chainId: 97,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasMultiplier: 2,
    },
    heco: {
      url: "https://http-mainnet.hecochain.com",
      accounts,
      chainId: 128,
      live: true,
      saveDeployments: true,
    },
    "heco-testnet": {
      url: "https://http-testnet.hecochain.com",
      accounts,
      chainId: 256,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasMultiplier: 2,
    },
    avalanche: {
      url: "https://api.avax.network/ext/bc/C/rpc",
      accounts,
      chainId: 43114,
      live: true,
      saveDeployments: true,
      gasPrice: 470000000000,
    },
    "avalanche-testnet": {
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      accounts,
      chainId: 43113,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasMultiplier: 2,
    },
    harmony: {
      url: "https://api.s0.t.hmny.io",
      accounts,
      chainId: 1666600000,
      live: true,
      saveDeployments: true,
    },
    "harmony-testnet": {
      url: "https://api.s0.b.hmny.io",
      accounts,
      chainId: 1666700000,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasMultiplier: 2,
    },
    okex: {
      url: "https://exchainrpc.okex.org",
      accounts,
      chainId: 66,
      live: true,
      saveDeployments: true,
    },
    "okex-testnet": {
      url: "https://exchaintestrpc.okex.org",
      accounts,
      chainId: 65,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasMultiplier: 2,
    },
    arbitrum: {
      url: "https://arb1.arbitrum.io/rpc",
      accounts,
      chainId: 42161,
      live: true,
      saveDeployments: true,
      blockGasLimit: 700000,
    },
    metis: {
      url: "https://andromeda.metis.io/?owner=1088",
      accounts,
      chainId: 1088,
      live: true,
      saveDeployments: true,
      blockGasLimit: 700000,
    },
    "arbitrum-testnet": {
      url: "https://kovan3.arbitrum.io/rpc",
      accounts,
      chainId: 79377087078960,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasMultiplier: 2,
    },
    celo: {
      url: "https://forno.celo.org",
      accounts,
      chainId: 42220,
      live: true,
      saveDeployments: true,
    },
    moonbase: {
      url: "https://rpc.testnet.moonbeam.network",
      accounts,
      chainId: 1287,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
    },
    moonriver: {
      url: "https://rpc.moonriver.moonbeam.network",
      accounts,
      chainId: 1285,
      saveDeployments: true,
      tags: ["staging"],
    },
    moonbeam: {
      url: "https://rpc.api.moonbeam.network",
      accounts,
      chainId: 1284,
      live: true,
      saveDeployments: true,
      tags: ["staging"]
    },
    shibuya: {
      url: "https://rpc.shibuya.astar.network:8545",
      accounts,
      chainId: 81,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
    },
    shiden: {
      url: "https://shiden.api.onfinality.io/public",
      accounts,
      chainId: 336,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
    },
    // ./astar-collator --dev --rpc-external --rpc-port 8545
    substrate: {
      url: "http://localhost:8545",
      accounts,
      chainId: 42,
      saveDeployments: true,
      tags: ["staging"]
    }*/
  },
  subgraph: {
    name: 'new-order-contracts', // Defaults to the name of the root folder of the hardhat project
    product: 'hosted-service', //||'subgraph-studio', // Defaults to 'subgraph-studio'
    indexEvents: true, // Defaults to false
    allowSimpleName: false // Defaults to `false` if product is `hosted-service` and `true` if product is `subgraph-studio`
  },
  paths: {
    subgraph: './subgraph', // Defaults to './subgraph'
    artifacts: "artifacts",
    cache: "cache",
    deploy: "deploy",
    deployments: "deployments",
    imports: "imports",
    sources: "contracts",
    tests: "test",
  },
  preprocess: {
    eachLine: removeConsoleLog(
      (bre) =>
        bre.network.name !== "hardhat" && bre.network.name !== "localhost"
    ),
  },
  compiler : {
    version: "0.8.10",
    settings: {
      optimizer: {
        enabled: true,
        runs: 99999,
      },
    },
  },
  solidity: {
    version: "0.8.10",
    settings: {
      optimizer: {
        enabled: true,
        runs: 99999,
      },
    },
  },
  spdxLicenseIdentifier: {
    overwrite: true,
    runOnCompile: true,
  },
  typechain: {
    outDir: "types",
    target: "ethers-v5",
  },
  watcher: {
    compile: {
      tasks: ["compile"],
      files: ["./contracts"],
      verbose: true,
    },
  },
  mocha: {
    timeout: 300000,
    //bail: true,
  },
};

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
export default config;
