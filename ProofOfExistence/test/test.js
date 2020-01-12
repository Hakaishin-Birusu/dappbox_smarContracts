var ProofOfExistence = artifacts.require("ProofOfExistence.sol");
const expect = require("chai").expect ;

contract("Contract : ProofOfExistence", function(accounts){
    describe("Deploying Contract", function(){
        it("Catching Instance of Contract : ProofOfExistence", function(){
            return ProofOfExistence.new().then(function(instances){
               POE = instances ;
            });
        });
    });

    describe("Testing contract ProofOfExistence", function(){
        it("Testing function addDevice 1 ", function(){
            return POE.addDevice("0x90407179965f735451b4c9e2ea2669b48bc765ec").then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });

        it("Testing function addDevice 1 ", function(){
            return POE.addDevice("0x6f7196dbc9dfbd3d0bb22fc5e3c94c89ffd81529").then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });

        it("Testing function addDevice 2 ", function(){
            return POE.addDevice("0x90407179965f735451b4c9e2ea2669b48bc765ec").then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });

        it("Testing function addFileChange ", function(){
            return POE.addFileChange("0x90407179965f735451b4c9e2ea2669b48bc765ec",2,"0x1234").then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });

        it("Testing function addFileChange 1 ", function(){
            return POE.addFolderChange("0x90407179965f735451b4c9e2ea2669b48bc765ec", 1,"0x5e87ca46b2190ab8db0a83225848830d45c9d7da","0x123456").then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });

        it("Testing function addFileChange 2 ", function(){
            return POE.addFolderChange("0x6f7196dbc9dfbd3d0bb22fc5e3c94c89ffd81529", 2,"0x5e87ca46b2190ab8db0a83225748830d45c9d7db","0x12345678").then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });
    });
});

