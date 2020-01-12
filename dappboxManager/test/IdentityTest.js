
var IdentitySmartContract = artifacts.require("./IdentitySmartContract.sol");
const expect = require("chai").expect ;

contract("Contract : IdentitySmartContract", function(accounts){
    describe("Deploying Contract", function(){
        it("Catching Instance of Contract", function(){
            return IdentitySmartContract.new().then(function(instances){
                Id = instances ;
            });
        });
    });

    //acc[9]
    describe("Testing function addUsers()", function(){
        it("Is function working", function(){
            return Id.addUsers("0xacda414fe0b90b16181821db3e947dd5f2555559" , "Sagar" ,"sagar.dapboxx.io" ,"zat.ixxo.io").then(function(res){
                expect(res).not.be.an("error");
            });
        });
        
    //acc[8]
        it("Can be called by Owner of the contract only", function(){
            return Id.addUsers("0x686cdfd35f586f5865eec69b6b625e92b3d95166" , "Rajat" ,"Rajat.dapboxx.io" ,"zat2.ixxo.io").then(function(res){
                expect(res).not.to.be.an("error");
            });
        });

    //acc[7]
        it("Is storing information regarding user by owner of contract", function(){
            return Id.addUsers("0xd03742c1c3199874a691c686b97112c2f6480dd4","Aditya","Aditya.dapboxx.io","zat3.ixxo.io" ,{from : accounts[0]}).then(function(res){
                expect(res).to.be.equal(res , true);
            });

        });

    });


    describe("Testing all the get functions",function(){
        it("testing function getByAddress",function(){
            return Id.getByAddress("0xd03742c1c3199874a691c686b97112c2f6480dd4").then(function(res,res1,res2){
                expect(res,res1,res2).to.be.equal(res,"Aditya",res1,"Aditya.dapboxx.io",res2,"zat3.ixxo.io" )
            });
        });

        it("testing function getByUserName",function(){
            return Id.getByUserName("sagar").then(function(res,res1,res2){
                expect(res,res1,res2).to.be.equal(res,"0xacda414fe0b90b16181821db3e947dd5f2555559",res1,"sagar.dapboxx.io",res2,"zat.ixxo.io" )
            });
        });

        it("testing function getByUrl",function(){
            return Id.getByUrl("Rajat.dapboxx.io").then(function(res,res1,res2){
                expect(res,res1,res2).to.be.equal(res,"0x686cdfd35f586f5865eec69b6b625e92b3d95166",res1,"Rajat",res2,"zat2.ixxo.io" )
            });
        });

        it("testing function getByAddress",function(){
            return Id.getByShortUrl("zat.ixxo.io").then(function(res,res1,res2){
                expect(res,res1,res2).to.be.equal(res,"0xacda414fe0b90b16181821db3e947dd5f2555559",res1,"sagar.dapboxx.io",res2,"zat3.io" )
            });
            
        });
        
    });
        
});