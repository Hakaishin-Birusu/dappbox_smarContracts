pragma solidity >=0.4.21 <0.6.0;

import "./DocNotarizationManagement.sol";
import "./DocumentAccessRightsDefinition.sol";

/// @title PermissionManagement
/// @author Ashwin Arora
contract DocPermissionManagement is DocNotarizationManagement, DocumentAccessRightsDefinition{

  
  constructor() public{
    owner = msg.sender;
  }

  /**
  * @dev use to create a new document with new hash
  * @param _hash hash of the document
  */
  function newDocument(bytes32 _hash) public {
    require(!documentExists(_hash), "Document Already exist");

    ++documentCount;
    permissionOf[_hash].master = msg.sender;
    pushAddress(msg.sender);
    usedHashes[_hash] = true;
    dochistory.push(DocumentAccessRight(block.number, block.timestamp, _hash, msg.sender, msg.sender, PermissionType.master, PermissionType.master));
    emit NewDocument(_hash, msg.sender, block.number);
  }
  
  /**
  * @dev used to chang the master, caller will loose master access and _delegate will gain master access
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param _hash hash of the document
  */
  function changeMaster(address dAppBoxOrigin,address _delegate, bytes32 _hash) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exist");
    require(checkPermission(msg.sender, _hash) == PermissionType.master, "Access Denied");
    pushAddress(_delegate);
    permissionOf[_hash].master = _delegate;
    emit NewDocument(_hash, msg.sender, block.number);
    transferDocument( _hash, msg.sender, _delegate, PermissionType.master, PermissionType.master);
  }

  /**
  * @dev use to check what permissions the caller hash
  * @param _hash hash of the document
  */
  function checkYourPermission(bytes32 _hash) public view returns(PermissionType){
    require(documentExists(_hash), "Document does not exist");
    return checkPermission(msg.sender, _hash);
  }

  /**
  * @dev use to check what permissions the delegate hash
  * @param _delegate Ethereum address of whos permission is to be checked
  * @param _hash hash of the document
  */
  function checkDelegatePermission(address _delegate, bytes32 _hash) public view returns (PermissionType) {
    require(documentExists(_hash), "Document does not exist");
    if(checkPermission(msg.sender, _hash) != PermissionType.none ){
      return checkPermission(_delegate, _hash);
    }else{
      revert ("Access Denied");
    }
  }

  /**
  * @dev use to delegate owner access to any ethereum address
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param _hash hash of the document
  */
  function delegatePermanentOwner(address dAppBoxOrigin, address _delegate, bytes32 _hash) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exist");
    require(permissionOf[_hash].master == msg.sender, "Caller does not has master access");
    require(checkPermission(_delegate, _hash) == PermissionType.none, "Delegate already exists");
    pushAddress(_delegate);
    permissionOf[_hash].isBaseRestricted[_delegate] = false;
    permissionOf[_hash].DelegatedOwners[_delegate] = true;
    permissionOf[_hash].ownerLength++;
    transferDocument( _hash, msg.sender, _delegate, PermissionType.master, PermissionType.owner);
  }

  /**
  * @dev use to remove owner access of existing owner
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param _hash hash of the document
  */
  function removePermanentOwner(address dAppBoxOrigin,address _delegate, bytes32 _hash) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exist");
    require(checkPermission(msg.sender, _hash) == PermissionType.master, "Sender does not has master access");
    //require(permissionOf[_hash].master == msg.sender, "Caller does not has master access");
    require(checkPermission(_delegate, _hash) == PermissionType.owner, "Not an owner");

    permissionOf[_hash].DelegatedOwners[_delegate] = false;
    permissionOf[_hash].ownerLength--;
    transferDocument( _hash, msg.sender, _delegate, PermissionType.master, PermissionType.none);
  }

  /**
    * @dev use to delegate owner permission with time bounds
    * @param _delegate Ethereum address to whom permission is to be delegated
    * @param _hash hash of the document
    * @param _fromTime Time from which the delegate has access
    * @param _toTime Time till which the delegate has access
    */
  function delegateTimeRestrictedOwner(address dAppBoxOrigin,address _delegate, bytes32 _hash, uint256 _fromTime, uint256 _toTime) public returns(string memory){
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exist");
    require(block.timestamp <= _fromTime && _fromTime < _toTime, "Invalid time bounds." );
    require(checkPermission(_delegate, _hash) == PermissionType.none, "Delegate already exists");
    PermissionType permissionOfCaller = checkPermission(msg.sender, _hash);
    require(permissionOfCaller == PermissionType.master, "Access Denied");
    pushAddress(_delegate);
    if(permissionOf[_hash].writeTime[_delegate].toTime < block.timestamp &&  permissionOf[_hash].readTime[_delegate].toTime < block.timestamp){
      permissionOf[_hash].isBaseRestricted[_delegate] = true;
      permissionOf[_hash].isDelegatedOwnerRestricted[_delegate] = true;
      permissionOf[_hash].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
      permissionOf[_hash].DelegatedOwnersTime[_delegate].toTime = _toTime;
      emit TimeRestrictedPermission(block.number, block.timestamp, _hash, msg.sender, _delegate, permissionOfCaller, PermissionType.owner, _fromTime, _toTime);
      return "success";
    }else{
     // revert("Delegate already exists");
      return "failure";
    }
  }

  /**
  * @dev use to remove Owner permission with time bounds
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param _hash hash of the document
  */
 
 
  function removeTimeRestrictedOwner(address dAppBoxOrigin,address _delegate, bytes32 _hash) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exist");
    require(permissionOf[_hash].isDelegatedOwnerRestricted[_delegate] == true, "Delegate does not exist.");
    //require(permissionOf[_hash].ownerTime[_delegate].toTime >= block.timestamp, "");
    PermissionType permissionOfCaller = checkPermission(msg.sender, _hash);
    require(permissionOfCaller == PermissionType.master, "Access Denied");

    permissionOf[_hash].isDelegatedOwnerRestricted[_delegate] = false;
    permissionOf[_hash].DelegatedOwnersTime[_delegate].fromTime = 0;
    permissionOf[_hash].DelegatedOwnersTime[_delegate].toTime = 0;
    emit TimeRestrictedPermission(block.number, block.timestamp, _hash, msg.sender, _delegate, permissionOfCaller, PermissionType.none, 0,0);
  }

  /**
  * @dev use to delegate write access to any ethereum address
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param _hash hash of the document
  */
  function delegatePermanentWrite(address dAppBoxOrigin,address _delegate, bytes32 _hash) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exist");
    require(checkPermission(_delegate, _hash) == PermissionType.none, "Delegate already exists");
    PermissionType permissionOfCaller = checkPermission(msg.sender,_hash);
    require(permissionOfCaller == PermissionType.master || permissionOfCaller == PermissionType.owner, "Access Denied");
    pushAddress(_delegate);
    permissionOf[_hash].isBaseRestricted[_delegate] = false;
    permissionOf[_hash].write[_delegate] = true;
    permissionOf[_hash].writeLength++;
    transferDocument( _hash, msg.sender, _delegate, permissionOfCaller ,PermissionType.write);
  }
  /**
  * @dev use to remove write access of any ethereum address
  * @param _delegate Ethereum address of whos permission is to be removed
  * @param _hash hash of the document
  */
  function removePermanentWrite(address dAppBoxOrigin,address _delegate, bytes32 _hash) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exist");
    require(checkPermission(_delegate, _hash) == PermissionType.write, "Delegate does not exist.");
    PermissionType permissionOfCaller = checkPermission(msg.sender, _hash);
    require(permissionOfCaller == PermissionType.master || permissionOfCaller == PermissionType.owner, "Access Denied");

    permissionOf[_hash].write[_delegate] = false;
    permissionOf[_hash].writeLength--;
    transferDocument( _hash, msg.sender, _delegate, permissionOfCaller, PermissionType.none);
  }

  /**
  * @dev use to delegate write permission with time bounds
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param _hash hash of the document
  * @param _fromTime Time from which the delegate has access
  * @param _toTime Time till which the delegate has access
  */
  function delegateTimeRestrictedWrite(address dAppBoxOrigin,address _delegate, bytes32 _hash, uint256 _fromTime, uint256 _toTime) public returns(string memory){
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exists");
    require(block.timestamp <= _fromTime && _fromTime < _toTime, "Invalid time bounds." );
    require(checkPermission(_delegate, _hash) == PermissionType.none, "Delegate already exists");
    PermissionType permissionOfCaller = checkPermission(msg.sender, _hash);
    require(permissionOfCaller == PermissionType.master || permissionOfCaller == PermissionType.owner, "Access Denied");
    pushAddress(_delegate);
    if(permissionOf[_hash].DelegatedOwnersTime[_delegate].toTime < block.timestamp &&  permissionOf[_hash].readTime[_delegate].toTime < block.timestamp){
      permissionOf[_hash].isBaseRestricted[_delegate] = true;
      permissionOf[_hash].isWriteRestricted[_delegate] = true;
      permissionOf[_hash].writeTime[_delegate].fromTime = _fromTime;
      permissionOf[_hash].writeTime[_delegate].toTime = _toTime;
      emit TimeRestrictedPermission(block.number, block.timestamp, _hash, msg.sender, _delegate, permissionOfCaller, PermissionType.write, _fromTime, _toTime);
      return "success";
    }else{
      //revert("Delegate already exists");
      return "failure";
    }
  }

  /**
  * @dev use to remove write permission with time bounds
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param _hash hash of the document
  */
  function removeTimeRestrictedWrite(address dAppBoxOrigin,address _delegate, bytes32 _hash) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exists");
    require(permissionOf[_hash].isWriteRestricted[_delegate] == true, "Delegate does not exist.");
    PermissionType permissionOfCaller = checkPermission(msg.sender, _hash);
    require(permissionOfCaller == PermissionType.master || permissionOfCaller == PermissionType.owner, "Access Denied");

    permissionOf[_hash].isWriteRestricted[_delegate] = false;
    permissionOf[_hash].writeTime[_delegate].fromTime = 0;
    permissionOf[_hash].writeTime[_delegate].toTime = 0;
    emit TimeRestrictedPermission(block.number, block.timestamp, _hash, msg.sender, _delegate, permissionOfCaller, PermissionType.none, 0, 0);
  }

  /**
  * @dev use to temporarily upgrade read access of an address to write access
  * @param _delegate Ethereum address whos permission is to be temporarily upgarded
  * @param _hash hash of the document
  * @param _fromTime Time from which the delegate has upgraded write access
  * @param _toTime Time till which the delegate has upgraded write access
  */
  function upgradeToWrite(address dAppBoxOrigin,address _delegate, bytes32 _hash, uint256 _fromTime, uint256 _toTime) public returns(bool success){
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exists");
    require(block.timestamp <= _fromTime && _fromTime < _toTime, "Invalid Time Bounds.");
    require(permissionOf[_hash].writeTime[_delegate].toTime < block.timestamp);
    PermissionType permissionOfCaller = checkPermission(msg.sender, _hash);
    require(permissionOfCaller == PermissionType.master || permissionOfCaller == PermissionType.owner, "Access Denied");

    PermissionType permissionOfDelegate = checkPermission(_delegate, _hash);
    pushAddress(_delegate);
    if(permissionOf[_hash].isBaseRestricted[_delegate] == false){
      if(permissionOfDelegate == PermissionType.read){
        permissionOf[_hash].isTemporarilyUpgraded[_delegate] = true;
        permissionOf[_hash].isWriteRestricted[_delegate] = true;
        permissionOf[_hash].writeTime[_delegate].fromTime = _fromTime;
        permissionOf[_hash].writeTime[_delegate].toTime = _toTime;
        success = true;
        return success;
      }else{
        revert("Base Permission Invalid");
      }
    }else if(permissionOf[_hash].isBaseRestricted[_delegate] == true){
      if(permissionOf[_hash].readTime[_delegate].toTime > block.timestamp){
        if(permissionOf[_hash].readTime[_delegate].fromTime <= _fromTime && permissionOf[_hash].readTime[_delegate].toTime >= _toTime){
          permissionOf[_hash].isTemporarilyUpgraded[_delegate] = true;
          permissionOf[_hash].isWriteRestricted[_delegate] = true;
          permissionOf[_hash].writeTime[_delegate].fromTime = _fromTime;
          permissionOf[_hash].writeTime[_delegate].toTime = _toTime;
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
  * @param _hash hash of the document
  */
  function delegatePermanentRead(address dAppBoxOrigin,address _delegate, bytes32 _hash) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exist");
    require(checkPermission(_delegate, _hash) == PermissionType.none, "Delegate already exists");
    PermissionType permissionOfCaller = checkPermission(msg.sender, _hash);
    require(permissionOfCaller != PermissionType.none, "Access Denied");
    pushAddress(_delegate);
    permissionOf[_hash].isBaseRestricted[_delegate] = false;
    permissionOf[_hash].read[_delegate] = true;
    permissionOf[_hash].readLength++;
    transferDocument( _hash, msg.sender, _delegate, permissionOfCaller, PermissionType.read);
  }

  /**
  * @dev use to remove read access of any ethereum address
  * @param _delegate Ethereum address of whos permission is to be removed
  * @param _hash hash of the document
  */
  function removePermanentRead(address dAppBoxOrigin,address _delegate, bytes32 _hash) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exist");
    require(checkPermission(_delegate, _hash) == PermissionType.read, "Delegate does not exist.");
    PermissionType permissionOfCaller = checkPermission(msg.sender, _hash);
    require(permissionOfCaller != PermissionType.read && permissionOfCaller != PermissionType.none, "Access Denied");

    permissionOf[_hash].read[_delegate] = false;
    permissionOf[_hash].readLength--;
    transferDocument( _hash, msg.sender, _delegate, permissionOfCaller, PermissionType.none);
  }

  /**
  * @dev use to delegate Read permission with time bounds
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param _hash hash of the document
  * @param _fromTime Time from which the delegate has access
  * @param _toTime Time till which the delegate has access
  */
  function delegateTimeRestrictedRead(address dAppBoxOrigin ,address _delegate, bytes32 _hash, uint256 _fromTime, uint256 _toTime) public returns(string memory){
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exist");
    require(block.timestamp <= _fromTime && _fromTime < _toTime, "Invalid time bounds." );
    require(checkPermission(_delegate,_hash) == PermissionType.none, "Delegate already exists.");
    PermissionType permissionOfCaller = checkPermission(msg.sender, _hash);
    require(permissionOfCaller != PermissionType.none, "Access Denied");
    pushAddress(_delegate);
    if(permissionOf[_hash].DelegatedOwnersTime[_delegate].toTime < block.timestamp &&  permissionOf[_hash].writeTime[_delegate].toTime < block.timestamp){
      permissionOf[_hash].isBaseRestricted[_delegate] = true;
      permissionOf[_hash].isReadRestricted[_delegate] = true;
      permissionOf[_hash].readTime[_delegate].fromTime = _fromTime;
      permissionOf[_hash].readTime[_delegate].toTime = _toTime;
      emit TimeRestrictedPermission(block.number, block.timestamp, _hash, msg.sender, _delegate, permissionOfCaller, PermissionType.read, _fromTime, _toTime);
      return "success";
    }else{
      //revert("Delegate already exists");
      return "failure";
    }
  }

  /**
  * @dev use to remove Read permission with time bounds
  * @param _delegate Ethereum address to whom permission is to be delegated
  * @param _hash hash of the document
  */
  function removeTimeRestrictedRead(address dAppBoxOrigin,address _delegate, bytes32 _hash) public{
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(documentExists(_hash), "Document does not exist");
    require(permissionOf[_hash].isReadRestricted[_delegate] == true, "Delegate does not exist.");
    PermissionType permissionOfCaller = checkPermission(msg.sender, _hash);
    require(permissionOfCaller != PermissionType.read && permissionOfCaller != PermissionType.none, "Access Denied");

    permissionOf[_hash].isReadRestricted[_delegate] = false;
    permissionOf[_hash].readTime[_delegate].fromTime = 0;
    permissionOf[_hash].readTime[_delegate].toTime = 0;
    emit TimeRestrictedPermission(block.number, block.timestamp, _hash, msg.sender, _delegate, permissionOfCaller, PermissionType.none, 0, 0);
  }
  function getDocumentRights(bytes32 _hash, uint index) view public returns(address accountAddress, PermissionType permpermission, uint256[] memory, uint256[] memory, uint256[] memory, bool next){
    require(documentExists(_hash), "Document does not exist");
    address  delegateAddress = permissionAddresses[index];
    PermissionType permanent = checkPermanentPermission(delegateAddress, _hash);
    if(permissionOf[_hash].master == delegateAddress){
      permanent = PermissionType.master;
    }
    uint256[] memory ownerTimeBound = new uint256[](2); 
    ownerTimeBound[0] = permissionOf[_hash].DelegatedOwnersTime[delegateAddress].fromTime;
    ownerTimeBound[1] = permissionOf[_hash].DelegatedOwnersTime[delegateAddress].toTime;
    uint256[] memory writeTimeBound = new uint256[](2); 
    writeTimeBound[0] = permissionOf[_hash].writeTime[delegateAddress].fromTime;
    writeTimeBound[1] = permissionOf[_hash].writeTime[delegateAddress].toTime;
    uint256[] memory readTimeBound = new uint256[](2); 
    readTimeBound[0] = permissionOf[_hash].readTime[delegateAddress].fromTime;
    readTimeBound[1] = permissionOf[_hash].readTime[delegateAddress].toTime;
    if (permissionAddresses.length - 1 > index){
      return (delegateAddress, permanent, ownerTimeBound, writeTimeBound, readTimeBound, true);
    } else {
      return (delegateAddress, permanent, ownerTimeBound, writeTimeBound, readTimeBound, false);
    }
  }
}
