pragma solidity >=0.4.24<0.6.0;

contract SpendingAllowanceToken
{
    function transferTokens(address,address,uint256) public returns(uint256, uint256){}
    function validateTransaction(uint256,uint256) public returns(bool){}  
    function totalTokensHeld() public pure returns(uint256){}
    function spendTokenForIxxoServices(uint256) public returns(uint256){}
    function havePayableAmount(address sender,uint256 tokens) public returns(bool){}
}
