pragma solidity >=0.4.21 <0.6.0;

contract VerifiedOwnershipManagement
{

  uint256 documentOwnershipCount;
  uint256 folderOwnershipCount;
  enum OwnershipType {owner, tenant, none} 
  address contractOwner;
  modifier onlyOwner ()
  {
    require(contractOwner == msg.sender );
    _;
  }

  constructor () public
  {
    contractOwner = msg.sender;
  }

struct DocumentOwnership { 
   uint256 blockNumber; 
   uint256 timestamp; 
   bytes32 hash; 
   address from; 
   address to; 
   OwnershipType ownershipFrom; 
   OwnershipType ownershipTo; 
 } 
  struct FolderOwnership { 
   uint256 blockNumber; 
   uint256 timestamp; 
   address dappboxfolder; 
   address from; 
   address to; 
   OwnershipType ownershipFrom; 
   OwnershipType ownershipTo; 
 }

  DocumentOwnership[] docOwnHistory;
  FolderOwnership[] foldOwnHistory;

  mapping(bytes32 => bool) public usedFileHashes;
  mapping(address => bool) public usedFoldersAddress;

  event DocumentOwnershipEvent(uint blockNumber, uint blockTimeStamp, bytes32 _hash, address from, address to,OwnershipType _OwnershipOfFrom, OwnershipType _OwnershipOfTo);
  event FolderOwnerShipEvent(uint blockNumber, uint blockTimeStamp, address dappboxfolder, address from, address to,OwnershipType _OwnershipOfFrom, OwnershipType _OwnershipOfTo);
/**
  * @dev use to add history of transfers and emit transfer event
  * @param _hash hash of the document
  * @param _from address from whom the transfer is originated
  * @param _to addess to whom transfer is done
  * @param _OwnershipOfFrom enum OwnershipType of delegator
  * @param _OwnershipOfTo enum OwnershipType of delegated
  */
  function transferDocumentOwnership(bytes32 _hash, address _from, address _to, OwnershipType _OwnershipOfFrom, OwnershipType _OwnershipOfTo) public onlyOwner{
    docOwnHistory.push(DocumentOwnership(block.number, block.timestamp, _hash, _from, _to,_OwnershipOfFrom, _OwnershipOfTo));
    emit DocumentOwnershipEvent(block.number, block.timestamp,  _hash, _from, _to,_OwnershipOfFrom, _OwnershipOfTo);
  }

  function transferFolderOwnership(address dappboxfolder, address _from, address _to,  OwnershipType _OwnershipOfFrom, OwnershipType _OwnershipOfTo) public onlyOwner{
    foldOwnHistory.push(FolderOwnership(block.number, block.timestamp, dappboxfolder, _from, _to, _OwnershipOfFrom, _OwnershipOfTo));
    emit FolderOwnerShipEvent(block.number, block.timestamp,  dappboxfolder, _from, _to,  _OwnershipOfFrom, _OwnershipOfTo);
  }
  
  /**
  * @dev use to check if the documents exists or not
  * @param _hash hash of the document
  */
  function documentOwnershipExists(bytes32 _hash) view public returns (bool exists){
    if (usedFileHashes[_hash]) {
      exists = true;
    }else{
      exists= false;
    }
    return exists;
  }
  
  function folderOwnershipExists(address dappboxfolder) view public returns (bool exists){
    if (usedFoldersAddress[dappboxfolder]) {
      exists = true;
    }else{
      exists= false;
    }
    return exists;
  }

  /**
  * @dev returns the total number of documents/hashes
  */
  function getCountLatest() view public returns (uint256 latest){
      if(documentOwnershipCount < folderOwnershipCount){ 
      return folderOwnershipCount;
      }
      else {
      return documentOwnershipCount;
      }
      
  }
}
