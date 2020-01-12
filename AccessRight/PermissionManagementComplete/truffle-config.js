var mnemonic1 = "network permit damp approve camp ceiling beef later cake giant border woman";

module.exports = {
  networks: {
    development: {
      network_id: "*",
      host: "127.0.0.1",
      port: 8545,   // Different than the default below
      gas: 6712388,
      gasPrice: 65000000000,
    },
    server: {
      host: "142.93.0.84", 
      port: 8546,
      network_id: "1970" 
    }
  },
  solc: {
    optimizer: {
      version: "0.4.23",
      enabled: true,
      runs: 200
    }
  }
};