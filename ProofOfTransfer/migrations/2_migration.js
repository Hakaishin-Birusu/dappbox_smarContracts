const POT = artifacts.require("ProofOfTransfer_flat.sol");

module.exports = function(deployer) {
  deployer.deploy(POT);
};
