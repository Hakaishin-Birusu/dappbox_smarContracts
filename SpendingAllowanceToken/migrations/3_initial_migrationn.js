const SC1 = artifacts.require("SC1");
const SC2 = artifacts.require("SC2");

module.exports = function(deployer) {
  deployer.deploy(SC1);
  deployer.deploy(SC2);
};
