const SAT = artifacts.require("SpendingAllowanceToken");

module.exports = function(deployer) {
  deployer.deploy(SAT);
};
