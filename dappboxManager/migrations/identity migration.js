var DM= artifacts.require("./dappboxManager.sol");

module.exports = function(deployer) {
  deployer.deploy(DM);
};
