pragma solidity >=0.4.21 <0.6.0;

contract DocNotarizationManagement{
  address owner;

  uint documentCount;

  enum PermissionType {master, owner, write, read, none}

  struct DocumentAccessRight {
    uint blockNumber;
    uint timestamp;
    bytes32 hash;
    address from;
    address to;
    PermissionType permissionOfFrom;
    PermissionType permissionOfTo;
  }

  DocumentAccessRight[] dochistory;

  

  mapping(bytes32 => bool) public usedHashes;


  event DocumentEvent(uint blockNumber, uint blockTimeStamp, bytes32 _hash, address from, address to, PermissionType permissionOfFrom, PermissionType permissionOfTo);
  
  /**
  * @dev use to add history of transfers and emit transfer event
  * @param _hash hash of the document
  * @param _from address from whom the transfer is originated
  * @param _to addess to whom transfer is done
  * @param _permissionOfFrom enum PermissionType of delegator
  * @param _permissionOfFrom enum PermissionType of delegated
  */
  function transferDocument(bytes32 _hash, address _from, address _to, PermissionType _permissionOfFrom, PermissionType _permissionOfTo) internal{
    dochistory.push(DocumentAccessRight(block.number, block.timestamp, _hash, _from, _to, _permissionOfFrom, _permissionOfTo));
    emit DocumentEvent(block.number, block.timestamp,  _hash, _from, _to, _permissionOfFrom, _permissionOfTo);
  }

  
  /**
  * @dev use to check if the documents exists or not
  * @param _hash hash of the document
  */
  function documentExists(bytes32 _hash) view internal returns (bool exists){
    if (usedHashes[_hash]) {
      exists = true;
    }else{
      exists= false;
    }
    return exists;
  }


  /**
  * @dev returns the total number of documents/hashes
  */
  function getLatest() view internal returns (uint latest){
      return documentCount;
      
  }
}
