pragma solidity >=0.4.21 <0.6.0;
import "./FolderNotarizationManagement.sol";
// import "./PermissionManagement.sol";
/// @title PermissionManagement
/// @author Ashwin Arora
//  @updateBy Md Shadab Alam

contract FolderAccessRightsDefinition is FolderNotarizationManagement{
   //struct to hold permissions of respective hashes
  struct Permissions{
    address master;
    mapping(address => bool) DelegatedOwners;
    mapping(address => bool) write;
    mapping(address => bool) read;
    uint ownerLength;
    uint writeLength;
    uint readLength;
    mapping(address => bool) isBaseRestricted;
    mapping(address => bool) isTemporarilyUpgraded;
    mapping(address => bool) isUpgradedAgain;
    mapping(address => TimeBounds) DelegatedOwnersTime;
    mapping(address => TimeBounds) writeTime;
    mapping(address => TimeBounds) readTime;
    mapping(address => bool) isDelegatedOwnerRestricted;
    mapping(address => bool) isWriteRestricted;
    mapping(address => bool) isReadRestricted;
  }
  //how to access above varibles-
  //permissionOf[_hash].DelegatedOwners[_delegate]
  //permissionOf[_hash].DelegatedOwnersTime[_delegate].fromTime
  //permissiosOf[_hash].isBaseRestricted[_delegate]

  /*
  struct AddressDetails{
    bool isBaseRestricted;
    bool isTemporarilyUpgraded;
    bool isUpgradedAgain;
  }
  */

  struct TimeBounds{
    uint256 fromTime;
    uint256 toTime;
  }
  address[] permissionAddresses;
  mapping(address => bool) addressPresent;

  //maps to all the permissions of a particular hash
  //bytes32 to store the hash
  mapping(address => Permissions) permissionOf;

  event NewFolder(address folderAddress, address master, uint blockNumber);

  event TimeRestrictedPermission(
    uint blockNumber,
    uint blockTimeStamp,
    address folderAddress,
    address from,
    address to,
    PermissionType permissionOfFrom,
    PermissionType permissionOfTo,
    uint256 fromTime,
    uint256 toTime
  );

  event TemporaryPermission(
    uint blockNumber,
    uint blockTimeStamp,
    address folderAddress,
    address from,
    address to,
    PermissionType permissionOfFrom,
    PermissionType permissionOfTo,
    uint256 fromTime,
    uint256 toTime
  );
  
  /**
  * @dev use to check what permissions the delegate hash
  * @param _delegate Ethereum address of whos permission is to be checked
  * @param _folderAddress folderAddress of the NewFolder
  */
  function checkPermission(address _delegate, address _folderAddress) internal view returns (PermissionType){
    if(permissionOf[_folderAddress].master == _delegate){
      return PermissionType.master;
    }
    //checking if the delegte's permission are time restricted or not
    if(permissionOf[_folderAddress].isBaseRestricted[_delegate] == false){
      //checking if there is any upgrade
      if(permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] == true){
        PermissionType timeRestrictedPermission = checkTimedPermission(_delegate, _folderAddress);
        if(timeRestrictedPermission != PermissionType.none){
          return timeRestrictedPermission;
        }else{
          return checkPermanentPermission(_delegate,_folderAddress);
        }
      }else{
        return checkPermanentPermission(_delegate, _folderAddress);
      }
    }else if(permissionOf[_folderAddress].isBaseRestricted[_delegate] == true){
      return checkTimedPermission(_delegate,_folderAddress);
    }else{
      return PermissionType.none;
    }
  }
   /**
  * @dev use to check just the base permission of delegate
  * @param _delegate Ethereum address of whos permission is to be checked
  * @param _folderAddress folderAddress of the NewFolder
  */
  function checkTimedPermission(address _delegate, address _folderAddress) private view returns(PermissionType){
    if(permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime <= now && permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime > now){
      return PermissionType.owner;
    }else if(permissionOf[_folderAddress].writeTime[_delegate].fromTime <= now && permissionOf[_folderAddress].writeTime[_delegate].toTime > now){
      return PermissionType.write;
    }else if(permissionOf[_folderAddress].readTime[_delegate].fromTime <= now && permissionOf[_folderAddress].readTime[_delegate].toTime > now){
      return PermissionType.read;
    }else{
      return PermissionType.none;
    }
  }
  /**
  * @dev use to check just the base permission of delegate
  * @param _delegate Ethereum address of whos permission is to be checked
  * @param _folderAddress folderAddress of the NewFolder
  */
  function checkPermanentPermission(address _delegate, address _folderAddress) internal view returns(PermissionType){
    if(isOwner(_delegate, _folderAddress)){
      return PermissionType.owner;
    }else if(isWriter(_delegate, _folderAddress)){
      return PermissionType.write;
    }else if(isReader(_delegate, _folderAddress)){
      return PermissionType.read;
    }else{
      return PermissionType.none;
    }
  }
    /**
  * @dev use to check if the delegate has owner exists
  * @param _delegate Ethereum address of whos owner access is being checked
  * @param _folderAddress folderAddress of the NewFolder
  */
  function isOwner(address _delegate, address _folderAddress) private view returns (bool){
    if(permissionOf[_folderAddress].DelegatedOwners[_delegate] == true){
      return true;
    }else{
      return false;
    }
  }

  /**
  * @dev use to check if has delegate has owner exists
  * @param _delegate Ethereum address of whos write access is being checked
  * @param _folderAddress folderAddress of the NewFolder
  */
  function isWriter(address _delegate, address _folderAddress) private view returns (bool){
    if(permissionOf[_folderAddress].write[_delegate] == true){
      return true;
    }else{
      return false;
    }
  }

  /**
  * @dev use to check if has delegate has read exists
  * @param _delegate Ethereum address of whos read access is being checked
  * @param _folderAddress folderAddress of the NewFolder
  */
  function isReader(address _delegate, address _folderAddress) private view returns (bool){
    if(permissionOf[_folderAddress].read[_delegate] == true){
      return true;
    }else{
      return false;
    }
  }

  function pushAddress(address _delegate) internal {
    if (addressPresent[_delegate] == false){
      addressPresent[_delegate] = true;
      permissionAddresses.push(_delegate);
    }
  }

   /**
  * @dev use to temporarily upgrade read or write access of an address to owner access
  * @param _delegate Ethereum address whos permission is to be temporarily upgarded
  * @param _folderAddress folderAddress of the document
  * @param _fromTime Time from which the delegate has upgraded write access
  * @param _toTime Time till which the delegate has upgraded write access
  */
  function upgradeToOwner(address dAppBoxOrigin,address _delegate, address _folderAddress, uint256 _fromTime, uint256 _toTime) public returns (bool success){
    require(msg.sender == dAppBoxOrigin,"authentication failed");
    require(folderExists(_folderAddress), "Folder does not exists");
    require(block.timestamp <= _fromTime && _fromTime < _toTime, "Invalid Time Bounds.");
    require(permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime < block.timestamp);
    PermissionType permissionOfCaller = checkPermission(msg.sender, _folderAddress);
    require(permissionOfCaller == PermissionType.master , "Access Denied");

    PermissionType permissionOfDelegate = checkPermission(_delegate, _folderAddress);
    pushAddress(_delegate);
    //checking if the base permission is restricted of not
    //in case base permission is not restricted
    if(permissionOf[_folderAddress].isBaseRestricted[_delegate] == false){
      //Delegate's Permission can be write in 2 cases
      //1. Base Permission is write
      //2. Base Permission is Read and delegate was previously granted temporary write upgrade
      if(permissionOfDelegate == PermissionType.write){
        //Case 2. Base Permission is Read and delegate is previously granted temporary write upgrade
        if(permissionOf[_folderAddress].writeTime[_delegate].toTime > block.timestamp){
          //checking if given time bounds are inside temporarily upgraded write time bounds
          if(permissionOf[_folderAddress].writeTime[_delegate].toTime > _toTime){
            permissionOf[_folderAddress].isUpgradedAgain[_delegate] = true;
            permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
            success = true;
            return success;
          }// in case given time bounds begin after the end of write time bounds
          else if(permissionOf[_folderAddress].writeTime[_delegate].toTime < _fromTime){
            permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
            permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
            success = true;
            return success;
          }else{
            revert("Given Time Bounds are conflicting");
          }
        }
        //Case 1. Base Permission is Write
        else{
          permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
          permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
          permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
          permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
          success = true;
          return success;
        }
      }
      //Delegate's permission can be read in 2 cases
      //1. Base permission is Read with no write upgrades later in time
      //2. Base Permission is Read with write upgrade later in times
      else if(permissionOfDelegate == PermissionType.read){
        //Case 2. Base Permission is Read with write upgrades later in times
        if(permissionOf[_folderAddress].writeTime[_delegate].fromTime > block.timestamp){
          //in case given time bounds start and end before the start of write time bounds
          if(permissionOf[_folderAddress].writeTime[_delegate].fromTime > _toTime){
            permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
            permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
            success = true;
            return success;
          }
          //in case given time bounds are inside write time bounds
          else if(permissionOf[_folderAddress].writeTime[_delegate].fromTime < _fromTime && permissionOf[_folderAddress].writeTime[_delegate].toTime > _toTime){
            permissionOf[_folderAddress].isUpgradedAgain[_delegate] = true;
            permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
            success = true;
            return success;
          }
          // in case given time bounds begin after the end of write time bounds
          else if(permissionOf[_folderAddress].writeTime[_delegate].toTime < _fromTime){
            permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
            permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
            success = true;
            return success;
          }else{
            revert("Given Time Bounds are conflicting");
          }
        }
        // Case 1. Base permission is Read with no write upgrades later in time
        else{
          permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
          permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
          permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
          permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
          success = true;
          return success;
        }
      }else{
        revert("Base Permission Invalid");
      }
    }
    // in case base is restricted
    else if(permissionOf[_folderAddress].isBaseRestricted[_delegate] == true){
      //Delegates Permission can be read in 2 cases
      //1. Base Permission is read with no write upgrade later in time
      //2. Base Permission is Read with write upgrade later in times
      if(permissionOfDelegate == PermissionType.read){
        //Case 2.  Base Permission is Read with write upgrade later in times
        if(permissionOf[_folderAddress].writeTime[_delegate].toTime > block.timestamp){
          //in case time bounds start and end before the start of write time bounds
          if(permissionOf[_folderAddress].writeTime[_delegate].fromTime > _toTime){
            permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
            permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
            success = true;
            return success;
          }
          //in case given time bounds are inside write time bounds
          else if(permissionOf[_folderAddress].writeTime[_delegate].fromTime < _fromTime && permissionOf[_folderAddress].writeTime[_delegate].toTime > _toTime){
            permissionOf[_folderAddress].isUpgradedAgain[_delegate] = true;
            permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
            success = true;
            return success;
          }
          // in case given time bounds begin after the end of write time  bounds and are inside read time bounds
          else if(permissionOf[_folderAddress].writeTime[_delegate].toTime < _fromTime && permissionOf[_folderAddress].readTime[_delegate].toTime > _toTime){
            permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
            permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
            success = true;
            return success;
          }else{
            revert("Given Time Bounds are conflicting");
          }
        }
        //Case 2. Base Permission is read with no write upgrade later in time
        else{
          //checking if given time bounds are inside read time bounds
          if(permissionOf[_folderAddress].readTime[_delegate].toTime > _toTime){
            permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
            permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
            success = true;
            return success;
          }else{
            revert("Given Time Bounds are Confliting");
          }
        }
      }
      //Delegate's permission can be write in 2 cases
      //1. Base Permission is write
      //2. Base Permission is Read and delegate was previously granted temporary write upgrade
      else if(permissionOfDelegate == PermissionType.write){
        //Case 2. Base Permission is Read and delegate was previously granted temporary write upgrade
        if(permissionOf[_folderAddress].readTime[_delegate].toTime > block.timestamp){
          //checking if given time bounds are inside temporarily upgraded write time bounds
          if(permissionOf[_folderAddress].writeTime[_delegate].toTime > _toTime){
            permissionOf[_folderAddress].isUpgradedAgain[_delegate] = true;
            permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
            success = true;
            return success;
          }
          // in case given time bounds begin after the end of write time bounds
          // and checking if given time bounds end before the end of read time bounds
          else if(permissionOf[_folderAddress].writeTime[_delegate].toTime < _fromTime && permissionOf[_folderAddress].readTime[_delegate].toTime > _toTime){
            permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
            permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
            success = true;
            return success;
          }else{
            revert("Given Time Bounds are conflicting");
          }
        }
        //Case 1. Base Permission is write 
        else{  
          if(permissionOf[_folderAddress].writeTime[_delegate].toTime > _toTime){
            permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
            permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
            success = true;
            return success;
          }else{
            revert("Given Time Bounds are conflicting");
          }
        }
      }
      //Permission of delegate can be none when-
      //Delegate has time restricted write access begining later in time
      //Delegate has time restricted read access begining later in time
      else if(permissionOfDelegate == PermissionType.none){
        //Delegate's base permission can be read in 2 cases
        //1. read access is begining later in time with no temporary write upgrade
        //2. read access is begining later in time with temporary write upgrade
        if(permissionOf[_folderAddress].readTime[_delegate].fromTime > block.timestamp){
          //Case 2. read access is begining later in time with temporary write upgrade
          if(permissionOf[_folderAddress].writeTime[_delegate].fromTime > block.timestamp){
            //checking if given bounds
            //begin after the start of read time bounds
            //and end before the start of write time bounds
            if(permissionOf[_folderAddress].readTime[_delegate].fromTime < _fromTime && permissionOf[_folderAddress].writeTime[_delegate].fromTime >_toTime){
              permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
              permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
              permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
              permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
              success = true;
              return success;
            }
            //checking if given time bounds
            //begin after the start of write time bounds
            //and end before the end of write time bounds
            else if(permissionOf[_folderAddress].writeTime[_delegate].fromTime < _fromTime && permissionOf[_folderAddress].writeTime[_delegate].toTime >_toTime){
              permissionOf[_folderAddress].isUpgradedAgain[_delegate] = true;
              permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
              permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
              permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
              success = true;
              return success;
            }
            //checking if the given time bounds
            //begin after the end of write time bounds
            //and before the end of read bounds
            else if(permissionOf[_folderAddress].writeTime[_delegate].toTime < _fromTime && permissionOf[_folderAddress].readTime[_delegate].toTime > _toTime){
              permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
              permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
              permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
              permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
              success = true;
              return success;
            }else{
              revert("Given Time Bounds are conflicting");
            }
          }
          //Case 1. read access is begining later in time with no temporary write upgrade
          else{
            if(permissionOf[_folderAddress].readTime[_delegate].fromTime < _fromTime && permissionOf[_folderAddress].readTime[_delegate].toTime > _toTime){
              permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
              permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
              permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
              permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
              success = true;
              return success;
            }else{
              revert("Given Time Bounds are conflicting");
            }
          }
        }
        //in case delegate's base permissions is write begining later in time
        else if(permissionOf[_folderAddress].writeTime[_delegate].fromTime > block.timestamp){
          //checking if given time bounds are inside write time bounds
          if(permissionOf[_folderAddress].writeTime[_delegate].fromTime < _fromTime && permissionOf[_folderAddress].writeTime[_delegate].toTime > _toTime){
            permissionOf[_folderAddress].isTemporarilyUpgraded[_delegate] = true;
            permissionOf[_folderAddress].isDelegatedOwnerRestricted[_delegate] = true;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].fromTime = _fromTime;
            permissionOf[_folderAddress].DelegatedOwnersTime[_delegate].toTime = _toTime;
            success = true;
            return success;
          }else{
            revert("Given Time Bounds are conflicting");
          }

        }else{
          revert("Base Permission Invalid");
        }

      }else{
        revert("Base Permission Invalid");
      }

    }else{
      revert("Unexpected Failure");
    }
  }  
}