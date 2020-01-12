pragma solidity >=0.4.21 <0.6.0;

import "./ProductInventory";
contract LicenseInventory is ProductInventory
{
  event LicenseIssued(address indexed owner ,uint256 licenseId,uint256 productId,string productName,uint256 issuedTime,uint256 expirationTime);
  event DappCreatorLicenseIssued(address indexed owner,uint256 licenseId,uint256 productId,uint256 productVolume,string productName,uint256 issuedTime,uint256 expirationTime);
  event AddonLicenseIssued(address indexed owner,uint256 licenseId,uint256 addonId,string addonName,uint256 productId,uint256 issueTime,uint256 expirationTime);
  event LicenseRenewal(address indexed owner,uint256 licenseId,uint256 productId,uint256 expirationTime);
  event DappCreatorResaleList(address indexed owner,uint256 createId, bool setMonthlyLicense , uint256 monthlyLicensePrice , bool setAnnualLicense , uint256 AnuualLicensePrice);
  event CreateResaleLicense(address indexed owner,uint256 licenseId,uint256 CreateId,string createName,uint256 issueTime,uint256 expirationTime);

 struct IndividualLicense {
    address owner;
    uint256 productId;
    string productName;
    uint256 issuedTime;
    uint256 expirationTime;
  }

    struct CreatorLicense {
    address owner;
    uint256 productId;
    string productName;
    uint256 dappboxVolume;
    uint256 issuedTime;
    uint256 expirationTime;
  }

    struct AddonLicense
  {
    address owner ;
    uint256 addonId;
    uint256 baseProductId;
    string addonName;
    uint256 issuedTime;
    uint256 expirationTime;
  }

    struct CreatorResaleList
  {
    address owner;
    uint256 creatorLicense;
    uint256 numOfDappboxToResale;
    bool MonthlyLicense;
    uint256 MonthlyLicensePrice;
    bool AnnualLicense;
    uint256 AnnualLicensePrice; 
    
  }

    struct CreatorResaleLicense
    {
      address owner;
      uint256 CreateId;
      uint256 baseProductId;
      string createName;
      uint256 issuedTime;
      uint256 expirationTime;
    }



   IndividualLicense[] public individualLicenses;
   CreatorLicense[] public creatorLicenses;
   CreatorResaleList[] public creatorResaleLists;
   CreatorResaleLicense[] public creatorResaleLicenses;
   AddonLicense[] public addonLicenses ;



  function _returnDappCreatorResaleList(uint256 indexer) public view returns (address,uint256,uint256,bool,uint256,bool,uint256,bool,uint256)
  {
    uint256 len = creatorResaleLists.length;
    for(uint256 index =indexer ; index < len ; index++)
    {
        uint256 z = creatorResaleLists[index].creatorLicense;
      if(creatorResaleLists[index].numOfDappboxToResale >=0 && creatorLicenses[z].expirationTime > now)
    {
      if(index < len-1)
      {
    return(creatorResaleLists[index].owner,
    creatorResaleLists[index].creatorLicense,
    creatorResaleLists[index].numOfDappboxToResale,
    creatorResaleLists[index].MonthlyLicense,
    creatorResaleLists[index].MonthlyLicensePrice,
    creatorResaleLists[index].AnnualLicense,
    creatorResaleLists[index].AnnualLicensePrice,true,index+1);
    }

    else
    {
    return(creatorResaleLists[index].owner,
     creatorResaleLists[index].creatorLicense,
     creatorResaleLists[index].numOfDappboxToResale,
    creatorResaleLists[index].MonthlyLicense,
    creatorResaleLists[index].MonthlyLicensePrice,
    creatorResaleLists[index].AnnualLicense,
    creatorResaleLists[index].AnnualLicensePrice,false,0);
    }
    }
  }
  }

  function _deductCreateDappboxFromListing(uint256 index) internal returns(bool)
  {
    creatorResaleLists[index].numOfDappboxToResale = creatorResaleLists[index].numOfDappboxToResale -1;
    return true;
  }

  function checkAvailability(uint256 creatorId) internal view returns(bool,uint256)
  {
      uint256 len = creatorResaleLists.length;
      for(uint256 i =0;i<len;i++)
      {
        if(creatorResaleLists[i].creatorLicense == creatorId && creatorResaleLists[i].numOfDappboxToResale >=1)
        {
          return (true,i);
        }
      }
      return(false,0);
  }

  /**
  *@dev checks the current numbe rof dappbox free running
  */
  function _checkDappBoxFreeRunning() public view returns (uint256)
  {
    uint256 timestamp = now ;
    uint256 flag = 0;
    uint256 len = individualLicenses.length -1;
    for(uint256 i= 0 ; i< len ; i++)
    {
      if(individualLicenses[i].productId == 1 && individualLicenses[i].expirationTime < timestamp )
      {
        flag++;
      }
      return flag;
    }
  }


  /**
  *@dev facilitates the creation of dappbox individual license
  */
  function _createDappIndividualLicense(address owner,uint256 productId,string memory name, uint256 expTime) public returns(uint256)
  {
    IndividualLicense memory _license = IndividualLicense({
            owner: owner,
            productId: productId,
            productName : name,
            issuedTime: now, 
            expirationTime: expTime
            });

        uint256 newLicenseId = individualLicenses.push(_license) - 1; 
        emit LicenseIssued(
            owner,
            newLicenseId,
            _license.productId,
            _license.productName,
            _license.issuedTime,
            _license.expirationTime
        );
        return newLicenseId;
  }


  /**
  *@dev faciliates dappCreator licensing
  */
  function _createDappCreatorLicense(address _assignee,uint256 _numOfDappbox, uint256 _productId , string memory _name , uint256 expTime) public returns(uint256)
  {
    CreatorLicense memory _license = CreatorLicense({
    owner: _assignee ,
    productId: _productId,
    productName: _name,
    dappboxVolume: _numOfDappbox,
    issuedTime: now ,
    expirationTime:expTime 
    });

    uint256 newLicenseId = creatorLicenses.push(_license) - 1;
    emit DappCreatorLicenseIssued(msg.sender,
    newLicenseId,
    _license.productId,
    _license.dappboxVolume,
    _license.productName,
    _license.issuedTime,
    _license.expirationTime
    );
    return newLicenseId;
  }


  /**
  *@dev facilitates the creation of addon license
  */
  function _createAddonLicense(uint256 addonId,uint256 _productId,string memory name,uint256 expTime  ) public returns(uint256)
  {        
    address spender = msg.sender ;
    AddonLicense memory newList = AddonLicense({
    owner: spender,
    addonId: addonId,
    baseProductId:_productId,
    addonName: name,
    issuedTime: now,
    expirationTime: expTime  
    });
    uint256 newAddonLicense = addonLicenses.push(newList)-1;
    emit AddonLicenseIssued(msg.sender,
    newAddonLicense,
    newList.addonId,
    newList.addonName,
    newList.baseProductId,
    newList.issuedTime,
    newList.expirationTime);
    return newAddonLicense;
  }

  /**
  * @dev list all dapp creator resale
  */
  function _ListResellingDappCreator(address creator,uint256 creatorLicense,uint256 numOfDappboxForSale, bool MonthlyLicenses,uint256 MonthlyLicensePrices,bool AnnualLicenses,uint256 AnnualLicensePrices) public returns(uint256)
  {
    
    CreatorResaleList memory ResaleList;
    ResaleList.owner = creator;
    ResaleList.creatorLicense = creatorLicense;
    ResaleList.numOfDappboxToResale = numOfDappboxForSale;
    ResaleList.MonthlyLicense = MonthlyLicenses;
    ResaleList.MonthlyLicensePrice = MonthlyLicensePrices;
    ResaleList.AnnualLicense = AnnualLicenses;
    ResaleList.AnnualLicensePrice = AnnualLicensePrices;
    uint256 ListingIndex = creatorResaleLists.push(ResaleList) - 1;
    emit DappCreatorResaleList(ResaleList.owner,
    ResaleList.creatorLicense,
    ResaleList.MonthlyLicense,
    ResaleList.MonthlyLicensePrice,
    ResaleList.AnnualLicense,
    ResaleList.AnnualLicensePrice);

    return ListingIndex;
}

  /**
  * @dev funtion to create Creator license
  */
  function _createCreatorResaleLicense(uint256 createId,uint256 expTime) public returns(uint256)
  {
    uint256 productId = creatorLicenses[createId].productId;
    string memory createname = creatorLicenses[createId].productName; 
    address spender = msg.sender;
    CreatorResaleLicense memory newList = CreatorResaleLicense({owner: spender,
      CreateId :createId,
      baseProductId:productId,
      createName:createname,
      issuedTime:now,
      expirationTime:expTime
    });
    uint createResaleLicenseId = creatorResaleLicenses.push(newList) -1;
    emit CreateResaleLicense(newList.owner,
      newList.CreateId,
      newList.baseProductId,
      newList.createName,
      newList.issuedTime,
      newList.expirationTime);

      return createResaleLicenseId;
  }

  /**
  * @dev function to renew individual license
  */
  function _renewIndividualLicense(uint256 LicenseId , uint256 productId ,uint256 newExp) public returns(bool)
  {
    individualLicenses[LicenseId].expirationTime = newExp;
    emit LicenseRenewal(
      msg.sender,
      LicenseId,
      productId,
      newExp
    ); 
    return true;
  }

  /**
  * @dev function to renew creator license
  */
  function _renewCreatorLicense(uint256 createId, uint256 productId, uint256 newExp) public returns(bool)
  {
    creatorLicenses[createId].expirationTime = newExp;
    emit LicenseRenewal(
      msg.sender,
      createId,
      productId,
      newExp
    ); 
    return true;
  }

  /**
  * @dev function to renew addon license
  */
  function _renewAddonLicense(uint256 LicenseId ,uint256 addonId, uint256 newExp) public returns(bool)
  {
    addonLicenses[LicenseId].expirationTime = newExp;
    emit LicenseRenewal(
      msg.sender,
      LicenseId,
      addonId,
      newExp
    ); 
    return true;
  }

  /**
  *@dev function to renew the license of dapp creator
  */
  function _renewCreatorResaleLicense(uint256 licenseId, uint256 productId, uint256 newExp) public returns(bool)
  {
    creatorResaleLicenses[licenseId].expirationTime = newExp;
    emit LicenseRenewal(
      msg.sender,
      licenseId,
      productId,
      newExp
    ); 
    return true;
  }

  function _getDappCreatorExpirationTime(uint256 index) internal view returns(uint256)
  {
    return creatorLicenses[index].expirationTime;
  }

  function _getAddonExpirationTime(uint256 index) internal view returns(uint256)
  {
    return addonLicenses[index].expirationTime;
  }

  function _getDappIndividualExpirationTime(uint256 LicenseId) internal view returns(uint256)
  {
     return individualLicenses[LicenseId].expirationTime;
  }

  function _getcreateResaleExpirationTime(uint256 LicenseId) internal view returns(uint256)
  {
    return creatorResaleLicenses[LicenseId].expirationTime;
  }

  function _getCreatorResaleBaseProductId(uint256 LicenseId) internal view returns(uint256)
  {
    return creatorResaleLicenses[LicenseId].baseProductId;
  }

  /**
  * @dev check if already dapp creator
  */
  function _checkDappCreator(address beneficiary) public view  returns(bool , uint256)
  {
    bool flag = true;
    uint256 index ;
    uint256 len = creatorLicenses.length -1 ;
    for(uint256 i= 0 ; i< len; i++)
  {
      if(beneficiary == creatorLicenses[i].owner )
        {
          index = i ;
          flag = false;
        }
  }
  return (flag , index);
  } 
  
  function getCreatorMonthlyPrice(uint256 creatorId) public view returns(uint256)
  {
   
    uint256 len = creatorResaleLists.length;
     for(uint256 i = 0 ; i<len ; i++)
     {
         if(creatorResaleLists[i].creatorLicense == creatorId)
         {
             return creatorResaleLists[i].MonthlyLicensePrice;
         }
         
     }
  }
  
   function getCreatorAnnaulPrice(uint256 creatorId) public view returns(uint256)
  {
     uint256 len = creatorResaleLists.length;
     for(uint256 i = 0 ; i<len ; i++)
     {
         if(creatorResaleLists[i].creatorLicense == creatorId)
         {
             return creatorResaleLists[i].AnnualLicensePrice;
         }
         
     }
  }


  function _getCreateName(uint256 creatorId) public view returns(string memory)
  {
    return creatorLicenses[creatorId].productName;
  }

      /**
  *@dev functions that returns the license related information
  */
  function _licenseProductId(uint256 _licenseId) public view returns (uint256) {
    return individualLicenses[_licenseId].productId;
  }
  function _licenseCreatorProductId(uint256 _licenseId) public view returns(uint256){
    return creatorLicenses[_licenseId].productId;
  }
  function _licenseCreatordappboxVolume(uint256 _licenseId) public view returns(uint256){
    return creatorLicenses[_licenseId].dappboxVolume;
  }
  function _licenseAddonProductId(uint256 _licenseId) public view returns (uint256){
    return addonLicenses[_licenseId].addonId;
  }
  function _licenseAddonBaseProductId(uint256 _licenseId) public view returns (uint256){
    return addonLicenses[_licenseId].baseProductId;
  }



}  