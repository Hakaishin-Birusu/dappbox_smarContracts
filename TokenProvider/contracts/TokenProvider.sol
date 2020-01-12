pragma solidity >=0.4.24;

contract TokenProvider {

  mapping(string => bool) InitialPaymentDone;
  mapping(string => address) dAppboxPermanentAddress;

  struct AllTransaction {
    address Sender;
    address Reciever;
    uint256 TotalTokens;
    bool Status;
  }

  address public owner = msg.sender;
  address public masterDappbox ;

  modifier onlyOwner {
    require(msg.sender == owner,"Not the owner");
    _;
  }

  modifier onlyAuthorized {
    bool res = msg.sender==owner || msg.sender==masterDappbox;
    require(res == true , "authorization failed");
    _;
  }
  struct DappboxInfo {
    address payable TempPublicAddress;
    bytes32 RawHash;
    bytes SignedMessage;
  }
  mapping(string=> DappboxInfo)  DappboxInfos;

  mapping(string => AllTransaction[]) AllTransactionsOfAddress;
  AllTransaction[] AllTransactions;


  /**
   * @dev Recover signer address from a message by using their signature
   * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
   * @param signature bytes signature, the signature is generated using web3.eth.sign()
   */
  function recoverAccount(bytes32 hash, bytes memory signature)
    internal
    pure
    returns (address)
  {
    bytes32 r;
    bytes32 s;
    uint8 v;

    if (signature.length != 65) {
      return (address(0));
    }

    assembly {
      r := mload(add(signature, 0x20))
      s := mload(add(signature, 0x40))
      v := byte(0, mload(add(signature, 0x60)))
    }

    if (v < 27) {
      v += 27;
    }

    if (v != 27 && v != 28) {
      return (address(0));
    } else {
      return ecrecover(hash, v, r, s);
    }
  }


/**
*@dev : Mechanism to verify the signature , if signature matched then transfer the tokens  
 */
  function verifyAndSend(string calldata _url) external payable onlyAuthorized returns(bool) {
      
      address payable reciever; 
      reciever = DappboxInfos[_url].TempPublicAddress;
      bytes32  hash = DappboxInfos[_url].RawHash;
      bytes memory signature =  DappboxInfos[_url].SignedMessage;
      require(reciever != address(0) ,"User not found");
      address recoveredAddress = recoverAccount(hash, signature);
      bool res;
      AllTransaction memory currentInfo;
      currentInfo.Sender = msg.sender;
      currentInfo.Reciever = reciever;
      currentInfo.TotalTokens = msg.value;

      if(reciever == recoveredAddress && InitialPaymentDone[_url] == false) // if payment once done , user cannot request for initial payment again
      {
        res = true;
        reciever.transfer(msg.value);
        currentInfo.Status = res;
        InitialPaymentDone[_url] = res;
      }
      else
      {
        res = false;
        InitialPaymentDone[_url] = res;
        currentInfo.Status =res;
      }

    AllTransactionsOfAddress[_url].push(currentInfo);
    AllTransactions.push(currentInfo);   
    return res;
  }


  function getAllPreviousTransaction(uint256 index) public view returns(address, address, uint256, bool, bool)
  {
    if ((AllTransactions.length -1) >= index)
    {
    address Sender = AllTransactions[index].Sender;
    address Reciever = AllTransactions[index].Reciever;
    uint256 TotalTokens = AllTransactions[index].TotalTokens;
    bool Status = AllTransactions[index].Status;
    index++;
    if(index < AllTransactions.length)
    {
        return ( Sender, Reciever, TotalTokens,Status,true);
    }else {
      return ( Sender, Reciever, TotalTokens,Status,false);
    }
  }
  }

  function getAllPreviousTransactionOfUser(string memory user , uint256 index) public view returns(address,address,uint256,bool,bool) {
    if (AllTransactionsOfAddress[user].length > index)
    {
    address sender = AllTransactionsOfAddress[user][index].Sender;
    address reciever = AllTransactionsOfAddress[user][index].Reciever;
    uint256 totalTokens = AllTransactionsOfAddress[user][index].TotalTokens;
    bool status = AllTransactionsOfAddress[user][index].Status;
    index++;
    if(index < AllTransactionsOfAddress[user].length)
    {
        return ( sender, reciever, totalTokens,status,true);
    }else {
      return ( sender, reciever, totalTokens,status,false);
    }
  }
}


  function addDeviceTempAccountInfo(string memory _url, address payable _address, bytes32 _rawhash, bytes memory _signedMesaage) public   
  {
    DappboxInfo memory currentInfo;
    currentInfo.TempPublicAddress = _address;
    currentInfo.RawHash = _rawhash;
    currentInfo.SignedMessage = _signedMesaage;
    DappboxInfos[_url] = currentInfo;
  }


  function getUsersTempInfo(string memory _url) public view returns( address , bytes32 , bytes memory )
  {
      return(DappboxInfos[_url].TempPublicAddress,
        DappboxInfos[_url].RawHash,
        DappboxInfos[_url].SignedMessage);
  }


  function sendToken(string memory url, address payable reciever) public payable onlyAuthorized returns(bool) {
        require(msg.sender != reciever, "master dAppBox cannot send tokens to itself");
        require(reciever != address(0) ,"User not found");
        AllTransaction memory currentInfo;
        reciever.transfer(msg.value);
        currentInfo.Sender = msg.sender;
        currentInfo.Reciever = reciever;
        currentInfo.TotalTokens = msg.value;
        currentInfo.Status = true;
        AllTransactionsOfAddress[url].push(currentInfo);
        AllTransactions.push(currentInfo);
        return true;

    }


  function addOrChangeMasterDappboxAddress(address dAppBoxAddress)public onlyOwner returns(bool)
  {
    masterDappbox = dAppBoxAddress;
    return true;
  }

  function setDappboxPermanentAddress(string memory url , address userAddresss) public returns(bool)
  {
    dAppboxPermanentAddress[url] = userAddresss;
    return true;
  }

  function getDappBoxPermanentAddress(string memory url) public view returns(address)
  {
    return dAppboxPermanentAddress[url];
  }

}