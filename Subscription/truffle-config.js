module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      gas: 9900000 // Match any network id
    }
  },
  compilers: {
    solc: {
        settings: {
            optimizer: {
                enabled: true,
                runs: 200
            }
        }
    }
  },

};