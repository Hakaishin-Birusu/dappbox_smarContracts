var FolderPermissionManagement   = artifacts.require("./FolderPermissionManagement.sol");
var DocPermissionManagement   = artifacts.require("./DocPermissionManagement.sol");
var Dependency             = artifacts.require("./AccessRightsDefinition.sol");
var DocDependency             = artifacts.require("./DocDependency.sol");
var NotarizationManagement = artifacts.require("./NotarizationManagement.sol");

module.exports = function(deployer) {
    deployer.deploy(Dependency);
    deployer.deploy(DocDependency);
    deployer.deploy(NotarizationManagement);
    deployer.deploy(FolderPermissionManagement);
    deployer.deploy(DocPermissionManagement);
};