pragma solidity >=0.4.21 <0.6.0;


contract LicenseInventory
{
  function _returnDappCreatorResaleList(uint256 indexer) public view returns (address,uint256,uint256,bool,uint256,bool,uint256,bool,uint256)
  {}
    
  function _checkDappBoxFreeRunning() public view returns (uint256)
  {}

  function _createDappIndividualLicense(address owner,uint256 productId,string memory name, uint256 expTime) public returns(uint256)
  {}

  function _createDappCreatorLicense(address _assignee,uint256 _numOfDappbox, uint256 _productId , string memory _name , uint256 expTime) public returns(uint256)
  {}

  function _createAddonLicense(uint256 addonId,uint256 _productId,string memory name,uint256 expTime  ) public returns(uint256)
  {}


  function _ListResellingDappCreator(address creator,uint256 creatorLicense,uint256 numOfDappboxForSale, bool MonthlyLicenses,uint256 MonthlyLicensePrices,bool AnnualLicenses,uint256 AnnualLicensePrices) public returns(uint256)
  {}


  function _createCreatorResaleLicense(uint256 createId,uint256 expTime) public returns(uint256)
  {}

  function _renewIndividualLicense(uint256 LicenseId , uint256 productId ,uint256 newExp) public returns(bool)
  {}

  function _renewCreatorLicense(uint256 createId, uint256 productId, uint256 newExp) public returns(bool)
  {}

  function _renewAddonLicense(uint256 LicenseId ,uint256 addonId, uint256 newExp) public returns(bool)
  {}

 
  function _renewCreatorResaleLicense(uint256 licenseId, uint256 productId, uint256 newExp) public returns(bool)
  {}

  function checkDappCreator(address beneficiary) public view  returns(bool , uint256)
  {} 
  
  function getCreatorMonthlyPrice(uint256 creatorId) public view returns(uint256)
  {}
  
   function getCreatorAnnaulPrice(uint256 creatorId) public view returns(uint256)
  {}


  function getCreateName(uint256 creatorId) public view returns(string memory)
  {}

  function _licenseProductId(uint256 _licenseId) public view returns (uint256) 
  {}

  function _licenseCreatorProductId(uint256 _licenseId) public view returns(uint256)
  {}
  function _licenseAddonProductId(uint256 _licenseId) public view returns (uint256)
  {}

}  