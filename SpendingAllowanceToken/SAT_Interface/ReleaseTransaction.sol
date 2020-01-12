pragma solidity >=0.4.24<0.6.0;

contract ReleaseTransaction
{
    function getAllPendingRequests(uint256) public view returns(uint256[] memory,uint256,bool){}
    function getReleaseTransaction(uint256,uint256) public view returns (address , uint256 , uint256,address,uint256,uint256){}
}    


