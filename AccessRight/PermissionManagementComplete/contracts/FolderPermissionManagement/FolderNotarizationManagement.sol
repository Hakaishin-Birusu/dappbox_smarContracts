pragma solidity >=0.4.21 <0.6.0;

contract FolderNotarizationManagement{
  address owner;

  uint folderCount;

  enum PermissionType {master, owner, write, read, none}


   struct FolderAccessRight {
    uint blockNumber;
    uint timestamp;
    address dappboxfolder;
    address from;
    address to;
    PermissionType permissionOfFrom;
    PermissionType permissionOfTo;
  }

  FolderAccessRight[] foldhistory;
  
  mapping(address => bool) public usedFolders;

   event FolderEvent(uint blockNumber, uint blockTimeStamp, address dappboxfolder, address from, address to, PermissionType permissionOfFrom, PermissionType permissionOfTo);

  /**
  * @dev use to add history of transfers and emit transfer event
  * @param dappboxfolder dappbox folder address
  * @param _from address from whom the transfer is originated
  * @param _to addess to whom transfer is done
  * @param _permissionOfFrom enum PermissionType of delegator
  * @param _permissionOfFrom enum PermissionType of delegated
  */

  function transferFolder(address dappboxfolder, address _from, address _to, PermissionType _permissionOfFrom, PermissionType _permissionOfTo) internal{
    foldhistory.push(FolderAccessRight(block.number, block.timestamp, dappboxfolder, _from, _to, _permissionOfFrom, _permissionOfTo));
    emit FolderEvent(block.number, block.timestamp,  dappboxfolder, _from, _to, _permissionOfFrom, _permissionOfTo);
  }
  
  /**
  * @dev use to check if the documents exists or not
  * @param dappboxfolder dappbox folder address
  */
  
  function folderExists(address dappboxfolder) view internal returns (bool exists){
    if (usedFolders[dappboxfolder]) {
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
      return folderCount;
      
  }
}
