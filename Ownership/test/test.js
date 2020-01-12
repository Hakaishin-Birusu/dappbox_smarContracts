
var Ownership = artifacts.require("VerifiedOwnershipManagement.sol");
const expect = require("chai").expect ;

contract("Contract : VerifiedOwnershipManagement", function(accounts){
    describe("Deploying Contract", function(){
        it("Catching Instance of Contract", function(){
            return Ownership.new().then(function(instances){
                OW= instances ;
            });
        });
    });

    describe("Testing contract VerifiedOwnershipManagement", function(){
        it("Testing function transferDocumentOwnership 1", function(){
            return OW.transferDocumentOwnership("0x1234","0x19741c2c2e64b10d13f70694470a72b68ad4be79","0xce9f751e749969f8d89ae8aecead8d7fbac7aa1e",0, 1).then(function(res){
                expect(res).not.be.an("error");
            });
        });

        it("Testing function transferDocumentOwnership 2", function(){
            return OW.transferDocumentOwnership("0x123456","0x19741c2c2e64b10d13f70694470a72b68ad4be79","0xce9f751e749969f8d89ae8aecead8d7fbac7aa1e",0, 2).then(function(res){
                expect(res).not.be.an("error");
            });
        });

        it("Testing function transferDocumentOwnership 3", function(){
            return OW.transferDocumentOwnership("0x12435678","0x19741c2c2e64b10d13f70694470a72b68ad4be79","0xce9f751e749969f8d89ae8aecead8d7fbac7aa1e",0,2 ).then(function(res){
                expect(res).not.to.be.an("error");
            });
        });


        it("Testing function transferFolderOwnership 1", function(){
            return OW.transferFolderOwnership("0x174859222e351ff389bfe920d4acad80c44b9ce1","0x19741c2c2e64b10d13f70694470a72b68ad4be79","0xce9f751e749969f8d89ae8aecead8d7fbac7aa1e",0, 1).then(function(res){
                expect(res).not.be.an("error");
            });
        });
        
        it("Testing function transferFolderOwnership", function(){
            return OW.transferFolderOwnership("0xd6424b96ec7ccf7f0df0e62c46745192da0b59a4","0x19741c2c2e64b10d13f70694470a72b68ad4be79","0xce9f751e749969f8d89ae8aecead8d7fbac7aa1e",0, 2).then(function(res){
                expect(res).not.to.be.an("error");
            });
        });

        it("Testing function transferFolderOwnership", function(){
            return OW.transferFolderOwnership("0x5e87ca46b2190ab8db0a83225848830d45c9d7da","0x19741c2c2e64b10d13f70694470a72b68ad4be79","0xce9f751e749969f8d89ae8aecead8d7fbac7aa1e",1, 0).then(function(res){
                expect(res).not.to.be.an("error");
            });
        });

        it("Testing function documentOwnershipExists", function(){
            return OW.documentOwnershipExists("0x12345678").then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });

        it("Testing function documentOwnershipExists", function(){
            return OW.folderOwnershipExists("0x174859222e351ff389bfe920d4acad80c44b9ce1").then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });
        
        it("Testing function getCountLatest", function(){
            return OW.getCountLatest().then(function(res){
                expect(res).to.be.equal(res , 3);
            });
        }); 

    });
});
