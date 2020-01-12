pragma solidity >=0.4.21 <0.6.0;


contract dappboxManager
{

   /**
    * @dev struct to store different information regarding specific user 
    */
   struct Dictionary
   {
    address UserAddress;
    string UserName;
    uint256 RegistrationDate;
    string DefaultURL;
    string ShortenURL;
   }

   address[] allDappboxes;
   mapping(uint256 => Dictionary) dictionary ;

   struct fileInformation
   {
      string fileNameHash;
      string fileHash;
      string filePathHash;
      address folderAddress;
      uint256 creationTime;
      bool fileDeleted;
   }

   mapping(address => fileInformation[]) dappboxAllFiles;

   struct FolderInformation
   {
      string folderNameHash;
      string folderPathHash;
      address folderAddress;
      uint256 creationTime;
      bool folderDeleted;
   }
   struct SubFolderInformation
   {
      string folderNameHash;
      string folderPathHash;
      address folderAddress;
      address BeforeFolderAddress;
      uint256 creationTime;
      bool folderDeleted;
   }
   mapping(address => FolderInformation[]) dappboxAllFolders;

   mapping(address => SubFolderInformation[]) dappboxAllSubFolders;

   struct remoteFolderInformation
   {
      address originalOwner;
      address remoteFolderAddress;
      string folderNameHash;
      bool folderDeleted;

   }
   mapping(address => remoteFolderInformation[]) dappboxAllRemoteFolders;


   //should only be called once , whe new dappbox is created
   /**
    * @dev stores the details in a structure mapped to a public account of ixxo
    * This function can only be accessed by the deployeer of the contracts
    * @param _address : address of the entity whose information is to be stored // public user ethereum addresss
    * @param _userName : name of the user
    * @param _defaultURL  : default url generated at the time of register
    * @param _shortenURL : shortened url of the user
    * @return bool : on successful storage of user details
    */
   function addUsers(
      address dAppBoxOrigin,address _address , string memory _userName , string memory _defaultURL , string memory _shortenURL 
      )public  returns (bool)
   {
      require(msg.sender == dAppBoxOrigin,"Authentication failed");
      uint256 index = allDappboxes.push(msg.sender) - 1;
      Dictionary memory currentUserInfo;

      currentUserInfo.UserAddress = _address;
      currentUserInfo.UserName = _userName;
      currentUserInfo.RegistrationDate = block.timestamp;
      currentUserInfo.DefaultURL = _defaultURL;
      currentUserInfo.ShortenURL = _shortenURL;
      dictionary[index]=(currentUserInfo);

      return true ;
   }


   function addFileInformation(address dAppBoxOrigin,string memory _fileHash,string memory _fileNameHash,string memory _filePathHash,address _folderAddress) public returns(string memory, address)
   {
      require(msg.sender == dAppBoxOrigin,"authentication failed");
      uint256 createDate = block.timestamp;
      fileInformation memory currentInfo;
      currentInfo.fileNameHash = _fileNameHash;
      currentInfo.fileHash = _fileHash;
      currentInfo.filePathHash = _filePathHash;
      currentInfo.folderAddress = _folderAddress;
      currentInfo.creationTime = createDate;
      currentInfo.fileDeleted = false;
      dappboxAllFiles[dAppBoxOrigin].push(currentInfo);
      return (_fileHash,_folderAddress);
   }

   // now this funtion add the new folder info in contract and if folder already exists it updates it name hash 
   function addFolderInformation(address dAppBoxOrigin,string memory _folderPathHash, string memory _folderNameHash, address _folderAddress) public returns(address)
   {
      require(msg.sender == dAppBoxOrigin,"authentication failed");
      
      uint256 len = dappboxAllFolders[dAppBoxOrigin].length;
      for(uint256 i = 0 ; i< len ; i++)
      {
          if(_folderAddress == dappboxAllFolders[dAppBoxOrigin][i].folderAddress)
          {
             dappboxAllFolders[dAppBoxOrigin][i].folderNameHash = _folderNameHash;
             return _folderAddress;
          }
      }

      uint256 createDate = block.timestamp;
      FolderInformation memory currentInfo;
      currentInfo.folderNameHash = _folderNameHash;
      currentInfo.folderPathHash = _folderPathHash;
      currentInfo.folderAddress = _folderAddress;
      currentInfo.creationTime = createDate;
      currentInfo.folderDeleted = false;
      dappboxAllFolders[dAppBoxOrigin].push(currentInfo);
      return _folderAddress;
   }

   function addRemoteFolderInformation(address dAppBoxOrigin, string memory _folderNameHash,address _remoteFolderOriginalOwner, address _remoteFolderAddress) public returns(bool)
   {
      require(msg.sender == dAppBoxOrigin,"authentication failed");
      remoteFolderInformation memory currentInfo;
      currentInfo.originalOwner = _remoteFolderOriginalOwner;
      currentInfo.folderNameHash = _folderNameHash;
      currentInfo.remoteFolderAddress = _remoteFolderAddress;
      currentInfo.folderDeleted = false;
      dappboxAllRemoteFolders[dAppBoxOrigin].push(currentInfo);
      return true;
   }


   function addSubFolderInformation(address dAppBoxOrigin, string memory _folderPathHash, string memory _folderNameHash, address _folderAddress, address _BeforefolderAddress) public returns(address)
   {
      require(msg.sender == dAppBoxOrigin,"authentication failed");
      uint256 createDate = block.timestamp;
      SubFolderInformation memory currentInfo;
      currentInfo.folderNameHash = _folderNameHash;
      currentInfo.folderPathHash = _folderPathHash;
      currentInfo.folderAddress = _folderAddress;
      currentInfo.BeforeFolderAddress = _BeforefolderAddress;
      currentInfo.creationTime = createDate;
      dappboxAllSubFolders[dAppBoxOrigin].push(currentInfo);
      return _folderAddress;
   }

   /**
    * @dev get details of user by using address of the user
    * @param _Address address of user whose info if to be fetched // user ethereum public address
    NOTE : it returns expected value true if user dappbox has more user address
    */
   function getByAddress(address _Address , uint256 index) public view returns (string memory, uint256 , string memory , string memory,bool,uint256)
   {
      for(uint256 i=index ; i < allDappboxes.length ; i++)
      {
         if (_Address == dictionary[i].UserAddress)
         {
            index = i;
            break;
         }

      }
      if(index < allDappboxes.length -1)
      {
         return (dictionary[index].UserName,dictionary[index].RegistrationDate,dictionary[index].DefaultURL,dictionary[index].ShortenURL,true,++index);
      }
      else
      {
         return (dictionary[index].UserName,dictionary[index].RegistrationDate,dictionary[index].DefaultURL,dictionary[index].ShortenURL,false,0);
      }

   }

 /**
    * @dev fetch all details of users by using username
    * @param _UserName : name of the user by whic all other attributes are to be fetched 
    */
   function getByUserName(string memory _UserName) public view returns (address ,uint256 ,string memory ,string memory)
   {
      uint256 len = allDappboxes.length;
      for(uint256 i=0 ; i< len ; i++)
      { string memory String = (dictionary[i].UserName) ;

      bool res = compareStrings(_UserName ,String);
         if (res == true )
         {
            address Address = dictionary[i].UserAddress  ;
            uint256 Date = dictionary[i].RegistrationDate ;
            string memory DUrl = dictionary[i].DefaultURL ;
            string memory SUrl = dictionary[i].ShortenURL ;
                  
            return( Address ,Date , DUrl , SUrl);
         }

      }

   }
 /**
    * @dev fetch all the user information using URl
    * @param _DefaultURL : URl genrated at the time of Dappbox register 
    */
   function getByUrl(string memory _DefaultURL) public view returns (address , string memory, uint256 ,string memory)
   {
      uint256 len = allDappboxes.length;
      for(uint256 i=0 ; i< len ; i++)
      { 
          string memory URL1 =  dictionary[i].DefaultURL ; 
          bool res = compareStrings(_DefaultURL ,URL1);
         if (res == true)
         {
            address Address = dictionary[i].UserAddress  ;
            string memory Username = dictionary[i].UserName ;
            uint256 Date = dictionary[i].RegistrationDate ;
            string memory SUrl = dictionary[i].ShortenURL ;
                  
                  return(Address , Username , Date, SUrl);
         }

      }

   }


 /**
    * @dev fetch all the information about user using shortened url
    * @param _ShortenURl : shorneded url of the url generated by dappbox 
    */
   function getByShortUrl(string memory _ShortenURl) public view returns (address, string memory, uint256 , string memory)
   {
      uint256 len = allDappboxes.length;
      for(uint256 i=0 ; i< len ; i++)
      {
         string memory url = dictionary[i].ShortenURL ;  
         bool res  = compareStrings(_ShortenURl , url );
         if (res == true)
         {
            address Address = dictionary[i].UserAddress  ;
            string memory Username = dictionary[i].UserName ;
            uint256 Date = dictionary[i].RegistrationDate ;
            string memory DUrl = dictionary[i].DefaultURL ;
                  
            return (Address , Username , Date , DUrl);
         }

      }

   }


   /**
    * @dev compares two string on the basis of length and than does the hash comparison 
    * hash formed by strings
    * @param a : first string
    * @param b : second string
    */
   function compareStrings(string memory a, string memory b) internal pure returns (bool)
    {
    if(bytes(a).length != bytes(b).length) {
        return false;
    } else {
      return keccak256(abi.encode(a)) == keccak256(abi.encode(b));
    }
    }


    function returnAllDappboxes(uint256 index) public view returns(address,address,string memory,uint256,string memory,string memory,bool,uint256 )
    {
       require(index < allDappboxes.length,"index out of bounds");
            if(index < allDappboxes.length-1)
            {
       return(allDappboxes[index],dictionary[index].UserAddress,dictionary[index].UserName,dictionary[index].RegistrationDate,dictionary[index].DefaultURL,dictionary[index].ShortenURL,true,++index);
            }
      else
      {
      return(allDappboxes[index],dictionary[index].UserAddress,dictionary[index].UserName,dictionary[index].RegistrationDate,dictionary[index].DefaultURL,dictionary[index].ShortenURL,false,0);
      }
    }
   
   function returnAllDappboxFolders(address dappboxAddress ,uint256 index) public view returns(string memory,string memory,address , uint256,bool,bool)
   {
      
      string memory folderNameHash = dappboxAllFolders[dappboxAddress][index].folderNameHash;
      string memory folderPathHash = dappboxAllFolders[dappboxAddress][index].folderPathHash;
      bool folderDeleted = dappboxAllFolders[dappboxAddress][index].folderDeleted;
      address folderAddress = dappboxAllFolders[dappboxAddress][index].folderAddress;
      uint256 createTime = dappboxAllFolders[dappboxAddress][index].creationTime;
      uint256 len = dappboxAllFolders[dappboxAddress].length;
      index++;
      if(index < len)
      {
         return(folderNameHash,folderPathHash,folderAddress,createTime,folderDeleted,true);
      }
      else
      {
         return(folderNameHash,folderPathHash,folderAddress,createTime,folderDeleted,false);
      }
   }

   function returnAllDappboxSubFolders(address dappboxAddress ,uint256 index) public view returns(string memory,string memory , uint256,bool,bool)
   {
      
      string memory folderNameHash = dappboxAllSubFolders[dappboxAddress][index].folderNameHash;
      string memory folderPathHash = dappboxAllSubFolders[dappboxAddress][index].folderPathHash;
       bool folderDeleted = dappboxAllSubFolders[dappboxAddress][index].folderDeleted;
      uint256 createTime = dappboxAllSubFolders[dappboxAddress][index].creationTime;
      uint256 len = dappboxAllSubFolders[dappboxAddress].length;
      index++;
      if(index < len)
      {
         return(folderNameHash,folderPathHash,createTime,folderDeleted,true);
      }
      else
      {
         return(folderNameHash,folderPathHash,createTime,folderDeleted,false);
      }
   }

   function returnRemoteFolderInfo( address dappboxAddress,string memory folderNameHash) public view returns (address,address)
   {
      uint256 len = dappboxAllRemoteFolders[dappboxAddress].length;

      for(uint256 i=0;i<len;i++)
      {
         bool res = compareStrings(dappboxAllRemoteFolders[dappboxAddress][i].folderNameHash, folderNameHash);
         if (res == true && dappboxAllRemoteFolders[dappboxAddress][i].folderDeleted == false)
         {
            address originalOwner = dappboxAllRemoteFolders[dappboxAddress][i].originalOwner;
            address folderAddress = dappboxAllRemoteFolders[dappboxAddress][i].remoteFolderAddress;
            return (originalOwner,folderAddress);
         }
         
      }
      
      

   }

   function returnAllDappboxRemoteFolders(address dappboxAddress ,uint256 index) public view returns(string memory,address,address,bool,bool)
   {
      string memory folderNameHash = dappboxAllRemoteFolders[dappboxAddress][index].folderNameHash;
      address remoteFolderAddress = dappboxAllRemoteFolders[dappboxAddress][index].remoteFolderAddress;
      address originalOwner = dappboxAllRemoteFolders[dappboxAddress][index].originalOwner;
      bool isFolderDeleted = dappboxAllRemoteFolders[dappboxAddress][index].folderDeleted;
      uint256 len = dappboxAllRemoteFolders[dappboxAddress].length;
      index++;
      if(index < len)
      {
         return(folderNameHash,originalOwner,remoteFolderAddress,isFolderDeleted,true);
      }
      else
      {
         return(folderNameHash,originalOwner,remoteFolderAddress,isFolderDeleted,false);
      }
   }

   function returnNumberOfFilesInDappbox(address dappboxAddress) public view returns(uint256 ,uint256)
   {
      uint256 startingIndex = 0;
      uint256 totalLength = dappboxAllFiles[dappboxAddress].length;
      return(startingIndex,totalLength);
   }

   function returnAllFileFromFolder(address dappboxAddress , address folderAddress , uint256 index ) public view returns(string memory,string memory,string memory,bool,uint256)
   {
      uint256 len = dappboxAllFiles[dappboxAddress].length;
      for(uint256 i = index ; i < len ; i++)
      {
         if(folderAddress == dappboxAllFiles[dappboxAddress][i].folderAddress && dappboxAllFiles[dappboxAddress][i].fileDeleted == false )
         {
            string memory fileNameHash = dappboxAllFiles[dappboxAddress][i].fileNameHash;
            string memory fileHash = dappboxAllFiles[dappboxAddress][i].fileHash;
            string memory filePathHash = dappboxAllFiles[dappboxAddress][i].filePathHash;
            
            i++;
            if(i < len)
            {
               return (fileNameHash,filePathHash,fileHash,true,i); 
            }
            else
            {
               return (fileNameHash,filePathHash,fileHash,false,0); 
            }
         }
      }
   }

   function isRemoteFolder(address dappboxAddress, address remoteFolderAddress) public view returns(bool,address,uint256)
   {
       bool res = false;
       address originalOwner;
       uint256 index= 0;
       uint256 len = dappboxAllRemoteFolders[dappboxAddress].length;

       for(uint256 i = 0 ; i < len ; i++)
       {
           if(remoteFolderAddress == dappboxAllRemoteFolders[dappboxAddress][i].remoteFolderAddress)
          {
             res = true;
             originalOwner = dappboxAllRemoteFolders[dappboxAddress][i].originalOwner;
             break;
          }
       }
       return (res,originalOwner,index);     
   }


   function RemoveFile(address dappboxAddress,string memory fileNameMD5,string memory fileNameSHA256,string memory fileNameSHA1 ,address folderAddress) public returns(bool)  
   {
      uint256 len = dappboxAllFiles[dappboxAddress].length; 
      for(uint256 i = 0 ; i< len ; i++)
       {
          if (dappboxAllFiles[dappboxAddress][i].folderAddress == folderAddress)
          {
          bool flag = compareStrings(fileNameMD5,dappboxAllFiles[dappboxAddress][i].fileNameHash);
          bool flag1 = compareStrings(fileNameSHA256,dappboxAllFiles[dappboxAddress][i].fileNameHash);
          bool flag2 = compareStrings(fileNameSHA1,dappboxAllFiles[dappboxAddress][i].fileNameHash);
           if(flag == true || flag1 == true || flag2 == true)
         {
            dappboxAllFiles[dappboxAddress][i].fileDeleted = true;
            return true;
         }
       }
       }

      return false;
   }

   function removeRemoteFolder(address dappboxAddress , string memory folderNameHash) public returns(bool)
   {
      uint256 len = dappboxAllRemoteFolders[dappboxAddress].length;

      for(uint256 i=0;i<len;i++)
      {
         bool res = compareStrings(dappboxAllRemoteFolders[dappboxAddress][i].folderNameHash, folderNameHash);
         if (res == true)
         {
            dappboxAllRemoteFolders[dappboxAddress][i].folderDeleted = true;
            
         }
      }
      return true;   
   }

   function RemoveFolder(address dappboxAddress,address folderAddress) public 
   {
      uint256 len = dappboxAllFolders[dappboxAddress].length;
      for(uint256 i = 0 ; i< len ; i++)
      {
          if(folderAddress == dappboxAllFolders[dappboxAddress][i].folderAddress)
          {
            dappboxAllFolders[dappboxAddress][i].folderDeleted = true;
            removeAllFilesFromFolder(dappboxAddress,folderAddress);
            removeSubFolder(dappboxAddress , folderAddress);
          }
          
      }
   }


   function removeSubFolder(address dappboxAddress, address folderAddress) public 
   {
     uint256 len = dappboxAllSubFolders[dappboxAddress].length;
     for(uint256 i = 0 ; i < len ; i++)
     {
        if(dappboxAllSubFolders[dappboxAddress][i].BeforeFolderAddress == folderAddress)
        {
           address newFolderAddress = dappboxAllSubFolders[dappboxAddress][i].folderAddress;
           dappboxAllSubFolders[dappboxAddress][i].folderDeleted = true;
           removeAllFilesFromFolder(dappboxAddress,newFolderAddress);
           removeSubFolder(dappboxAddress, newFolderAddress);
        }
     }  
   }

   function removeAllFilesFromFolder(address dappboxAddress,address folderAddress) internal
   {
       uint256 len = dappboxAllFiles[dappboxAddress].length; 
      for(uint256 i = 0 ; i< len ; i++)
       {
          if(folderAddress == dappboxAllFiles[dappboxAddress][i].folderAddress)
          {
             dappboxAllFiles[dappboxAddress][i].fileDeleted = true;
          }
       }

}

   function getFolderAddress(address dappboxOrigin,string memory folderNameHash) public view returns(address)
   {
      address folderAddress;
      uint256 len = dappboxAllFolders[dappboxOrigin].length;
      for(uint256 i = 0 ; i < len ; i++)
      {
         bool res = compareStrings(dappboxAllFolders[dappboxOrigin][i].folderNameHash,folderNameHash);
         if(res == true)
         {
               folderAddress = dappboxAllFolders[dappboxOrigin][i].folderAddress;
        break;
         }
      }
   return  folderAddress;
   }

}