pragma solidity >=0.4.21 <0.6.0;

import "./DateTime.sol";

contract Dependency is DateTime 
{ 
  /**
   * @dev struture to store File transfer related information
   */
    struct FileProof
    {
        address sender;
        address receiver;
        bytes32 fileHash;
        uint256 timestamp;
        bytes32 QR;
        bytes32 QRTime;
    }
  /**
   * @dev structure to store Folder transfer related information
   */
    struct FolderProof
    {
        address sender;
        address receiver;
        address folderAddress;
        bytes32 folderHash;
        uint256 timestamp;
        bytes32 QR;
        bytes32 QRTime;
    }

    struct FileQRWithIndex
    {
        bytes32 hashFile;
        uint256 index;
    }

    struct FolderQRWithIndex
    {
        address folderAddress;
        uint256 index;
    }

  /**
   * @dev mapping to map the proof and QR codes(both with and Without time)
   * @mapping fileProofs , map the struct of file proof with file hash as its key
   * @mapoing folderProofs , map the struct of folder proof with folder hash as its key
   * @mapping fileQrCodeWithoutTime , map the QR code with file  hash as key . It helps in searching proof via QR
   * @mapping fileQrCodeWithTime , map the QR code with Time with file hash as key   
   * @mapping folderQrCodeWithoutTime , map the QR code with folder address as key . It helps in searching proof via QR
   * @mapping folderQrCodeWithTime , map the QR code with Time with folder address as key   
   */
    mapping (bytes32 => FileProof[]) fileProofs; // this allows to look up proof of transfer by the hashfile
    mapping (address => FolderProof[]) folderProofs;
    mapping (bytes32 => FileQRWithIndex[]) fileQrCodeWithoutTime; //  QrCode => hashFile
    mapping (bytes32 => FileQRWithIndex[]) fileQrCodeWithTime;
    mapping (bytes32 => FolderQRWithIndex[]) folderQrCodeWithoutTime; //  QrCode => hashFile
    mapping (bytes32 => FolderQRWithIndex[]) folderQrCodeWithTime;

    mapping(bytes32 => bool)  usedFileHashes;
    mapping(address => bool)  usedFolderAddresses;


    /**
     * @dev supporting function for creating and storing Transfer proof 
     */

    function _inCreateFileTransferProof(address _sender, address _receiver, bytes32 _fileHash,uint256 time, bytes32 QRWithNoTime ,bytes32 QRWithTime) internal returns (bool)
    {
        FileProof memory currentInfo;
        currentInfo.sender = _sender;
        currentInfo.receiver = _receiver;
        currentInfo.fileHash = _fileHash;
        currentInfo.timestamp = time;
        currentInfo.QR = QRWithNoTime;
        currentInfo.QRTime = QRWithTime;
        // if the entry is already present in mapping with same File Proof then it add the info in the array of struct "FileProof" mapped to the specific file hash,
        // And if not present then creates the new entry
        fileProofs[_fileHash].push(currentInfo);
        uint256 index = fileProofs[_fileHash].length - 1;
        FileQRWithIndex memory indexInfo;
        indexInfo.hashFile = _fileHash;
        indexInfo.index = index;
        fileQrCodeWithoutTime[QRWithNoTime].push(indexInfo);
        fileQrCodeWithTime[QRWithTime].push(indexInfo);
        usedFileHashes[_fileHash] = true;
        return true;
    }


    /**
     * @dev supporting function for creating and storing Folder transfer proof
     */
    function _inCreateFolderTransferProof(address _sender,address _receiver,address _folderAddress,bytes32 _folderHash,uint256 time,bytes32 QRWithNoTime,bytes32 QRWithTime) internal returns(bool)
    {
        FolderProof memory currentInfo;
        currentInfo.sender = _sender;
        currentInfo.receiver = _receiver;
        currentInfo.folderAddress = _folderAddress;
        currentInfo.folderHash = _folderHash;
        currentInfo.timestamp = time;
        currentInfo.QR = QRWithNoTime;
        currentInfo.QRTime = QRWithTime;
        // if the entry is already present in mapping with same folder address then it add the info in the array of struct "FolderProof" mapped to the specific address,
        // And if not present then creates the new entry
        folderProofs[_folderAddress].push(currentInfo); 
        uint256 index = folderProofs[_folderAddress].length - 1;
        FolderQRWithIndex memory indexInfo;
        indexInfo.folderAddress = _folderAddress;
        indexInfo.index = index;
        folderQrCodeWithoutTime[QRWithNoTime].push(indexInfo);
        folderQrCodeWithTime[QRWithTime].push(indexInfo);
        usedFolderAddresses[_folderAddress] = true;
        return true;
    }


    /**
     * @dev returns array of all senders and receivers related to supplied file hash
     */
    function _inGetFileTransferProofs(bytes32 fileHash, uint256 index) internal view returns (address[] memory, bytes32, bool)
    {   
        address[] memory senderAndReceiver = new address[](2);
        senderAndReceiver[0] = fileProofs[fileHash][index].sender;
        senderAndReceiver[1] = fileProofs[fileHash][index].receiver;
        bytes32 QR = fileProofs[fileHash][index].QR;
        if(fileProofs[fileHash].length - 1 > index)
        {
            return(senderAndReceiver, QR, true);
        }
        else
        {
            return(senderAndReceiver, QR, false);
        }
    }


    /**
   * @dev calculates the day , month , year using the timestamp
   * @param time , timestamp whose day,month,year is to be calculated 
   */
    function getDateTime (uint256 time) internal pure returns(uint256,uint256,uint256)
      {
        uint256 year = getYear(time);
        uint256 month = getMonth(time);
        uint256 day = getDay(time);
        return (year, month, day );
    }


    /**
     * @dev returns array of all day , month , year related to supplied file hash  
     */
    function _inGetFileTransferProofsDateTime(bytes32 fileHash,uint256 index ,uint256 len) internal view returns (address[] memory, bytes32, uint256[] memory,bool)
    {     
        uint256 time = fileProofs[fileHash][index].timestamp; 
        (uint256 year, uint256 month, uint256 day) = getDateTime(time);
        address[] memory senderAndReceiver = new address[](2);
        senderAndReceiver[0] = fileProofs[fileHash][index].sender;
        senderAndReceiver[1] = fileProofs[fileHash][index].receiver;
        bytes32 QR = fileProofs[fileHash][index].QRTime;
        uint256[] memory Date = new uint256[](3);
        Date[0] = day;
        Date[1] = month;
        Date[2] = year;
        if(len - 1 > index)
        {
            return(senderAndReceiver, QR, Date, true);
        }
        else
        {
            return(senderAndReceiver, QR, Date, false);
        }
    }


    /**
     * @dev returns array of all senders and receivers related to supplied folder Address  
     */


    function _inGetFolderTransferProofs(address folderAddress,uint256 index) internal view returns(address[] memory,bytes32 , bytes32, bool)
    {   
        address[] memory senderAndReceiver = new address[](2);
        senderAndReceiver[0] = folderProofs[folderAddress][index].sender;
        senderAndReceiver[1] = folderProofs[folderAddress][index].receiver;
        bytes32 QR = folderProofs[folderAddress][index].QR;
        bytes32 folderHash = folderProofs[folderAddress][index].folderHash;
        if(folderProofs[folderAddress].length - 1 > index)
        {
            return(senderAndReceiver,folderHash, QR, true);
        }
        else
        {
            return(senderAndReceiver,folderHash,QR, false);
        }
    }


    /**
     * @dev returns array of all day , month , year related to supplied folder address 
     */
    function _inGetFolderTransferProofsWithDateTime(address folderAddress,uint256 index, uint256 len) internal view returns (address[] memory,bytes32,bytes32, uint256[] memory,bool)
    {   
        uint256 time = folderProofs[folderAddress][index].timestamp; 
       // (uint256 year, uint256 month, uint256 day) = getDateTime(time);
        address[] memory senderAndReceiver = new address[](2);
        senderAndReceiver[0] = folderProofs[folderAddress][index].sender;
        senderAndReceiver[1] = folderProofs[folderAddress][index].receiver;
        bytes32 folderHash = folderProofs[folderAddress][index].folderHash;
        bytes32 QR = folderProofs[folderAddress][index].QRTime;
        uint256[] memory Date = new uint256[](3);
        (Date[2],Date[1],Date[0])= getDateTime(time);
        if(len - 1 > index)
        {
            return(senderAndReceiver,folderHash ,QR,Date, true);
        }
        else
        {
            return(senderAndReceiver,folderHash, QR,Date, false);
        }
    }
    

    /**
     * @dev supporting function for searching file information via QR code 
     */
    function _InSearchFileTransferProof(bytes32 QRCode) internal view returns(address , address , bytes32)
      {
        bytes32 Hash;
        Hash = fileQrCodeWithoutTime[QRCode][0].hashFile;
        require(fileExists(Hash),"file does not exists");
        uint256 index = fileQrCodeWithoutTime[QRCode][0].index;
        address sender = fileProofs[Hash][index].sender;
        address receiver = fileProofs[Hash][index].receiver;
        return (sender, receiver, Hash);
    }


    /**
     * @dev supporting function for searching file information with day , month , year via QR code 
     */
    function _InSearchFileTransferProofWithTime(bytes32 QRCode) internal view returns(address , address , uint256 , uint256 , uint256 ,bytes32)
    {
        bytes32 Hash;
        Hash = fileQrCodeWithTime[QRCode][0].hashFile;
        require(fileExists(Hash),"file does not exists");
        uint256 index = fileQrCodeWithTime[QRCode][0].index;
        address sender = fileProofs[Hash][index].sender;
        address receiver = fileProofs[Hash][index].receiver;
        (uint256 year, uint256 month, uint256 day) = getDateTime(fileProofs[Hash][index].timestamp);
        return (sender, receiver, day, month, year, Hash);
    }


    /**
     * @dev supporting function for searching folder information  via QR code 
     */
    function _InSearchFolderTransferProof(bytes32 QRCode) internal view returns(address , address , address , bytes32)
    {
        address folderAddress;
        folderAddress = folderQrCodeWithoutTime[QRCode][0].folderAddress;
        require(folderExists(folderAddress), "folder does not exist");
        uint256 index = folderQrCodeWithoutTime[QRCode][0].index;
        address sender = folderProofs[folderAddress][index].sender;
        address receiver = folderProofs[folderAddress][index].receiver;
        bytes32 folderHash = folderProofs[folderAddress][index].folderHash;
        return (sender, receiver, folderAddress , folderHash);
    }


    /**
     * @dev supporting function for searching folder information with day , month , year via QR code    
     */
    function _InSearchFolderTransferProofWithTime(bytes32 QRCode) internal view returns(address ,address , address , bytes32,uint256 , uint256 , uint256)
    {
        address folderAddress;
        folderAddress = folderQrCodeWithTime[QRCode][0].folderAddress;
        require(folderExists(folderAddress), "folder does not exist");
        uint256 index = folderQrCodeWithTime[QRCode][0].index;
        address sender = folderProofs[folderAddress][index].sender;
        address receiver = folderProofs[folderAddress][index].receiver;
        bytes32 folderHash = folderProofs[folderAddress][index].folderHash;
        (uint256 year, uint256 month, uint256 day) = getDateTime(folderProofs[folderAddress][index].timestamp);
        return (sender, receiver, folderAddress,folderHash, day, month, year);
    }


    /**
     * @dev checks file exists or not , using File Hash
     */
    function fileExists(bytes32 fileHash)internal view  returns (bool)
    {
        bool exists = false;
        if (usedFileHashes[fileHash])
        {
            exists = true;
        }
        return exists;
    }
  

    /**
     * @dev checks folder exists or not , using folder addressn
     */
    function folderExists(address folderAddress) internal view  returns (bool)
    {
        bool exists = false;
        if (usedFolderAddresses[folderAddress])
        {
            exists = true;
        }
  
        return exists;
    }
    
}
