pragma solidity >=0.4.21 <0.6.0;

import "./FolderNotarizationManagement.sol";
import "./FolderAccessRightsDefinition.sol";

/// @title PermissionManagement
/// @author Ashwin Arora
contract FolderPermissionManagement is FolderNotarizationManagement, FolderAccessRightsDefinition{
  constructor() public{
    owner = msg.sender;
  }

  /**
  * @dev use to create a new document with new hash
  * @param dappboxfolder hash of the document
  */ 
  function newFolder(address dappboxfolder) public {
    require(!folderExists(dappboxfolder), "Document Already exist");

    ++folderCount;
    permissionOf[dappboxfolder].master = msg.sender;
    pushAddress(msg.sender);
    usedFolders[dappboxfolder] = true;
    foldhistory.push(FolderAccessRight(block.number, block.timestamp, dappboxfolder, msg.sender, msg.sender, PermissionType.master, PermissionType.master));
    emit NewFolder(dappboxfolder, msg.sender, block.number);
  }
  /**
  * @dev used to chang the master, caller will loose master access and _delegate will gain master access
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param dappboxfolder hash of the document
  */
  function changeMasterFolder(address dAppBoxOrigin,address _delegate, address dappboxfolder) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(folderExists(dappboxfolder), "Document does not exist");
    require(checkPermission(msg.sender, dappboxfolder) == PermissionType.master, "Access Denied");
    pushAddress(_delegate);
    permissionOf[dappboxfolder].master = _delegate;
    emit NewFolder(dappboxfolder, msg.sender, block.number);
    transferFolder(dappboxfolder, msg.sender, _delegate, PermissionType.master, PermissionType.master);
  }

  /**
  * @dev use to check what permissions the caller hash
  * @param dappboxfolder hash of the document
  */

  function checkYourPermissionFolder(address dappboxfolder) public view returns(PermissionType){
    require(folderExists(dappboxfolder), "Document does not exist");
    return checkPermission(msg.sender, dappboxfolder);
  }

  /**
  * @dev use to check what permissions the delegate hash
  * @param _delegate Ethereum address of whos permission is to be checked
  * @param dappboxfolder hash of the document
  */
  function checkDelegatePermissionFolder(address _delegate, address dappboxfolder) public view returns (PermissionType) {
    require(folderExists(dappboxfolder), "Document does not exist");
    if(checkPermission(msg.sender, dappboxfolder) != PermissionType.none ){
      return checkPermission(_delegate, dappboxfolder);
    }else{
      revert ("Access Denied");
    }
  }

  /**
  * @dev use to delegate owner access to any ethereum address
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param dappboxfolder hash of the document
  */
  function delegatePermanentOwnerFolder(address dAppBoxOrigin,address _delegate, address dappboxfolder) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(folderExists(dappboxfolder), "Document does not exist");
    require(permissionOf[dappboxfolder].master == msg.sender, "Caller does not has master access");
    require(checkPermission(_delegate, dappboxfolder) == PermissionType.none, "Delegate already exists");
    pushAddress(_delegate);
    permissionOf[dappboxfolder].isBaseRestricted[_delegate] = false;
    permissionOf[dappboxfolder].DelegatedOwners[_delegate] = true;
    permissionOf[dappboxfolder].ownerLength++;
    transferFolder( dappboxfolder, msg.sender, _delegate, PermissionType.master, PermissionType.owner);
  }

  /**
  * @dev use to remove owner access of existing owner
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param dappboxfolder hash of the document
  */
  function removePermanentOwnerFolder(address dAppBoxOrigin,address _delegate, address dappboxfolder) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(folderExists(dappboxfolder), "Document does not exist");
    require(checkPermission(msg.sender, dappboxfolder) == PermissionType.master, "Sender does not has master access");
    //require(permissionOf[dappboxfolder].master == msg.sender, "Caller does not has master access");
    require(checkPermission(_delegate, dappboxfolder) == PermissionType.owner, "Not an owner");

    permissionOf[dappboxfolder].DelegatedOwners[_delegate] = false;
    permissionOf[dappboxfolder].ownerLength--;
    transferFolder( dappboxfolder, msg.sender, _delegate, PermissionType.master, PermissionType.none);
  }



  /**
    * @dev use to delegate owner permission with time bounds
    * @param _delegate Ethereum address to whom permission is to be delegated
    * @param dappboxfolder hash of the document
    * @param _fromTime Time from which the delegate has access
    * @param _toTime Time till which the delegate has access
    */
  function delegateTimeRestrictedOwnerFolder(address dAppBoxOrigin,address _delegate, address dappboxfolder, uint256 _fromTime, uint256 _toTime) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(folderExists(dappboxfolder), "Document does not exist");
    require(block.timestamp <= _fromTime && _fromTime < _toTime, "Invalid time bounds." );
    require(checkPermission(_delegate, dappboxfolder) == PermissionType.none, "Delegate already exists");
    PermissionType permissionOfCaller = checkPermission(msg.sender, dappboxfolder);
    require(permissionOfCaller == PermissionType.master, "Access Denied");
    pushAddress(_delegate);
    if(permissionOf[dappboxfolder].writeTime[_delegate].toTime < block.timestamp &&  permissionOf[dappboxfolder].readTime[_delegate].toTime < block.timestamp){
      permissionOf[dappboxfolder].isBaseRestricted[_delegate] = true;
      permissionOf[dappboxfolder].isWriteRestricted[_delegate] = true;
      permissionOf[dappboxfolder].writeTime[_delegate].fromTime = _fromTime;
      permissionOf[dappboxfolder].writeTime[_delegate].toTime = _toTime;
      emit TimeRestrictedPermission(block.number, block.timestamp, dappboxfolder, msg.sender, _delegate, permissionOfCaller, PermissionType.owner, _fromTime, _toTime);
    }else{
      revert("Delegate already exists");
    }
  }

  /**
  * @dev use to remove Owner permission with time bounds
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param dappboxfolder hash of the document
  */
  function removeTimeRestrictedOwnerFolder(address dAppBoxOrigin ,address _delegate, address dappboxfolder) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(folderExists(dappboxfolder), "Document does not exist");
    require(permissionOf[dappboxfolder].isDelegatedOwnerRestricted[_delegate] == true, "Delegate does not exist.");
    PermissionType permissionOfCaller = checkPermission(msg.sender, dappboxfolder);
    require(permissionOfCaller == PermissionType.master, "Access Denied");

    permissionOf[dappboxfolder].isDelegatedOwnerRestricted[_delegate] = false;
    permissionOf[dappboxfolder].DelegatedOwnersTime[_delegate].fromTime = 0;
    permissionOf[dappboxfolder].DelegatedOwnersTime[_delegate].toTime = 0;
    emit TimeRestrictedPermission(block.number, block.timestamp, dappboxfolder, msg.sender, _delegate, permissionOfCaller, PermissionType.none, 0,0);
  }

 

  /**
  * @dev use to delegate write access to any ethereum address
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param dappboxfolder hash of the document
  */
  function delegatePermanentWriteFolder(address dAppBoxOrigin,address _delegate, address dappboxfolder) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(folderExists(dappboxfolder), "Document does not exist");
    require(checkPermission(_delegate, dappboxfolder) == PermissionType.none, "Delegate already exists");
    PermissionType permissionOfCaller = checkPermission(msg.sender,dappboxfolder);
    require(permissionOfCaller == PermissionType.master || permissionOfCaller == PermissionType.owner, "Access Denied");
    pushAddress(_delegate);
    permissionOf[dappboxfolder].isBaseRestricted[_delegate] = false;
    permissionOf[dappboxfolder].write[_delegate] = true;
    permissionOf[dappboxfolder].writeLength++;
    transferFolder( dappboxfolder, msg.sender, _delegate, permissionOfCaller ,PermissionType.write);
  }

  /**
  * @dev use to remove write access of any ethereum address
  * @param _delegate Ethereum address of whos permission is to be removed
  * @param dappboxfolder hash of the document
  */
  function removePermanentWriteFolder(address dAppBoxOrigin,address _delegate, address dappboxfolder) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(folderExists(dappboxfolder), "Document does not exist");
    require(checkPermission(_delegate, dappboxfolder) == PermissionType.write, "Delegate does not exist.");
    PermissionType permissionOfCaller = checkPermission(msg.sender, dappboxfolder);
    require(permissionOfCaller == PermissionType.master || permissionOfCaller == PermissionType.owner, "Access Denied");

    permissionOf[dappboxfolder].write[_delegate] = false;
    permissionOf[dappboxfolder].writeLength--;
    transferFolder( dappboxfolder, msg.sender, _delegate, permissionOfCaller, PermissionType.none);
  }


  /**
  * @dev use to delegate write permission with time bounds
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param dappboxfolder hash of the document
  * @param _fromTime Time from which the delegate has access
  * @param _toTime Time till which the delegate has access
  */
  function delegateTimeRestrictedWriteFolder(address dAppBoxOrigin,address _delegate, address dappboxfolder, uint256 _fromTime, uint256 _toTime) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(folderExists(dappboxfolder), "Document does not exists");
    require(block.timestamp <= _fromTime && _fromTime < _toTime, "Invalid time bounds." );
    require(checkPermission(_delegate, dappboxfolder) == PermissionType.none, "Delegate already exists");
    PermissionType permissionOfCaller = checkPermission(msg.sender, dappboxfolder);
    require(permissionOfCaller == PermissionType.master || permissionOfCaller == PermissionType.owner, "Access Denied");
    pushAddress(_delegate);
    if(permissionOf[dappboxfolder].DelegatedOwnersTime[_delegate].toTime < block.timestamp &&  permissionOf[dappboxfolder].readTime[_delegate].toTime < block.timestamp){
      permissionOf[dappboxfolder].isBaseRestricted[_delegate] = true;
      permissionOf[dappboxfolder].isWriteRestricted[_delegate] = true;
      permissionOf[dappboxfolder].writeTime[_delegate].fromTime = _fromTime;
      permissionOf[dappboxfolder].writeTime[_delegate].toTime = _toTime;
      emit TimeRestrictedPermission(block.number, block.timestamp, dappboxfolder, msg.sender, _delegate, permissionOfCaller, PermissionType.write, _fromTime, _toTime);
    }else{
      revert("Delegate already exists");
    }
  }

  /**
  * @dev use to remove write permission with time bounds
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param dappboxfolder hash of the document
  */
  function removeTimeRestrictedWriteFolder(address dAppBoxOrigin,address _delegate, address dappboxfolder) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(folderExists(dappboxfolder), "Document does not exists");
    require(permissionOf[dappboxfolder].isWriteRestricted[_delegate] == true, "Delegate does not exist.");
    PermissionType permissionOfCaller = checkPermission(msg.sender, dappboxfolder);
    require(permissionOfCaller == PermissionType.master || permissionOfCaller == PermissionType.owner, "Access Denied");

    permissionOf[dappboxfolder].isWriteRestricted[_delegate] = false;
    permissionOf[dappboxfolder].writeTime[_delegate].fromTime = 0;
    permissionOf[dappboxfolder].writeTime[_delegate].toTime = 0;
    emit TimeRestrictedPermission(block.number, block.timestamp, dappboxfolder, msg.sender, _delegate, permissionOfCaller, PermissionType.none, 0, 0);
  }

  /**
  * @dev use to temporarily upgrade read access of an address to write access
  * @param _delegate Ethereum address whos permission is to be temporarily upgarded
  * @param dappboxfolder hash of the document
  * @param _fromTime Time from which the delegate has upgraded write access
  * @param _toTime Time till which the delegate has upgraded write access
  */
  function upgradeToWriteFolder(address dAppBoxOrigin,address _delegate, address dappboxfolder, uint256 _fromTime, uint256 _toTime) public returns(bool success){
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(folderExists(dappboxfolder), "Document does not exists");
    require(block.timestamp <= _fromTime && _fromTime < _toTime, "Invalid Time Bounds.");
    require(permissionOf[dappboxfolder].writeTime[_delegate].toTime < block.timestamp);
    PermissionType permissionOfCaller = checkPermission(msg.sender, dappboxfolder);
    require(permissionOfCaller == PermissionType.master || permissionOfCaller == PermissionType.owner, "Access Denied");

    PermissionType permissionOfDelegate = checkPermission(_delegate, dappboxfolder);
    pushAddress(_delegate);
    if(permissionOf[dappboxfolder].isBaseRestricted[_delegate] == false){
      if(permissionOfDelegate == PermissionType.read){
        permissionOf[dappboxfolder].isTemporarilyUpgraded[_delegate] = true;
        permissionOf[dappboxfolder].isWriteRestricted[_delegate] = true;
        permissionOf[dappboxfolder].writeTime[_delegate].fromTime = _fromTime;
        permissionOf[dappboxfolder].writeTime[_delegate].toTime = _toTime;
        success = true;
        return success;
      }else{
        revert("Base Permission Invalid");
      }
    }else if(permissionOf[dappboxfolder].isBaseRestricted[_delegate] == true){
      if(permissionOf[dappboxfolder].readTime[_delegate].toTime > block.timestamp){
        if(permissionOf[dappboxfolder].readTime[_delegate].fromTime <= _fromTime && permissionOf[dappboxfolder].readTime[_delegate].toTime >= _toTime){
          permissionOf[dappboxfolder].isTemporarilyUpgraded[_delegate] = true;
          permissionOf[dappboxfolder].isWriteRestricted[_delegate] = true;
          permissionOf[dappboxfolder].writeTime[_delegate].fromTime = _fromTime;
          permissionOf[dappboxfolder].writeTime[_delegate].toTime = _toTime;
          success = true;
          return success;
        }else{
          revert("Given Time Bounds are outside Base Time Bounds");
        }
      }else{
        revert("Base Permission Invalid or Expired");
      }
    }else{
      revert("Unexpected Failure");
    }
  }
  /**
  * @dev use to delegate read access to any ethereum address
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param dappboxfolder hash of the document
  */
  function delegatePermanentReadFolder(address dAppBoxOrigin,address _delegate, address dappboxfolder) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(folderExists(dappboxfolder), "Document does not exist");
    require(checkPermission(_delegate, dappboxfolder) == PermissionType.none, "Delegate already exists");
    PermissionType permissionOfCaller = checkPermission(msg.sender, dappboxfolder);
    require(permissionOfCaller != PermissionType.none, "Access Denied");
    pushAddress(_delegate);
    permissionOf[dappboxfolder].isBaseRestricted[_delegate] = false;
    permissionOf[dappboxfolder].read[_delegate] = true;
    permissionOf[dappboxfolder].readLength++;
    transferFolder( dappboxfolder, msg.sender, _delegate, permissionOfCaller, PermissionType.read);
  }


  /**
  * @dev use to remove read access of any ethereum address
  * @param _delegate Ethereum address of whos permission is to be removed
  * @param dappboxfolder hash of the document
  */
  function removePermanentReadFolder(address dAppBoxOrigin ,address _delegate, address dappboxfolder) public{
    require(msg.sender == dAppBoxOrigin ,"authentication failed");
    require(folderExists(dappboxfolder), "Document does not exist");
    require(checkPermission(_delegate, dappboxfolder) == PermissionType.read, "Delegate does not exist.");
    PermissionType permissionOfCaller = checkPermission(msg.sender, dappboxfolder);
    require(permissionOfCaller != PermissionType.read && permissionOfCaller != PermissionType.none, "Access Denied");

    permissionOf[dappboxfolder].read[_delegate] = false;
    permissionOf[dappboxfolder].readLength--;
    transferFolder( dappboxfolder, msg.sender, _delegate, permissionOfCaller, PermissionType.none);
  }
  /**
  * @dev use to delegate Read permission with time bounds
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param dappboxfolder hash of the document
  * @param _fromTime Time from which the delegate has access
  * @param _toTime Time till which the delegate has access
  */
  function delegateTimeRestrictedReadFolder(address dAppBoxOrigin ,address _delegate, address dappboxfolder, uint256 _fromTime, uint256 _toTime) public{
    require(msg.sender == dAppBoxOrigin , "authentication failed");
    require(folderExists(dappboxfolder), "Document does not exist");
    require(block.timestamp <= _fromTime && _fromTime < _toTime, "Invalid time bounds." );
    require(checkPermission(_delegate,dappboxfolder) == PermissionType.none, "Delegate already exists.");
    PermissionType permissionOfCaller = checkPermission(msg.sender, dappboxfolder);
    require(permissionOfCaller != PermissionType.none, "Access Denied");
    pushAddress(_delegate);
    if(permissionOf[dappboxfolder].DelegatedOwnersTime[_delegate].toTime < block.timestamp &&  permissionOf[dappboxfolder].writeTime[_delegate].toTime < block.timestamp){
      permissionOf[dappboxfolder].isBaseRestricted[_delegate] = true;
      permissionOf[dappboxfolder].isReadRestricted[_delegate] = true;
      permissionOf[dappboxfolder].readTime[_delegate].fromTime = _fromTime;
      permissionOf[dappboxfolder].readTime[_delegate].toTime = _toTime;
      emit TimeRestrictedPermission(block.number, block.timestamp, dappboxfolder, msg.sender, _delegate, permissionOfCaller, PermissionType.read, _fromTime, _toTime);
    }else{
      revert("Delegate already exists");
    }
  }
  /**
  * @dev use to remove Read permission with time bounds
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param dappboxfolder hash of the document
  */
  function removeTimeRestrictedReadFolder(address dAppBoxOrigin, address _delegate, address dappboxfolder) public{
    require(msg.sender == dAppBoxOrigin ,"failed authentication");
    require(folderExists(dappboxfolder), "Document does not exist");
    require(permissionOf[dappboxfolder].isReadRestricted[_delegate] == true, "Delegate does not exist.");
    PermissionType permissionOfCaller = checkPermission(msg.sender, dappboxfolder);
    require(permissionOfCaller != PermissionType.read && permissionOfCaller != PermissionType.none, "Access Denied");

    permissionOf[dappboxfolder].isReadRestricted[_delegate] = false;
    permissionOf[dappboxfolder].readTime[_delegate].fromTime = 0;
    permissionOf[dappboxfolder].readTime[_delegate].toTime = 0;
    emit TimeRestrictedPermission(block.number, block.timestamp, dappboxfolder, msg.sender, _delegate, permissionOfCaller, PermissionType.none, 0, 0);
  }

  function getFolderRights(address dappboxfolder, uint index) view public returns(address accountAddress, PermissionType permpermission, uint256[] memory, uint256[] memory, uint256[] memory, bool next){
    require(folderExists(dappboxfolder), "Folder does not exist");
    address  delegateAddress = permissionAddresses[index]; 
    PermissionType permanent = checkPermanentPermission(delegateAddress, dappboxfolder);
    uint256[] memory ownerTimeBound = new uint256[](2); 
    ownerTimeBound[0] = permissionOf[dappboxfolder].DelegatedOwnersTime[delegateAddress].fromTime;
    ownerTimeBound[1] = permissionOf[dappboxfolder].DelegatedOwnersTime[delegateAddress].toTime;
    uint256[] memory writeTimeBound = new uint256[](2); 
    writeTimeBound[0] = permissionOf[dappboxfolder].writeTime[delegateAddress].fromTime;
    writeTimeBound[1] = permissionOf[dappboxfolder].writeTime[delegateAddress].toTime;
    uint256[] memory readTimeBound = new uint256[](2); 
    readTimeBound[0] = permissionOf[dappboxfolder].readTime[delegateAddress].fromTime;
    readTimeBound[1] = permissionOf[dappboxfolder].readTime[delegateAddress].toTime;
    if (permissionAddresses.length - 1 > index) {
      return (delegateAddress, permanent, ownerTimeBound, writeTimeBound, readTimeBound, true);
    } else {
      return (delegateAddress, permanent, ownerTimeBound, writeTimeBound, readTimeBound, false);
    }
  }
}
