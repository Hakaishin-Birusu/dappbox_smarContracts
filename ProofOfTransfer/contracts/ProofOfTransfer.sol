pragma solidity >=0.4.21 <0.6.0;

import "./Dependency.sol";

contract ProofOfTransfer is Dependency
{ 

  /**
   * @dev Creates and stores the File transfer proof at the block timestamp
   * timestamp in stored as no minor change in time shall be there at time of storing and creting QR hash
   * @param _sender , represents the entity who is sending the file
   * @param _receiver , represents the entity who is receiving the file 
   * @param _fileHash , hash of file being transferred
   * @return bool , true if creates the file transfer proof entry successfully
   */
    function createFileTransferProof(address _sender, address _receiver, bytes32 _fileHash) public returns (bool)
    {
        uint256 time = block.timestamp;
        bytes32 QRWithNoTime = getQRCodeForFile(_sender, _receiver, _fileHash, 0);
        bytes32 QRWithTime = getQRCodeForFile(_sender, _receiver,_fileHash, time);
        return _inCreateFileTransferProof(_sender,_receiver,_fileHash,time,QRWithNoTime,QRWithTime);
    }


      /**
   * @dev Creates and stores the Folder transfer proof at the block timestamp
   * @param _sender , represents the entity who is sending folder
   * @param _receiver , represents the entity who is receiving folder
   * @param _folderAddress , address of folder which is being send
   * @return bool , true if creates the fiolder transfer proof entry successfully
   */
    function createFolderTransferProof(address _sender, address _receiver, address _folderAddress , bytes32 folderHash ) public returns(bool)
    { 
        uint256 time = block.timestamp;
        bytes32 QRWithNoTime = getQRCodeForFolder(_sender, _receiver, _folderAddress,folderHash, 0);
        bytes32 QRWithTime = getQRCodeForFolder(_sender, _receiver, _folderAddress,folderHash, time);
        return _inCreateFolderTransferProof(_sender,_receiver,_folderAddress,folderHash,time,QRWithNoTime,QRWithTime);        
    }


 /**
   * @dev get file transfer proof by using filehash
   * @param fileHash , hash of file , whose information is to be fetched
   * @return , address of sender , reciever and QR code 
   */
    function getFileTransferProofs(bytes32 fileHash, uint256 Index) public view returns(address[] memory,bytes32,bool)
    {   
        require(fileExists(fileHash),"No file found");
        (address[] memory senderAndReceiver,bytes32 QR,bool nextIndexPresent) = _inGetFileTransferProofs(fileHash, Index);
        return (senderAndReceiver,QR,nextIndexPresent);
    }


  /**
    * @dev get file transfer proof with time detail by using filehash
    * @param fileHash , hash of file , whose information is to be fetched
    * @return , address of sender , reciever and QR code with day ,month and year information also
    */
    function getFileTransferProofWithTDateTime(bytes32 fileHash, uint256 Index) public view returns(address[] memory,bytes32, uint256[] memory,bool)
    {
        require(fileExists(fileHash),"No file found");
        //sending length in this function to remove "STACK TOO DEEEP ERROR" 
        uint256 len = fileProofs[fileHash].length;
        (address[] memory senderAndReceiver,bytes32 QR,uint256[] memory Date,bool nextIndexPresent) = _inGetFileTransferProofsDateTime(fileHash, Index ,len);
        return (senderAndReceiver,QR,Date,nextIndexPresent);
    }
    

    /**
   * @dev get folder transfer proof by using folder address
   * @param folderAddress , address of folder , whose information is to be fetched
   * @return , address of sender , reciever and QR code 
   */
    function getFolderTransferProofs(address folderAddress, uint256 Index) public view returns (address[] memory, bytes32,bytes32,bool)
    {   
        require(folderExists(folderAddress),"No folder found");
        (address[] memory senderAndReceiver ,bytes32 folderHash,bytes32 QR,bool nextIndexPresent) = _inGetFolderTransferProofs(folderAddress, Index); 
        return (senderAndReceiver,folderHash,QR,nextIndexPresent);
    }


  /**
   * @dev get folder transfer proof by using folder address with date time details
   * @param folderAddress , address of folder , whose information is to be fetched
   * @return , address of sender , reciever and QR code with day ,month and year information also
   */
    function getFolderTransferProofsWithDateTime(address folderAddress , uint256 Index) public view returns(address[] memory, bytes32,bytes32, uint256[] memory,bool)
    {
        require(folderExists(folderAddress),"No folder found");
        //sending length in this function to remove "STACK TOO DEEEP ERROR" 
        uint256 len = folderProofs[folderAddress].length;
        (address[] memory senderAndReceiver, bytes32 folderHash,bytes32 QR,uint256[] memory Date,bool nextIndexPresent) = _inGetFolderTransferProofsWithDateTime(folderAddress, Index, len);
        return (senderAndReceiver,folderHash,QR,Date,nextIndexPresent);
    }

  /**
   * @dev search file transfer proof using QR code
   * @param QRCode , whose information is to be fetched
   * @return , address of sender, reciever and fileHash
   */
    function SearchFileTransferProof(bytes32 QRCode) public view returns(address , address ,bytes32)
    {
        return _InSearchFileTransferProof(QRCode);
    }


  /**
   * @dev search file transfer proof using QR code with time details
   * @param QRCodeTime , whose information is to be fetched
   * @return , address of sender, reciever and fileHash with day ,month and year information also
   */
    function SearchFileTransferProofWithTime(bytes32 QRCodeTime) public view returns(address , address , uint256 , uint256 , uint256 ,bytes32)
    {
        return _InSearchFileTransferProofWithTime(QRCodeTime);
    }


   /**
   * @dev search folder transfer proof using QR code 
   * @param QRCode , whose information is to be fetched
   * @return , address of sender, reciever and address of the folder
   */
    function SearchFolderTransferProof(bytes32 QRCode) public view returns(address , address , address , bytes32)
    {
        return _InSearchFolderTransferProof(QRCode);
    }

   /**
   * @dev search folder transfer proof using QR code with time details
   * @param QRCodeTime , whose information is to be fetched
   * @return , address of sender, reciever and address of the folder with day ,month and year information also
   */
    function SearchFolderTransferProofWithTime(bytes32 QRCodeTime) public view returns(address ,address , address, bytes32 , uint256 , uint256 , uint256)
    {
        return _InSearchFolderTransferProofWithTime(QRCodeTime);
    }     


  /**
   * @dev generates the QR code using filehash ,etc
   * Can generate QR code with time and without time
   */
    function getQRCodeForFile (address _sender, address _receiver,bytes32 fileHash, uint256 timestamp) internal pure returns (bytes32)
    {
        bytes32 QRCodeHash;

        if(timestamp == 0)  //generate QR code without dateTime
        {
            QRCodeHash = keccak256(abi.encodePacked(_sender, _receiver,fileHash));
        }
        else 
        {
            (uint256 year, uint256 month, uint256 day) = getDateTime(timestamp);
            QRCodeHash = keccak256(abi.encodePacked(_sender, _receiver, fileHash, day, month, year));
        }

        return QRCodeHash;
    }


  /**
   * @dev generates the QR code using Folder address , etc 
   * Can generate QR code with time and without time
   */
    function getQRCodeForFolder (address _sender, address _receiver,address folderAddress,bytes32 folderHash, uint256 timestamp) internal pure returns (bytes32)
    {
        bytes32 QRCodeHash;

        if(timestamp == 0)  //generate QR code without dateTime
        {
            QRCodeHash = keccak256(abi.encodePacked(_sender, _receiver,folderAddress , folderHash));
        }
        else 
        {
            (uint256 year, uint256 month, uint256 day) = getDateTime(timestamp);
            QRCodeHash = keccak256(abi.encodePacked(_sender, _receiver,folderAddress,folderHash,day,month, year));
        }

        return QRCodeHash;
    }

}
