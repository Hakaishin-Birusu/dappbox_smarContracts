
var LicenseSale = artifacts.require("LicenseSale.sol");
var SpendingAllowanceToken = artifacts.require("SpendingAllowanceToken.sol");
const expect = require("chai").expect ;




    contract("Contract : LicenseCore", function(accounts){
        describe("Deploying Contract", function(){
            it("Catching Instance of LicenseCore", function(){
                return LicenseSale.new().then(function(instances){
                        LS = instances ;
                });
            });
        });

contract("Contract : SpendingAllowanceToken", function(accounts){
    describe("Deploying Contract", function(){
        it("Catching Instance of SpendingAllowanceTokens Contract", function(){
            return SpendingAllowanceToken.new().then(function(instances){
                    SAT = instances ;
            });
        });
    });
    
    //acc[9]
    describe("Testing other function of SpendingAllowanceTokens ",function(){
        it("Is startTokenAllocation() function working ?",function(){ 
            return SAT.startTokenAllocation("0x93db2b69edc982a1d1183e9322a0d0a6dbcc7060",20000,"0x1234567890" , {from : accounts[0]}).then(function(res){
                expect(res).not.to.be.equal("error");

            });

        });
        //acc[8]
        it("Is minting tokens successfully ",function(){ 
            return SAT.startTokenAllocation("0x502e0c1d337ab29fd355bd2adea2dafdd087428b",50000,"0x123454356" , {from : accounts[0]}).then(function(res){
                expect(res).to.be.equal(res , true );

            });

        });
        //acc[9]
        it("Is minting tokens tokens to other account", function(){
            return SAT.startTokenAllocation("0xc60d15718b2db8431eb49f430bd0bacc3786f1e8",20000,"0x123452345", {from : accounts[0]}).then(function(res){
                expect(res).to.be.equal(res, true);

            });
        });


        //acc[8]=>acc[9]
        it("Can transferring back of token is done " , function(){
            return SAT.transferTokens("0x93db2b69edc982a1d1183e9322a0d0a6dbcc7060" , 2000 , {from : accounts[8]}).then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });

        //acc[9]=>[7]
        it("Inter account token transfer " , function(){
            return SAT.transferTokens("0xc60d15718b2db8431eb49f430bd0bacc3786f1e8", 500 , {from : accounts[9]}).then(function(res){
                expect(res).to.be.equal(res, false);
            });
        });

});

    describe("testing subscription mechanism contract ",function(){

        it("Purchasing dappBox individual : dappbox Free",function(){
            return LS.purchaseDappBoxIndividual(101, 0, 1, {from : accounts[9]}).then(function(res){
                expect(res).not.to.be.equal("error");
            });
        });

        it("Purchasing dappBox individual : dappbox start",function(){
            return LS.purchaseDappBoxIndividual(102, 0, 1, {from : accounts[9]}).then(function(res){
                expect(res).not.to.be.equal("error");
            });
        });

        it("Purchasing dappBox individual : dappbox premium",function(){
            return LS.purchaseDappBoxIndividual(103, 0, 1, {from : accounts[6]}).then(function(res){
                expect(res).not.to.be.equal("error");
            });
        });

        it("Purchasing dappBox individual : dappbox start ,for year",function(){
            return LS.purchaseDappBoxIndividual(102, 1, 1, {from : accounts[7]}).then(function(res){
                expect(res).not.to.be.equal("error");
            });
        });

        it("Purchasing dappBox individual : dappbox premium ,for year",function(){
            return LS.purchaseDappBoxIndividual(103, 1, 1, {from : accounts[8]}).then(function(res){
                expect(res).not.to.be.equal("error");
            });
        });

        it("Purchasing dappBox creator : for dappbox start as base ",function(){
            return LS.purchaseDappCreator(1,102, 0, 1, {from : accounts[9]}).then(function(res){
                expect(res).not.to.be.equal("error");
            });
        });

        it("Purchasing dappBox creator : for dappbox premium as base",function(){
            return LS.purchaseDappCreator(1,103, 0, 1, {from : accounts[9]}).then(function(res){
                expect(res).not.to.be.equal("error");
            });
        });

        it("Purchasing dappBox creator : for dappbox premium as base , more than 1",function(){
            return LS.purchaseDappCreator(5,103, 0, 1, {from : accounts[9]}).then(function(res){
                expect(res).not.to.be.equal("error");
            });
        });

        it("Purchasing dappBox creator : for dappbox premium as base , more than 10",function(){
            return LS.purchaseDappCreator(54,103, 0, 1, {from : accounts[7]}).then(function(res){
                expect(res).not.to.be.equal("error");
            });
        });


        it("Purchasing dappBox creator : for dappbox premium as base , more than 10 ,for year",function(){
            return LS.purchaseDappCreator(42,103, 1, 1, {from : accounts[8]}).then(function(res){
                expect(res).not.to.be.equal("error");
            });
        });

        it("Purchasing dappBox creator : for dappbox premium as base , more than 40 ,for year",function(){
            return LS.purchaseDappCreator(41,103, 1, 1, {from : accounts[8]}).then(function(res){
                expect(res).not.to.be.equal("error");
            });
        });

        it("Purchasing dappBox creator : for dappbox premium as base , more than 50 , for year",function(){
            return LS.purchaseDappCreator(54,103, 1, 1, {from : accounts[8]}).then(function(res){
                expect(res).not.to.be.equal("error");
            });
        });

        // renewal test left for start and premium
        // some tests for dappbox creator are also left
        // some other tests are left including SAT deduction checking 
        // test for addon to be brought by creator in each condtion is left


    });
});
});



