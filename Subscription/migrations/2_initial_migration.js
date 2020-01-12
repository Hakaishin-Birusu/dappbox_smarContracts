const LicenseSale = artifacts.require("LicenseSale.sol");

module.exports = function(deployer) {
  deployer.deploy(LicenseSale);
};
