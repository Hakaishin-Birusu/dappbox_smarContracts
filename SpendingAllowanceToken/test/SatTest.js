var SpendingAllowanceToken = artifacts.require("SpendingAllowanceToken");
var SC1 = artifacts.require("SC1");
var SC2 = artifacts.require("SC2");
const expect = require("chai").expect;

contract("Contract : SpendingAllowanceToken", function(accounts){
    describe("Deploying Contract : SAT", function(){
        it("Catching Instance of SpendingAllowanceTokens Contract", function(){
            return SpendingAllowanceToken.new().then(function(instances){
                    SAT = instances ;
            });
        });
    });

    describe("Deploying Contract : SC1", function(){
        it("Catching Instance of Smart Contract 1", function(){
            return SC1.new().then(function(instances){
                    SC1= instances ;
            });
        });
    });

    describe("Deploying Contract : SC2", function(){
        it("Catching Instance of Smart Contract 2", function(){
            return SC2.new().then(function(instances){
                    SC2 = instances ;
            });
        });
    });


    describe("Test :1 A" , function(){
        it("Allocating tokens to account A", function(){
            return SAT.startTokenAllocation("0x68cb51855141848a6eb85ba7803879007e0a77ea",1 , "1q2w3e4r5t6y").then(function(res){
                expect(res ).to.be.equal(res,true);
            });
        });


        it("Retrieve the contract address", function(){
            return SC1.getAddress().then(function(res){
                expect(res ).to.be.equal(res,"0xB544eE535d6a6F58bBed93aBD2865e5299cE12bE");
            });
        });


        it("Reciever is Smart contract ", function(){
            return SAT.isContract("0xB544eE535d6a6F58bBed93aBD2865e5299cE12bE").then(function(res){
                expect(res).to.be.equal(true);
            });
        });
        

        it("acc[A] should not be contract ", function(){
            return SAT.isContract("0x68cb51855141848a6eb85ba7803879007e0a77ea").then(function(res){
                expect(res).to.be.equal(false);
            });
        });
    
        it("sending token to smart contract SC1 from A", function(){
            return SAT.transferTokens("0x68cb51855141848a6eb85ba7803879007e0a77ea","0xB544eE535d6a6F58bBed93aBD2865e5299cE12bE",1,{from:accounts[9]}).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,0);
            });
        });

        it("checking tokens held by SC1 , it should be 1", function(){
            return SAT.totalTokensHeld({from : "0xaF6E31E7292fC97D45b7656c36Db94a241dd3742"}).then(function(res){
                expect(res).to.be.equal(res ,1);
            });
        });

        it("validating transaction", function(){
            return SAT.validateTransaction(0,0,{from:accounts[9]}).then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });
        //delay 7 seconds (let periodic = 5 sec == 2hours)

                // delaying the execution to reach the EndDate 
                function delay(interval)  
                {
                return it(' Starting delay , where 10sec = 1 min', done => 
                {
                    setTimeout(() => done(), interval)
        
                }).timeout(interval + 100 ) // The extra 100ms should guarantee the test will not fail due to exceeded timeout
                }
        
                delay(7000);

        it("sending token from smart contract SC1 to B", function(){
            return SAT.transferTokens("0x68cb51855141848a6eb85ba7803879007e0a77ea","0x8a0ea1c1269a6e9765f96224082d9c8e7ca9d7d2",1,{from:accounts[9]}).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,0);
            });
        });

        it("checking tokens held by SC1 , it should be 0", function(){
            return SAT.totalTokensHeld({from:"0xB544eE535d6a6F58bBed93aBD2865e5299cE12bE"}).then(function(res){
                expect(res).to.be.equal(res ,0);
            });
        });


        it("checking tokens held by B , it should be 1", function(){
            return SAT.totalTokensHeld({from:"0x8a0ea1c1269a6e9765f96224082d9c8e7ca9d7d2"}).then(function(res){
                expect(res).to.be.equal(res ,0);
            });
        });



    

    describe("Test :1B" , function(){
        it("Allocating tokens to account A", function(){
            return SAT.startTokenAllocation("0x68cb51855141848a6eb85ba7803879007e0a77ea",1 , "1q2w3e4r5t6y").then(function(res){
                expect(res ).to.be.equal(res,true);
            });
        });


        it("Allocating tokens to account B", function(){
            return SAT.startTokenAllocation("0x8a0ea1c1269a6e9765f96224082d9c8e7ca9d7d2",1 , "1q2w3e4r5t6y").then(function(res){
                expect(res ).to.be.equal(res,true);
            });
        });


        it("sending 1 SAT from acc[A] to acc[C]", function(){
            return SAT.transferTokens("0x68cb51855141848a6eb85ba7803879007e0a77ea","0x727963e5a6a75fa7a57cd90dc8bc13173cbacb9d",1).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,0);
            });
        });

        it("sending 1 SAT from acc[B] to acc[C]", function(){
            return SAT.transferTokens("0x8a0ea1c1269a6e9765f96224082d9c8e7ca9d7d2","0x727963e5a6a75fa7a57cd90dc8bc13173cbacb9d",1).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,1);
            });
        });


        it("sending 2 SAT from acc[C] to acc[D]", function(){
            return SAT.transferTokens("0x727963e5a6a75fa7a57cd90dc8bc13173cbacb9d","0x5ec6426a366830805bf73aabc1ed27eff0fe46df",1).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,3);
            });
        });

        it("checking tokens held by acc[D], should be zero", function(){
            return SAT.totalTokensHeld({from : accounts[6]}).then(function(res){
                expect(res).to.be.equal(res ,0);
            });
        });

        //Idea is , only acc[A] and acc[B] , validate thier transaction and acc[D] recieves repective tokens directly , without the intervension of acc[C]
        it("validating transaction from acc[A] to acc[C]", function(){
            return SAT.validateTransaction(0,0,{from:accounts[9]}).then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });

        it("validating transaction from acc[B] to acc[C]", function(){
            return SAT.validateTransaction(0,1,{from:accounts[8]}).then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });

        it("checking tokens held by acc[D], should be 2", function(){
            return SAT.totalTokensHeld({from : accounts[6]}).then(function(res){
                expect(res).to.be.equal(res ,2);
            });
        });

    });



    describe("Test :1C" , function(){
        it("Allocating tokens to account A", function(){
            return SAT.startTokenAllocation("0x68cb51855141848a6eb85ba7803879007e0a77ea",1 , "1q2w3e4r5t6y").then(function(res){
                expect(res ).to.be.equal(res,true);
            });
        });

        it("Allocating tokens to account B", function(){
            return SAT.startTokenAllocation("0x8a0ea1c1269a6e9765f96224082d9c8e7ca9d7d2",1 , "1q2w3e4r5t6y").then(function(res){
                expect(res ).to.be.equal(res,true);
            });
        });

        it("sending 1 SAT from acc[A] to acc[C]", function(){
            return SAT.transferTokens("0x68cb51855141848a6eb85ba7803879007e0a77ea","0x727963e5a6a75fa7a57cd90dc8bc13173cbacb9d",1).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,0);
            });
        });

        it("sending 1 SAT from acc[B] to acc[C]", function(){
            return SAT.transferTokens("0x8a0ea1c1269a6e9765f96224082d9c8e7ca9d7d2","0x727963e5a6a75fa7a57cd90dc8bc13173cbacb9d",1).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,0);
            });
        });

        it("sending 2 SAT from acc[C] to SC1", function(){
            return SAT.transferTokens("0x727963e5a6a75fa7a57cd90dc8bc13173cbacb9d","0xB544eE535d6a6F58bBed93aBD2865e5299cE12bE",2).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,0);
            });
        });



        it("sending 2 SAT from SC1 to SC2", function(){
            return SAT.transferTokens("0xB544eE535d6a6F58bBed93aBD2865e5299cE12bE","0x5FBa2Db4a6FaE32e676D461C7D5ad8c3286BDD37",1).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,0);
            });
        });


        it("sending 2 SC2 to acc[A]", function(){
            return SAT.transferTokens("0x5FBa2Db4a6FaE32e676D461C7D5ad8c3286BDD37","0x68cb51855141848a6eb85ba7803879007e0a77ea",1).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,0);
            });
        });

        it("checking tokens held by acc[A], should be 2", function(){
            return SAT.totalTokensHeld({from : accounts[9]}).then(function(res){
                expect(res).to.be.equal(res ,2);
            });
        });
});


    describe("Test :2" , function(){
        it("Allocating 1 token to account A", function(){
            return SAT.startTokenAllocation("0x68cb51855141848a6eb85ba7803879007e0a77ea",1 , "1q2w3e4r5t6y").then(function(res){
                expect(res ).to.be.equal(res,true);
            });
        });

        it("Allocating 1 token to account B", function(){
            return SAT.startTokenAllocation("0x8a0ea1c1269a6e9765f96224082d9c8e7ca9d7d2",1 , "1q2w3e4r5t6y").then(function(res){
                expect(res ).to.be.equal(res,true);
            });
        });

        it("Allocating 1 token to account C", function(){
            return SAT.startTokenAllocation("0x727963e5a6a75fa7a57cd90dc8bc13173cbacb9d",1 , "1q2w3e4r5t6y").then(function(res){
                expect(res ).to.be.equal(res,true);
            });
        });

        it("Allocating 1 token to account D", function(){
            return SAT.startTokenAllocation("0x5ec6426a366830805bf73aabc1ed27eff0fe46df",1 , "1q2w3e4r5t6y").then(function(res){
                expect(res ).to.be.equal(res,true);
            });
        });

        it("sending 1 SAT from acc[A] to acc[B]", function(){
            return SAT.transferTokens("0x68cb51855141848a6eb85ba7803879007e0a77ea","0x8a0ea1c1269a6e9765f96224082d9c8e7ca9d7d2",1,{from : accounts[1]}).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,0);
            });
        });

        it("sending 2 SAT from acc[B] to acc[C]", function(){
            return SAT.transferTokens("0x8a0ea1c1269a6e9765f96224082d9c8e7ca9d7d2","0x727963e5a6a75fa7a57cd90dc8bc13173cbacb9d",2, {from : accounts[2]}).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,1);
            });
        });

        it("sending 3 SAT from acc[C] to acc[D]", function(){
            return SAT.transferTokens("0x727963e5a6a75fa7a57cd90dc8bc13173cbacb9d","0x5ec6426a366830805bf73aabc1ed27eff0fe46df",3,{from : accounts[3]}).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,2);
            });
        });

        it("sending 4 SAT from acc[D] to acc[A]", function(){
            return SAT.transferTokens("0x5ec6426a366830805bf73aabc1ed27eff0fe46df","0x74a3d20091a7544a306ff4e25a3421a449960a5d",4 ,{from : accounts[4]}).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,3);
            });
        });

        it("checking tokens held by acc[A],", function(){
            return SAT.totalTokensHeld({from : accounts[9]}).then(function(res){
                expect(res).to.be.equal(res ,0);
            });
        });

        it("validating transaction from acc[A]", function(){
            return SAT.validateTransaction(0,0,{from:accounts[9]}).then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });
        it("checking tokens held by acc[A], ", function(){
            return SAT.totalTokensHeld({from : accounts[9]}).then(function(res){
                expect(res).to.be.equal(res ,1);
            });
        });

        it("validating transaction acc[B]", function(){
            return SAT.validateTransaction(0,1,{from:accounts[8]}).then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });

        it("checking tokens held by acc[A], should be 2", function(){
            return SAT.totalTokensHeld({from : accounts[9]}).then(function(res){
                expect(res).to.be.equal(res ,2);
            });
        });

        it("validating transaction acc[C] ", function(){
            return SAT.validateTransaction(0,2,{from:accounts[7]}).then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });
        //since acc[B] is validating acc[C] transaction but due to chaining acc[A] is recieving tokens
        it("checking tokens held by acc[A], should be 2", function(){
            return SAT.totalTokensHeld({from : accounts[9]}).then(function(res){
                expect(res).to.be.equal(res ,3);
            });
        });

        it("validating transaction acc[D] ", function(){
            return SAT.validateTransaction(0,3,{from:accounts[6]}).then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });
        it("checking tokens held by acc[A], should be 2", function(){
            return SAT.totalTokensHeld({from : accounts[9]}).then(function(res){
                expect(res).to.be.equal(res ,4);
           });
        });
});


    describe("Test :3" , function(){
        it("Allocating 10 token to account A", function(){
            return SAT.startTokenAllocation("0x68cb51855141848a6eb85ba7803879007e0a77ea",10 , "1q2w3e4r5t6y").then(function(res){
                expect(res ).to.be.equal(res,true);
            });
        });

        it("sending 10 SAT from acc[A] to acc[B]", function(){
            return SAT.transferTokens("0x68cb51855141848a6eb85ba7803879007e0a77ea","0x8a0ea1c1269a6e9765f96224082d9c8e7ca9d7d2",10).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,0);
            });
        });

        it("sending 4 SAT from acc[B] to acc[C]", function(){
            return SAT.transferTokens("0x8a0ea1c1269a6e9765f96224082d9c8e7ca9d7d2","0x727963e5a6a75fa7a57cd90dc8bc13173cbacb9d",10).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,1);
            });
        });

        it("sending 4 SAT from acc[B] to acc[D]", function(){
            return SAT.transferTokens("0x8a0ea1c1269a6e9765f96224082d9c8e7ca9d7d2","0x5ec6426a366830805bf73aabc1ed27eff0fe46df",4).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,2);
            });
        });

        it("sending 2 SAT from acc[B] to acc[E]", function(){
            return SAT.transferTokens("0x8a0ea1c1269a6e9765f96224082d9c8e7ca9d7d2","0x68cb51855141848a6eb85ba7803879007e0a77ea",2).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,3);
            });
        });

        it("sending 2 SAT from acc[C] to acc[F]", function(){
            return SAT.transferTokens("0x727963e5a6a75fa7a57cd90dc8bc13173cbacb9d","0x6389e7dba38cbd32c2dc5911c8be570d75c99149",2).then(function(res1,res2){
                expect(res1, res2).to.be.equal(res1, res2 , 0,4);
            });
        });

        it("validating transaction from acc[A]", function(){
            return SAT.validateTransaction(0,0,{from:accounts[9]}).then(function(res){
                expect(res).to.be.equal(res , true);
            });
        });

        //since validating only acc[A] transaction , but due to chaining every respective account recieves respective amount of tokens

        it("checking tokens held by acc[C], should be 2", function(){
            return SAT.totalTokensHeld({from : accounts[7]}).then(function(res){
                expect(res).to.be.equal(res ,0);
            });
        });

        it("checking tokens held by acc[E], should be ", function(){
            return SAT.totalTokensHeld({from : accounts[5]}).then(function(res){
                expect(res).to.be.equal(res ,2);
            });
        });

        it("checking tokens held by acc[F], should be ", function(){
            return SAT.totalTokensHeld({from : accounts[4]}).then(function(res){
                expect(res).to.be.equal(res ,3);
            });
        });

        it("checking tokens held by acc[B], should be 0", function(){
            return SAT.totalTokensHeld({from : accounts[8]}).then(function(res){
                expect(res).to.be.equal(res ,0);
            });
        });

        it("checking tokens held by acc[D], should be 2", function(){
            return SAT.totalTokensHeld({from : accounts[6]}).then(function(res){
                expect(res).to.be.equal(res ,2);
            });
        }); 




    });
});
});


