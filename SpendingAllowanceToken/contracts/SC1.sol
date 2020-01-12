pragma solidity >=0.4.24;

//SAT interface 
contract SpendingAllowanceToken
{
    function transferTokens(address,address,uint256) public returns(uint256, uint256){}
    function validateTransaction(uint256,uint256) public returns(bool){}  
    function totalTokensHeld() public pure returns(uint256){}
    function getReleaseTransaction(uint256,uint256) public view returns (address,uint256,uint256,address,uint256,uint256){}
    }
    contract ReleaseTransaction
    {
        function getAllPendingRequests(uint256) public view returns(uint256[] memory  , uint256 , bool){}

    }

contract SC1 
{
    SpendingAllowanceToken sat;
    ReleaseTransaction rt ;
    address public disAddress;

    constructor(address _t) public payable {
        assembly {
            sstore(disAddress_slot, address)
        }
        sat = SpendingAllowanceToken(_t);
        rt = ReleaseTransaction(_t);
    }

    function SpendingOfTokens(address reciever , uint256 nbTokens) public  returns (uint256, uint256)
    {
        (uint256 listNumber , uint256 index) = sat.transferTokens(disAddress,reciever , nbTokens);
        return (listNumber,index);
    } 

    function SatLookup() public view returns (uint256)
    {
        return sat.totalTokensHeld();
    }

    function _getReleaseTransaction(uint256 listnumber ,uint256 index) public view returns (address,uint256,uint256,address,uint256,uint256)
    {
        return sat.getReleaseTransaction(listnumber ,index);
    }

    function _getAllPendingRequests(uint256 startingIndex) public view returns(uint256[] memory  , uint256 , bool)
    {
        return rt.getAllPendingRequests(startingIndex);
    }
    
}

