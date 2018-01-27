require('babel-register')({
    ignore: /node_modules\/(?!zeppelin-solidity)/
});
require('babel-polyfill');
var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "";

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/GBKOU5za2EimK5ewgvvA")
      },
      gas: 2900000,
      // gas: 3712390,
      // gasPrice: 40,
      network_id: 3
    },
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    live: {
      host: "127.0.0.1", // Random IP for example purposes (do not use)
      port: 8545,
      network_id: 1        // Ethereum public network
      // optional config values:
      // gas: 23
      // gasPrice
      // from - default address to use for any transaction Truffle makes during migrations
      // provider - web3 provider instance Truffle should use to talk to the Ethereum network.
      //          - if specified, host and port are ignored.
    },
    solc: { optimizer: { enabled: true, runs: 200 } }
  }
};
