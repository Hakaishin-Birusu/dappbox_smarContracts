pragma solidity >=0.4.21 <0.6.0;

contract ProofOfExistence {

enum BlockchainIdentification {Ixxo,Ethereum,Gochain}

uint256 intCounter ;

struct FileExistenceStruct {
uint256 date;
address filesender;
string fileHash;
string filePathHash;
address contractAddress;
bytes32 QRCodeHash;
BlockchainIdentification identifier;
}

mapping(address => uint256[]) fileIndexCount;
mapping(uint256 => FileExistenceStruct[]) fileExistenceProofs;


constructor() public {
    intCounter = 0;
}


/**
 *@dev function to set the Proof of existence for a file 
 */
    function SetFileExistenceProof(address dappBoxOrigin, string memory _fileHash, string memory _filePathHash, address _contractAddress ,BlockchainIdentification _identifier) public returns (bytes32)
    {
        FileExistenceStruct memory newInfo;

        uint256 _date = now;
        bytes32 QRCodeHash = generateQRCodeForFile(dappBoxOrigin,_fileHash,_filePathHash,_contractAddress ,_identifier);
        newInfo.date = _date;
        newInfo.filesender = dappBoxOrigin;
        newInfo.fileHash = _fileHash;
        newInfo.filePathHash = _filePathHash;
        newInfo.contractAddress = _contractAddress;
        newInfo.identifier = _identifier;
        newInfo.QRCodeHash = QRCodeHash;
        fileIndexCount[dappBoxOrigin].push(intCounter);
        fileExistenceProofs[intCounter].push(newInfo);
        intCounter++;
        return QRCodeHash;
    }

/**
 * @dev add any update in existence of any file update                                                    
 */
    function addExistenceProofUpdate(address dappBoxOrigin, string memory _fileHash, string memory _filePathHash, address _contractAddress ,BlockchainIdentification _identifier) public returns (bool) 
    {
        bool res = false ;
        for(uint i = 0 ; i <  fileIndexCount[dappBoxOrigin].length ; i++)
        {
            uint256 pass =  fileIndexCount[dappBoxOrigin][i];
             res = compareStrings(_fileHash,fileExistenceProofs[pass][i].fileHash) &&
            compareStrings(_filePathHash,fileExistenceProofs[pass][i].filePathHash);
            if(res == true)
            {
                 FileExistenceStruct memory newInfo;
            bytes32 QRCodeHash = generateQRCodeForFile(dappBoxOrigin,_fileHash,_filePathHash,_contractAddress ,_identifier);
            newInfo.date = now;
            newInfo.filesender = dappBoxOrigin;
            newInfo.fileHash = _fileHash;
            newInfo.filePathHash = _filePathHash;
            newInfo.contractAddress = _contractAddress;
            newInfo.identifier = _identifier;
            newInfo.QRCodeHash = QRCodeHash;

            fileExistenceProofs[intCounter].push(newInfo);

            }
        }
        return res;
    }


/**
 *@dev function to get the Proof of existence for a file 
 */
    function GetFileExistenceProof(address dappBoxOrigin,string memory fileHash, string memory filePathHash) public view returns(uint256,address,address,BlockchainIdentification,bytes32) {
    
    uint256 check = fileIndexCount[dappBoxOrigin].length;
    uint256 currentCount;
    bool res = false;
    if (check != 0){
         for(uint i = 0 ; i < fileIndexCount[dappBoxOrigin].length ; i++)
        {
            uint256 pass =  fileIndexCount[dappBoxOrigin][i];
             res = compareStrings(fileHash,fileExistenceProofs[pass][i].fileHash) &&
          compareStrings(filePathHash,fileExistenceProofs[pass][i].filePathHash);
            if(res == true )
            {
                currentCount = pass;
                return( fileExistenceProofs[currentCount][0].date,
                fileExistenceProofs[currentCount][0].filesender,
                fileExistenceProofs[currentCount][0].contractAddress,
                fileExistenceProofs[currentCount][0].identifier,
                fileExistenceProofs[currentCount][0].QRCodeHash);
            }
            
        }
    }
}

/**
 *@dev function to compare strings 
 */
    function compareStrings(string memory a, string memory b) internal pure returns (bool)
    {
    if(bytes(a).length != bytes(b).length) {
        return false;
    } else {
      return keccak256(abi.encode(a)) == keccak256(abi.encode(b));
    }
    }

/**
 *@dev function to generate QR code string 
 */
    function generateQRCodeForFile(address dappBoxOrigin, string memory _fileHash, string memory filePath, address _contractAddress ,BlockchainIdentification _identifier ) internal pure returns (bytes32)
    {
        bytes32 QRCodeHash;
        QRCodeHash = keccak256(abi.encodePacked(dappBoxOrigin, _fileHash,filePath,_contractAddress,_identifier));        
        return QRCodeHash;
    }


/**
 *@dev function to retreive QR code in string format 
 */

    function getQRCode(address dappBoxOrigin, string memory fileHash, string memory filePathHash ) public view returns(bytes32) {
        uint256 len = fileIndexCount[dappBoxOrigin].length;
        if (len != 0)
        {
        for(uint i = 0 ; i < len ; i++)
        {
         uint256 pass =  fileIndexCount[dappBoxOrigin][i];
          bool res = compareStrings(fileHash,fileExistenceProofs[pass][i].fileHash) &&
          compareStrings(filePathHash,fileExistenceProofs[pass][i].filePathHash);
            if(res == true )
            {
                return fileExistenceProofs[pass][i].QRCodeHash;
            }

    }
        }
    }


/**
 *@dev function to get proof of existence using QR code
 */
    function searchExistenceProoUsngQR(address dappBoxOrigin,bytes32 QRCodeHash) public view returns(uint256,address,address,BlockchainIdentification,bytes32) {
         uint256 len = fileIndexCount[dappBoxOrigin].length;
        for(uint i = 0 ; i < len ; i++)
        {
            uint256 pass =  fileIndexCount[dappBoxOrigin][i];
            if(QRCodeHash == fileExistenceProofs[pass][i].QRCodeHash)
            {
             return( fileExistenceProofs[pass][i].date,
                fileExistenceProofs[pass][i].filesender,
                fileExistenceProofs[pass][i].contractAddress,
                fileExistenceProofs[pass][i].identifier,
                fileExistenceProofs[pass][i].QRCodeHash);
        }
        }
    }


}