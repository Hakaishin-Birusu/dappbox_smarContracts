pragma solidity >=0.4.24<0.6.0;

import "./BokkyPooBahsDateTimeLibrary.sol";

contract SpendingAllowanceToken
{
    function spendTokenForIxxoServices(uint256) public returns(bool){}
    function havePayableAmount(address sender,uint256 tokens) public returns(bool){}
}

contract ProductInventory
{
    function setProductPrice(uint256 _productId, uint256 _price)public
    {}
    function setAddonPrice(uint256 _AddonId, uint256 _price)public
    {}
    function createProduct(uint256 _productId,string memory _productName,uint256 _hardDrive,uint256 _maxMemory,uint256 _maxProcess,uint256 _initialPrice,bool _renewal)public
    {}
    function createAddon(uint256 _productId,string memory _productName,uint256 _initialPrice) public 
    {}
    function _renewableOf(uint256 _productId) public view returns (bool) 
    {}
    function priceOfProduct(uint256 _productId) public view returns (uint256)
    {}
    function priceOfAddon (uint256 _addonId) public view returns(uint256)
    {}
    function _getAddonName(uint256 _addonId) internal view returns (string memory)
    {}
    function _getProductName(uint256 _productId) public view returns (string memory)
    {}
    function getAllProducts(uint256 index) public view returns(uint256, string memory,uint256,uint256,uint256,uint256,bool)
    {}
    function getAllAddons(uint256 index) public view returns(uint256,string memory,uint256)
    {}
}

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

  function _checkDappCreator(address beneficiary) public view  returns(bool , uint256)
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
  
  function _licenseCreatordappboxVolume(uint256 _licenseId) public view returns(uint256)
  {}

  function _getDappCreatorExpirationTime(uint256 index) public view returns(uint256)
  {}

  function _getDappIndividualExpirationTime(uint256 LicenseId) public view returns(uint256)
  {}
  
  function _licenseAddonBaseProductId(uint256 _licenseId) public view returns (uint256)
  {}
  
  function _getAddonExpirationTime(uint256 index) public view returns(uint256)
  {}
  function checkAvailability(uint256 creatorId) public view returns(bool,uint256)
  {}
  function _deductCreateDappboxFromListing(uint256 index) public returns(bool)
  {}
  function _getcreateResaleExpirationTime(uint256 LicenseId) public view returns(uint256)
  {}
  function _getCreatorResaleBaseProductId(uint256 LicenseId) public view returns(uint256)
  {}
}  



contract Subscription
{
    bool paused ;
    address ceo;
    address cfo;
    address coo;
    uint256 dappBoxFreeCount;
    uint256 ixxoDiscountOnAnnualPurchase;

    LicenseInventory LI;
    ProductInventory PI;
    SpendingAllowanceToken SAT;


    enum LicenseType{dappboxFree,dappboxStart,dappboxPremium,dappCreator,addon,dappCreatorResold} // we will be using this to track the number of product owned by any user with mapping

    struct LicenseOwned
    {
        LicenseType licenseType;
        uint256 licenseId;
        string productName;
        uint256 expireTime;
        uint256 nbOfDappBox;
        
    }
    mapping(address=>LicenseOwned[])public LicensesOwned;

    struct CreatorDiscountStructure{
        uint256 below10;
        uint256 below20;
        uint256 below50;
        uint256 below100;
        uint256 above100;
    }


    CreatorDiscountStructure internal discountStructure;
    
   
    address[] internal dappBoxFreeOwners;

    constructor(address _LIaddress,address _SATAddress) public {
        ceo = msg.sender;
        cfo = msg.sender;
        coo = msg.sender;
        paused = false;

        LI = LicenseInventory(_LIaddress);
        PI = ProductInventory(_LIaddress);
        SAT = SpendingAllowanceToken(_SATAddress);

        dappBoxFreeCount = 500;
        ixxoDiscountOnAnnualPurchase = 25;
        discountStructure.below10 = 0; // discount in specification is calculated down in the code , it is kept zero till no generic discount is described by the CEO ,for less than 10 dappbox purchase
        discountStructure.below20 = 15;
        discountStructure.below50 = 20;
        discountStructure.below100 = 25;
        discountStructure.above100 = 30;
    }

    /**
     *@dev Modifiers for access constraints
     */
    modifier onlyCEO() {
        require(msg.sender == ceo, "Authentication failed");
        _;
    }
    
    modifier onlyCLevel() {
        require(msg.sender == coo || msg.sender == ceo || msg.sender == cfo,"authentication failed");
        _;
    }

    modifier whenNotPaused() {
        require(!paused,"contract paused");
        _;
    }

    modifier whenPaused() {
        require(paused,"contract not paused");
        _;
    }

    function ChangeCOO(address newCOO) public onlyCEO whenPaused
    {
        coo = newCOO;
    }

    function ChangeCFO(address newCFO) public onlyCEO whenPaused
    {
        cfo = newCFO;
    }

    function pause() public onlyCLevel whenNotPaused 
    {
        paused = true;
    }

    function unpause() public onlyCEO whenPaused
    {
        paused = false;
    }


    function _createProduct(uint256 _productId,string memory  _productName,uint256 _initialPrice,uint256 _hardDrive,uint256 _maxMemory,uint256 _maxProcess,bool _renewal)public onlyCLevel whenPaused
    {
        PI.createProduct(_productId,_productName,_hardDrive,_maxMemory,_maxProcess,_initialPrice,_renewal);
    }

    function _createAddon(uint256 _productId,string memory _productName,uint256 _initialPrice) public onlyCLevel whenPaused
    {
        PI.createAddon(_productId,_productName,_initialPrice);
    }

    function _getAllProducts(uint256 index) public view returns(uint256, string memory,uint256,uint256,uint256,uint256,bool)
    {
      return PI.getAllProducts(index);
    }

    function _getAllAddons(uint256 index) public view returns(uint256,string memory,uint256)
    {
      return PI.getAllAddons(index);
    }

    function ListResellingDappCreator(address creator,uint256 creatorLicense,uint256 numOfDappboxForSale, bool MonthlyLicenses,uint256 MonthlyLicensePrices,bool AnnualLicenses,uint256 AnnualLicensePrices) public returns(uint256)
  {
    return  LI._ListResellingDappCreator(creator,creatorLicense,numOfDappboxForSale,MonthlyLicenses,MonthlyLicensePrices,AnnualLicenses,AnnualLicensePrices);
  }

  

  /**
  *@dev function to buy any dappbox individual
  *@param _productId : product id of the product user want to buy
  *@param _cycleType : defines the type of product buying span , where 0 = monthly and 1 = yearly basis
  *@param _numCycles : number of cycles user wants to buy
  */
  function purchaseDappBoxIndividual (uint256 _productId, uint256 _cycleType, uint256 _numCycles) public whenNotPaused returns (uint256)
  {
    address _assignee = msg.sender;
    require(_numCycles != 0, "number of cycle should be atleast one");
    if(PI. _renewableOf(_productId)==false)//it means purchasing dappbox free
    {
      require(isAlreadyDappFreeOwner(_assignee) == false,"Already dappfree Owner");
      require(LI._checkDappBoxFreeRunning() < dappBoxFreeCount,"DappboxFree count exceeded");
      _cycleType = 0;
      _numCycles = 1;
      dappBoxFreeOwners.push(_assignee); 
    }
    else
    {
      bool flag = calculateAndDeductSat(_assignee,_productId,_cycleType,_numCycles);
      require(flag == true,"Payment failed");
    }
      uint256 expTime = expirationTime(_cycleType,_numCycles);
      string memory name = PI._getProductName(_productId);
      uint256 LId = LI._createDappIndividualLicense(_assignee,_productId,name,expTime);
      LicenseType LType = getIndividualLicenseType(_productId);
      LicenseOwned memory LicenseOwners;
      LicenseOwners.licenseType = LType; 
      LicenseOwners.licenseId = LId;
      LicenseOwners.productName = name;
      LicenseOwners.expireTime = expTime;
      LicenseOwners.nbOfDappBox =1;
      LicensesOwned[_assignee].push(LicenseOwners);
      return LId;
    }

    /**
    * @dev function to get license type using product id
    */
    function getIndividualLicenseType(uint256 productId) internal view returns(LicenseType)
    {
      if(productId == 101)
      {
        return LicenseType(0);
      }
      else if(productId == 102)
      {
        return LicenseType(1);
      }
      else if(productId == 103)
      {
        return LicenseType(2);
      }
    }


  /**
  *@dev function to that returns if beneficiary is already dappbox free user or nto 
  *@NOTE : dappbox free can be bought just once 
  */
  function isAlreadyDappFreeOwner(address beneficiary) internal view returns(bool)
  {
    uint256 len = dappBoxFreeOwners.length;
    for(uint256  i = 0 ; i<len ; i++)
    {
      if(dappBoxFreeOwners[i]==beneficiary)
      {
        return true;
      }
    }
      return false;
  }


  /**
  *@dev function to calculate the sat as per the buying and pay to ixxo
  *@param spender : beneficiary , who is buying subscription
  *@param product : Type of product buying
  *@param _cycleType : defines the type of product buying span , where 0 = monthly and 1 = yearly basis
  *@param _numCycles : number of cycles user wants to buy  
  */
  function calculateAndDeductSat(address spender,uint256 product,uint256 cycleType,uint256 numOfCycle) internal returns (bool)
  {
    uint256 satToDeduct;
    uint256 prorateSat;
    uint256 satForMonthsLeft;
    uint256 productPrice = PI.priceOfProduct(product) ;
    bool res = false;
    if(cycleType == 0)
      {
        prorateSat = calculateProrata(productPrice, cycleType);
        --numOfCycle;
        satForMonthsLeft = productPrice*(numOfCycle);
        satToDeduct = prorateSat+(satForMonthsLeft);
        res = deduct(satToDeduct);
        return res;
      }
      else if(cycleType == 1)
      {
        prorateSat = calculateProrata(productPrice, cycleType);
        satForMonthsLeft = (productPrice*(numOfCycle*(12)));
        uint256 Price = prorateSat+(satForMonthsLeft);
        uint256 discount = (Price*(ixxoDiscountOnAnnualPurchase))/(100);
        satToDeduct = Price-(discount);
        res = deduct(satToDeduct); 
        return res;
      }
  }


  /**
  *@dev function to calculate prorata
  */
  function calculateProrata(uint256 _productPrice , uint256 _cycleType ) internal view returns (uint256)
  {
    uint256 timestamp = now;
    uint256 currentDay = BokkyPooBahsDateTimeLibrary.getDay(timestamp);
    uint256 daysInMonth = BokkyPooBahsDateTimeLibrary.getDaysInMonth(timestamp);
    uint256 daysLeft = daysInMonth-(currentDay);
    uint256 monthsInYear = 12;
    uint256 SatToPay;
    if(_cycleType == 0 )
    {
      SatToPay = (_productPrice/(daysInMonth))*(daysLeft);
      return SatToPay;
    }
    else if(_cycleType == 1 )
    {
      uint256 currentMonth = BokkyPooBahsDateTimeLibrary.getMonth(timestamp);
      uint256 monthsLeft = (monthsInYear)-(currentMonth); //months left in year
      uint256 sat1 = (_productPrice/(daysInMonth))*(daysLeft);
      SatToPay = sat1+(monthsLeft*(_productPrice));
      return SatToPay;
    }
  }


  /**
  *@dev calculates the expoiration date for license expiry
  */
  function expirationTime(uint256 _cycleType,uint256  _numCycles) internal view  returns (uint256)
  {
    uint256 timestamp = now;
    uint256 currentDay = BokkyPooBahsDateTimeLibrary.getDay(timestamp);
    uint256 currentMonth = BokkyPooBahsDateTimeLibrary.getMonth(timestamp);
    uint256 daysInMonth = BokkyPooBahsDateTimeLibrary.getDaysInMonth( timestamp);
    uint256 daysLeft = daysInMonth-(currentDay);
    uint256 monthsInYear = 12;
    uint256 DaysInSec = daysLeft*(86400); // sec in day 
    _numCycles--;
    uint256 Time ;
    if (_cycleType == 0)
    {
      Time = (_numCycles*(2629746))+(DaysInSec); // sec in month
      return Time;
    }
    else if (_cycleType == 1 )
    {
      uint256 numOfMonthsLeft = ((monthsInYear)-(currentMonth))*(2629746);
      Time = ((DaysInSec)+(numOfMonthsLeft))+(_numCycles*(monthsInYear)*(2629746));
      return Time;
    }
  }


  /**
  *@dev function to buy dappCreater license
  *@param _numOfDappbox : number of dappbox user wants to buy
  *@param _product : type of product user wants to buy
  *@param _cycleType : defines the type of product buying span , where 0 = monthly and 1 = yearly basis
  *@param _numCycles : number of cycles user wants to buy
  */
  function purchaseDappCreator(uint256 _numOfDappbox,uint256 _productId, uint256 _cycleType, uint256 _numCycles) public whenNotPaused returns (uint256)
  {
    require(_numOfDappbox != 0, "Atleast one dappbox purchase is required");
    require(_numCycles != 0, "number of cycle should be atleast one");
    require(PI._renewableOf(_productId) == true, "dappfree cannot be dappCreator");
    bool flag = calculateAndDeductSatDappCreator(msg.sender,_numOfDappbox,_productId, _cycleType, _numCycles);
    require(flag == true, "payment failed "); 
    string memory _name = PI._getProductName(_productId);
    uint256 expTime = expirationTime(_cycleType , _numCycles );
    uint256 LId =  LI._createDappCreatorLicense(msg.sender,_numOfDappbox,_productId,_name,expTime);
    LicenseOwned memory LicenseOwners;
      LicenseOwners.licenseType = LicenseType(3); 
      LicenseOwners.licenseId = LId;
      LicenseOwners.productName = _name;
      LicenseOwners.expireTime = expTime;
      LicenseOwners.nbOfDappBox =_numOfDappbox;
      LicensesOwned[msg.sender].push(LicenseOwners);
      return LId;
  }

    /**
   * @dev calculate and deduct the amount of SAT for dapp individual8
   */
    function calculateAndDeductSatDappCreator(address sender ,uint256 numOfDappbox ,uint256 productId ,uint256 cycleType ,uint256 numCycles) internal returns (bool)
  { 
        uint256 productPrice = PI.priceOfProduct(productId);
        uint256 totalPrice;
        uint256 discountPrice;
        uint256 price;
        uint256 currentDiscount;
        if(numOfDappbox <= 10)
        {
            if(discountStructure.below10 != 0)
          {
                currentDiscount = discountStructure.below10;
          }
          else
          {
                currentDiscount = numOfDappbox-1 ;  //this is the logic for discount structure less than 10 dapp purchase , specified in task specification file .
          }                                     // it will be used until ceo of company changes the discount with some generic discount structure 
        }
        else if( numOfDappbox <= 20)
        {
            currentDiscount = discountStructure.below20;
        }
        else if(numOfDappbox <= 50)
        {
            currentDiscount = discountStructure.below50;
        }
        else if(numOfDappbox <= 100)
        {
            currentDiscount = discountStructure.below100;
        }
        else if (numOfDappbox > 100 && numOfDappbox <= 500)
        {
            currentDiscount = discountStructure.above100;
        }

        if(cycleType == 0) //monthly purchase
        {
            price = productPrice*(numCycles);
        }
        else if(cycleType == 1) // annual purchase
        {
            price = (productPrice*(numCycles))*(12);
        }

      discountPrice = (price*(currentDiscount))/(100);
      totalPrice = price-(discountPrice);
      require(SAT.havePayableAmount(msg.sender,totalPrice) ==true , "not enough SAT");
      bool res = deduct(totalPrice);
      return res ;
    }
  

  /**
  *@dev function to buy the addons by beneficiaries
  *@param _addonId : id of the addon beneficiary wants to buy
  *@param _productId : id the of the product on which addon will be based on on
  *@param _cycleType : defines the type of product buying span , where 0 = monthly and 1 = yearly basis
  *@param _numCycles : number of cycles user wants to buy  
  */
  function purchaseAddons(uint256 _addonId,uint256 _productId,uint256 _cycleType,uint256 _numCycle) external returns (uint256)
  {
    (bool flag , uint256 index )= LI._checkDappCreator(msg.sender); // checking for dappcreator , as addons should be bought by dappCreators only
    require(_productId != 0, "dappboxFree cannot be a base for addons ");
    // addon price comes without the base dappbox price 
    uint256 price;
    uint256 totalPrice;
    uint256 productPrice = PI.priceOfProduct(_productId); 
    require(flag == true,"Not a dappCreator");
    if(_cycleType == 0)
    {
      price =PI.priceOfAddon(_addonId)*(_numCycle);
      totalPrice = price+(productPrice*(_numCycle));

    }
    else 
    {
      price = PI.priceOfAddon(_addonId)*(_numCycle*(12))+(productPrice*(_numCycle*(12)));
      totalPrice = price -(price*(ixxoDiscountOnAnnualPurchase))/(100);
      
    }
    require(SAT.havePayableAmount(msg.sender,totalPrice) ==true , "not enough SAT"); //check
    require(deduct(totalPrice) == true , "payment failed");
    uint256 expTime =expirationTime(_cycleType , _numCycle); 
    string memory name = PI._getProductName(_productId);
    uint256 LId = LI._createAddonLicense( _addonId ,_productId, name,expTime);
      LicenseOwned memory LicenseOwners;
      LicenseOwners.licenseType = LicenseType(4); 
      LicenseOwners.licenseId = LId;
      LicenseOwners.productName = name;
      LicenseOwners.expireTime = expTime;
      LicenseOwners.nbOfDappBox =0;
      LicensesOwned[msg.sender].push(LicenseOwners);
      return LId;
  }


  /**
  *@dev function to create dappcreator license 
  *@Note : dappCreator can only be dappReseller
  *@param _dappPriceMonthly : monthly price for dappResale
  *@param _dappPriceAnnaual : annual price for dappResale 
  */
  function ListDappCreatorForResale(uint256 _dappPriceMonthly , uint256 _dappPriceAnnual , uint256 numOfDappBoxToResale) public returns(uint256)
  {
    (bool flag,uint256 index ) =LI._checkDappCreator(msg.sender);
    //check is dappcreator
    //check has sufficient amount of dappbox
    require(flag == true , "Not a dappCreator"); //only a dappcreator can be reseller of dapbox
    uint256 _monthlyPrice;
    uint256 _annualPrice;
    bool _monthlyDappLicense;
    bool _annualDappLicense;
    uint256 expTime = LI._getDappCreatorExpirationTime(index);
    uint256 currentMonth = BokkyPooBahsDateTimeLibrary.getMonth(now);
    uint256 expirationMonth = BokkyPooBahsDateTimeLibrary.getMonth(expTime);
    uint256 monthsLeft = expirationMonth-(currentMonth); 
    if(flag == true)
    {
      _monthlyPrice = _dappPriceMonthly;
      _monthlyDappLicense = true;


    if(monthsLeft > 12) //checking that dappcreator has license of alteast 12 months to set Annual dappCreateSale license 
    {
      _annualDappLicense = true;
      _annualPrice = _dappPriceAnnual;
    }
    else 
    {
      _annualDappLicense = false;
      _annualPrice = 0;
    } 
    }
     
 
    return LI._ListResellingDappCreator(msg.sender,index,numOfDappBoxToResale,_monthlyDappLicense ,_monthlyPrice,_annualDappLicense,_annualPrice);
  }

  /**
  * @dev set new discount for Annual purchase
  */ 
  function setDiscountOnAnnualPurchase(uint256 newDiscount) public onlyCEO whenPaused returns (bool)
  {
    ixxoDiscountOnAnnualPurchase = newDiscount ;
    return true;
  }


  /**
  * @dev function to set creator discount structure
  */
  function changeDappCreatorDiscountStructure(uint256 _below10, uint256 _below20 , uint256 _below50 , uint256 _below100 , uint256 _above100 ) public whenPaused onlyCLevel returns(bool)
  {
    discountStructure.below10 = _below10;
    discountStructure.below20 = _below20;
    discountStructure.below50 = _below50;
    discountStructure.below100 = _below100;
    discountStructure.above100 = _above100;
    return true;
  }

  
  /**
  * @dev function to return list of all the listed deapp creator for resale ,one by one 
  */
  function _returnDappCreatorResaleList(uint256 indexer) public view returns (address,uint256,uint256,bool,uint256,bool,uint256,bool,uint256)
  {
    return LI._returnDappCreatorResaleList(indexer);
  }

  
  function buyCreatorDappbox(uint256 createId, uint256 _cycleType, uint256 _numCycles) public returns(uint256)
  {
    (bool availability,uint256 resaleIndex) = LI.checkAvailability(createId);
    require(availability==true,"No creator dappbox to ell for this creator id");
    require(_numCycles != 0, "number of cycle should be atleast one");
    uint256 expTime = expirationTime(_cycleType,_numCycles);
    uint256 CreateExpTime=LI._getDappCreatorExpirationTime(createId);
    uint256 price;
    if(_cycleType == 0)
    {
       price = (LI.getCreatorMonthlyPrice(createId))*_numCycles;
    }
    else if (_cycleType == 1)
    {
        price = (LI.getCreatorAnnaulPrice(createId))*_numCycles;
    }
      bool flag = deduct(price);
      require(flag == true,"Payment failed");
      uint256 LId =LI._createCreatorResaleLicense(createId,expTime);
      LI._deductCreateDappboxFromListing(resaleIndex);
      string memory name = LI.getCreateName(createId);
      LicenseOwned memory LicenseOwners;
      LicenseOwners.licenseType = LicenseType(5); 
      LicenseOwners.licenseId = LId;
      LicenseOwners.productName = name;
      LicenseOwners.expireTime = expTime;
      LicenseOwners.nbOfDappBox = 1;
      LicensesOwned[msg.sender].push(LicenseOwners);
      return LId;
    }  


/**
* @dev renew individual dappbox 
*/
function renewIndividualDappboxLicense(uint256 LicenseId , uint256 _cycleType , uint256 _numCycles) public whenNotPaused returns (bool)
{
   // search for product type and then perform the actions 
  require(_numCycles != 0);
  address sender = msg.sender;
  bool flag = isOwnerOfLicense(LicenseId);
  require(flag == true,"not the owner of license , cannot be renewed");
  uint256 productId = LI._licenseProductId(LicenseId);
  require(PI._renewableOf(productId)==true , "not a rewable product");
  bool res = calculateAndDeductSat(sender ,productId, _cycleType, _numCycles);
  require (res == true , "payment failed");
  uint256 currentExpTime = LI._getDappIndividualExpirationTime(LicenseId);
  uint256 finalExpTime = _calculateRenewalTime(currentExpTime , _cycleType , _numCycles);
  return LI._renewIndividualLicense(LicenseId ,productId ,finalExpTime);
}


/**
*@dev renew creator license
*/
function renewDappboxCreatorLicense(uint256 LicenseId , uint256 _cycleType , uint256 _numCycles) public whenNotPaused returns (bool)
{
  require(_numCycles != 0);
  bool flag = isOwnerOfLicense(LicenseId);
  require(flag == true,"not the owner of license , cannot be renewed");
  uint256 productId =LI._licenseCreatorProductId(LicenseId);
  uint256 _numOfDappbox = LI._licenseCreatordappboxVolume(LicenseId);
  bool res = calculateAndDeductSatDappCreator(msg.sender ,_numOfDappbox,productId , _cycleType , _numCycles);
  if(res == true )
  {
    uint256 currentExpTime = LI._getDappCreatorExpirationTime(LicenseId);
    uint256 finalExpTime = _calculateRenewalTime(currentExpTime , _cycleType , _numCycles);
    return LI._renewCreatorLicense(LicenseId ,productId ,finalExpTime);
  }
  else 
  {
  return false ;
  }
}

function isOwnerOfLicense(uint256 LicenseId) internal view returns(bool) 
{
  bool flag = false;
  uint256 len = LicensesOwned[msg.sender].length;
  for(uint256 i = 0 ; i<len ; i++)
  {
    if(LicenseId==LicensesOwned[msg.sender][i].licenseId)
    {
        flag = true;
    }
  }
  return flag;
}



/**
* @dev function to renew addon license
*/
function renewAddonLicense(uint256 LicenseId , uint256 _cycleType , uint256 _numCycles) public whenNotPaused returns (bool)
{
  require(_numCycles != 0);
  bool flag = isOwnerOfLicense(LicenseId);
  require(flag == true,"not the owner of license , cannot be renewed");
  uint256 addonId = LI._licenseAddonProductId(LicenseId);
  uint256 productId =  LI._licenseAddonBaseProductId(LicenseId);
  uint256 price;
  uint256 totalPrice ;
  uint256 addonPrice =PI.priceOfAddon(addonId);
  uint256 productPrice = PI.priceOfProduct(productId);
       if(_cycleType == 0)
      {
          price =addonPrice*(_numCycles);
          totalPrice = price+(productPrice*(_numCycles));
      }
    else 
      {
          uint256 price1 = addonPrice*(_numCycles*(12));
          uint256 price2 = productPrice*(_numCycles*(12));
          price = price1+(price2);
          uint256 discount = (price*(ixxoDiscountOnAnnualPurchase))/(100);
          totalPrice = price-(discount);
      }
    require(deduct(totalPrice) == true, "not enough sat in single entry");
    uint256 currentExpTime = LI._getAddonExpirationTime(LicenseId);
    uint256 finalExpTime = _calculateRenewalTime(currentExpTime , _cycleType , _numCycles);
    return LI._renewAddonLicense(LicenseId,addonId,finalExpTime);
     
}

  /**
  * @dev function to renew addon license
  */
  function renewCreateResaleLicense(uint256 LicenseId , uint256 _cycleType , uint256 _numCycles) public whenNotPaused returns (bool)
  {
    bool flag = isOwnerOfLicense(LicenseId);
    require(flag == true,"not the owner of license , cannot be renewed");
    require(_numCycles != 0, "number of cycle should be atleast one");
    uint256 expTime = expirationTime(_cycleType,_numCycles);
    uint256 CreateExpTime=LI._getDappCreatorExpirationTime(LicenseId);
    uint256 price;
    if(_cycleType == 0)
    {
       price = (LI.getCreatorMonthlyPrice(LicenseId))*_numCycles;
    }
    else if (_cycleType == 1)
    {
        price = (LI.getCreatorAnnaulPrice(LicenseId))*_numCycles;
    }
    bool res = deduct(price);
    require(res == true,"Payment failed");
    uint256 currentExpTime = LI._getcreateResaleExpirationTime(LicenseId);
    uint256 finalExpTime = _calculateRenewalTime(currentExpTime , _cycleType , _numCycles);
    uint256 baseProductId = LI._getCreatorResaleBaseProductId(LicenseId);
    return LI._renewCreatorResaleLicense(LicenseId,baseProductId,finalExpTime);

}

function _calculateRenewalTime(uint256 currentExpirationTime ,uint256 cycleType, uint256 numCycles) internal view returns (uint256) {

uint256 newExpirationTime;
uint256 calculatedTime = expirationTime(cycleType , numCycles);

  if(currentExpirationTime <= now )
  {
    newExpirationTime = now+(calculatedTime);

    return newExpirationTime;

  }
  else if(currentExpirationTime > now)
  {
    newExpirationTime = calculatedTime + (currentExpirationTime);

    return newExpirationTime;
  }
    
  }


  /**
  * @dev function to transfer the tokens from beneficiary to ixxo
  */
  function deduct(uint256 tokens) internal returns(bool)
  {
    bool res;
    if(SAT.havePayableAmount(msg.sender,tokens) == true)
    {
      res = SAT.spendTokenForIxxoServices(tokens);
      return res;
  }
    return false;
  } 

}
