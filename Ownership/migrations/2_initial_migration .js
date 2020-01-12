const OM = artifacts.require("OwnershipManagement");

module.exports = function(deployer) {
  deployer.deploy(OM);
};
