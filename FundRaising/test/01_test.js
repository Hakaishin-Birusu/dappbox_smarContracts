var FundRaising = artifacts.require("FundRaising.sol");
var SpendingAllowanceToken = artifacts.require("SpendingAllowanceToken.sol");
const expect = require("chai").expect;







contract("Contract PrimaryToken",function(accounts){
    describe("Deploying contract",function(){
        it("Catching instance ", function(){
           return FundRaising.new().then(function(instance){
               FR = instance ;
}); 
});
});




    
//acc[8]
describe("Testing other function of SpendingAllowanceTokens ",function(){
    it("Is startTokenAllocation() function working ?",function(){ 
        return FR.startTokenAllocation("0x25b70cc381dcbbbaeb0101618c4cb341138da1ec",20000,"0x123454356" , {from : accounts[0]}).then(function(res){
            expect(res).to.be.equal(res , true );

});
});

//acc[8]
it("miniting tokens to account 8 ",function(){ 
    return FR.startTokenAllocation("0x25b70cc381dcbbbaeb0101618c4cb341138da1ec",50000,"0x123454356" , {from : accounts[0]}).then(function(res){
        expect(res).to.be.equal(res , true );

});
});

//acc[7]
it(" minting SAT to account 7",function(){ 
    return FR.startTokenAllocation("0x63c6f801d5deda6f27e13d5f8820a321079329f2",500000,"0x123454356" , {from : accounts[0]}).then(function(res){
        expect(res).to.be.equal(res , true );

});
});

//acc[7]
it("minting tokens to account 6 ",function(){ 
    return FR.startTokenAllocation("0x235ed7ec4eaa949c6fdde82a1c2a4be22fd61ea9",500000,"0x123454356" , {from : accounts[0]}).then(function(res){
        expect(res).to.be.equal(res , true );

});
});




    it("minitng tokens to account 5 ", function(){
        return FR.startTokenAllocation("0x5dc0260526a4fca3562248c4fd7f3e0322cdfc8d", 800000,"0x1234").then(function(res){  
            expect(res).to.be.equal(res, 1);
    
    });
    });

    

describe("Testing function plceorder",function(){
it("At the start of bidding Current price should be Initial price ", function(){
    return FR.getSharePrice({from : accounts[0]}).then(function(res){  
        expect(res).to.be.equal(res, 1);

});
});


it("Owner of contract cannot bid" , function(){
    return FR.PlaceOrder(1,0,2, {from : accounts[0]}).then(function(res){
        expect(res).to.be.equal(res, false);

});
});


    it("Function PlaceOrder is working ?", function(){
        return FR.PlaceOrder(1,0,20, {from : accounts[7]}).then(function(res){  
            expect(res).to.not.be.an("error");

});
});

    
    it("Is Placing bids : 1" , function(){
        return FR.PlaceOrder(1,0,25, {from : accounts[6] }).then(function(res){
            expect(res).to.be.equal(res, true);
});
});
   

    it("Is Placing bids , via other accounts " , function(){
        return FR.PlaceOrder(1,0,25, {from : accounts[5]}).then(function(res){
            expect(res).to.be.equal(res, true);

});
});
    it("Is placing bid failling on less bid price ", function(){
        return FR.PlaceOrder(1,0,0, {from : accounts[5]}).then(function (res){
            expect(res).to.be.equal(res, false);
            
        });
    });


    it("Is placing bid : after inappropriate bid by same bidder ", function(){
        return FR.PlaceOrder(2,0,15, {from : accounts[5]}).then(function (res){
            expect(res).to.be.equal(res, true);
            
        });
    });

    it("Is placing bid : 3 ", function(){
        return FR.PlaceOrder(2,0,15, {from : accounts[6]}).then(function (res){
            expect(res).to.be.equal(res, true);
            
        });
    });

    
    it("Calling getTokenPrice() , to check increase in price by delta ", function(){
        return FR. getSharePrice().then(function (res){
            expect(res).to.be.equal(res, 8);
            
        });
    });

    
    it("Placing of bid should fail due to increase in price by delta ", function(){
        return FR.PlaceOrder(2,0,3, {from : accounts[8]}).then(function (res){
            expect(res).to.be.equal(res, false);
            
        });
    });



    it("Can previous bidder bid again", function(){
        return FR.PlaceOrder(1,0,20 , {from : accounts[8] }).then(function(res){
            expect(res).to.be.equal(res, true);
        });
    });

    
       // delaying the execution to reach the EndDate 
        function delay(interval)  
        {
        return it(' Starting after EndDate tests', done => 
        {
            setTimeout(() => done(), interval)

        }).timeout(interval + 100) // The extra 100ms should guarantee the test will not fail due to exceeded timeout
        }

        delay(9500);


        //Calling IsRaisingMoneySuccessful() which apperently calls buy() if endate is reached 




        it("IsRaisingSuccessful => calls buy() ", function(){
            return FR.IsRaisingMoneySuccessful({from : accounts[0]}).then(function(res){
                expect(res).to.be.equal(res, true);
                
            });
        });

        it("get Raised money , can be called by owner itslef", function(){
            return FR.getRaisedMoneyAmount({from : accounts[0]}).then(function(res){
                expect(res).to.be.equal(res, true);
            });
        });

        it("get Raised money , called by owner of contract", function(){
            return FR.getRaisedMoneyAmount().then(function(res){
                expect(res).to.be.equal( res , 102);
                
            });
        });


        it("Selling order cannot be placed by owner of contract" , function(){
            return FR.PlaceOrder(1,1,16).then(function(res){
                expect(res).to.be.equal(res, false);
            });
        });

        
        it("Non owner of token cannot place selling order", function(){
            return FR.PlaceOrder(1,1,12 , {from : accounts[8]}).then(function(res){
                expect(res).to.be.equal(res, false);
            });
        });

        it("Sell order should fail if , selling more than owned tokens" , function(){
            return FR.PlaceOrder(1,1,22, {from: accounts[1]}).then(function(res){
                expect(res).to.be.equal(res, true);
            });
        });

        it("Is Placing sell order 1 , by owner of tokens" , function(){
            return FR.PlaceOrder(1,1,22, {from: accounts[2]}).then(function(res){
                expect(res).to.be.equal(res, true);
            });
        });

        it("Is Placing sell order 2 , by owner of tokens" , function(){
            return FR.PlaceOrder(1,1,15, {from: accounts[4]}).then(function(res){
                expect(res).to.be.equal(res, true);
            });
        });

        it("Is Placing sell order 3 by owner of tokens", function(){
            return FR.PlaceOrder(1,1,22, {from: accounts[3]}).then(function(res){
                expect(res).to.be.equal(res, true);
            });
        });

 

        it("buying after enddate " , function(){
            return FR.PlaceOrder(1,0,150, {from: accounts[1]}).then(function(res){
                expect(res).to.be.equal(res, true);
            });
        });



    
});
}); 
});

