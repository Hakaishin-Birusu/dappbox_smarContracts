
// File: contracts/AccessControl.sol

pragma solidity >=0.4.21 <0.6.0;

contract AccessControl
{
    bool paused ;
    address ceo;
    address cfo;
    address coo;
    address withdrawalAddress;

    constructor() public {
        ceo = msg.sender;
        cfo = msg.sender;
        coo = msg.sender;
        withdrawalAddress = msg.sender;
        paused = false;
    }


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

  
}

// File: contracts/LicenseInventory.sol

pragma solidity >=0.4.21 <0.6.0;


contract LicenseInventory is AccessControl
{


  event LicenseIssued(address indexed owner ,uint256 licenseId,uint256 productId,string productName,uint256 issuedTime,uint256 expirationTime);
  event LicenseRenewal(address indexed owner,uint256 licenseId,uint256 productId,uint256 expirationTime);
  event DappCreatorLicenseIssued(address indexed owner,uint256 licenseId,uint256 productId,uint256 productVolume,string productName,uint256 issuedTime,uint256 expirationTime);
  event DappCreatorResale(address indexed owner , bool setMonthlyLicense , uint256 monthlyLicensePrice , bool setAnnualLicense , uint256 AnuualLicensePrice);


 struct License {
    address owner;
    uint256 productId;
    string productName;
    uint256 issuedTime;
    uint256 expirationTime;
  }

    struct CreatorLicense {
    address owner;
    uint256 productId;
    string productName ;
    uint256 dappboxVolume;
    uint256 issuedTime;
    uint256 expirationTime;
    //uint256[] addonsLicenseId;
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

    struct CreateResaleLicense
  {
    uint256 creatorLicense;
    bool MontlyLicense;
    bool AnnualLicense;
    uint256 MonthlyLicensePrice;
    uint256 AnnualLicensePrice; 
  }

   License[] licenses;
   CreatorLicense[] creatorLicense;
   CreateResaleLicense[] ResaleLicense;
   AddonLicense[] addonLicense ;



  function licenseProductId(uint256 _licenseId) public view returns (uint256) {
    return licenses[_licenseId].productId;
  }
  function licenseCreatorProductId(uint256 _licenseId) public view returns(uint256){
    return creatorLicense[_licenseId].productId;
  }

  function licenseAddonProductId(uint256 _licenseId) public view returns (uint256){
    return addonLicense[_licenseId].addonId;


  }

}

// File: contracts/ProductInventory.sol

pragma solidity >=0.4.21 <0.6.0;


contract ProductInventory is LicenseInventory
{
    event ProductOrAddonCreated(uint256 id,string productName,uint256 price);
    event PriceChanged(uint256 productId,uint256 newPrice);

    constructor () public 
    {
        _createProduct(101,"dappFree",0,2,2,1,false);
        _createProduct(102,"dappStart",300,20,4,2,true);
        _createProduct(103,"dappPremium",800,200,8,4,true);
        _createAddon(201,"RocketChat",100);
        _createAddon(202,"Taiga Server",100); 
    }

    struct Product
    {
        uint256 id;
        string productName;
        uint256 price;
        uint256 hardDrive;
        uint256 maxMemory;
        uint256 maxProcess ;
        bool renewable;
    }

    struct addOnProduct 
    { 
        uint256 addonId;
        string addonName ;
        uint256 addonPrice; // only addon price , base dppbox individual price is not added 
    }

    uint256[] public allProductIds;
    uint256[] public allAddonsIds;

    mapping (uint256 => Product) public products;
    mapping (uint256 => addOnProduct) public addOnProducts;

    function setProductPrice(uint256 _productId, uint256 _price)public onlyCLevel
  {
        products[_productId].price = _price;
        emit PriceChanged(_productId, _price);
    }

   /**
  * @notice setPriceOfAddon - sets the price of a addon
  * @param _AddonId - the addonId id
  * @param _price - the product price
  */
    function setAddonPrice(uint256 _AddonId, uint256 _price)public onlyCLevel
    {       
        addOnProducts[_AddonId].addonPrice = _price;
        emit PriceChanged(_AddonId,_price);
    }
    
    function _createProduct(
    uint256 _productId,
    string memory _productName,
    uint256 _hardDrive,
    uint256 _maxMemory,
    uint256 _maxProcess,
    uint256 _initialPrice,
    bool _renewal
    )
    internal
  {
    //require(_productDoesNotExist(_productId));

    Product memory _product = Product({
      id: _productId,
      productName : _productName,
      price: _initialPrice,
      hardDrive: _hardDrive,
      maxMemory: _maxMemory,
      maxProcess: _maxProcess,
      renewable: _renewal 
    });
    products[_productId] = _product;
    allProductIds.push(_productId);

    emit  ProductOrAddonCreated(
      _product.id,
      _product.productName,
      _product.price
      );
  }

  function _createAddon(uint256 _productId,string memory _productName, uint256 _initialPrice)internal
  {
    //require(_addonDoesNotExist(_productId));

    addOnProduct  memory _addOnProduct  = addOnProduct ({
      addonId:_productId,
      addonName:_productName,
      addonPrice:_initialPrice 
    });
    
    addOnProducts[_productId] = _addOnProduct;
    allAddonsIds.push(_productId);

     emit ProductOrAddonCreated(
      _addOnProduct.addonId,
      _addOnProduct.addonName,
      _addOnProduct.addonPrice
      );
  }

     function createAddon(uint256 _productId,string memory _productName,uint256 _initialPrice) public onlyCLevel
  {
    _createAddon(_productId,_productName,_initialPrice);
  }
  function createProduct(
    uint256 _productId,
    string memory  _productName,
    uint256 _initialPrice,
    uint256 _hardDrive,
    uint256 _maxMemory,
    uint256 _maxProcess,
    bool _renewal)
    public
    onlyCLevel
  {
    _createProduct(
      _productId,
      _productName,
      _initialPrice,
      _hardDrive,
      _maxMemory,
      _maxProcess,
      _renewal);
  }

  function renewableOf(uint256 _productId) public view returns (bool) {
    //require(_productId != 0,"not a valid product");
    return products[_productId].renewable;
  }
  

  /*
   * @dev returns the current price of requesting addon ,
   * NOTE ; the price is of addon only not te base dappbox individual we are using to serve the addon  
   */
  

    /**
  * @notice The price of a product
  * @param _productId - the product id
  */
  function priceOfProduct(uint256 _productId) public view returns (uint256) {
    return products[_productId].price;
  }
  /*
   * @dev returns the current price of requesting addon ,
   * NOTE ; the price is of addon only not te base dappbox individual we are using to serve the addon  
   */
  function priceOfAddon (uint256 _addonId) public view returns(uint256)
  {
    return addOnProducts[_addonId].addonPrice ;
  }

  /**
   * @dev returns the name of addon related to the supplied addonId
   */

  function _getAddonName(uint256 _addonId) public view returns (string memory)
  {
    return addOnProducts[_addonId].addonName;

  }

  function _getProductName(uint256 _productId) public view returns (string memory)
  {
    return products[_productId].productName;

  }


}

// File: contracts/Deps/SpendingAllowanceToken.sol

pragma solidity >=0.4.24<0.6.0;

contract SpendingAllowanceToken
{
    function transferTokens(address,address,uint256) public returns(uint256, uint256){}
    function validateTransaction(uint256,uint256) public returns(bool){}  
    function totalTokensHeld() public pure returns(uint256){}
}

// File: contracts/Deps/ReleaseTransaction.sol

pragma solidity >=0.4.24<0.6.0;

contract ReleaseTransaction
{
    function getAllPendingRequests(uint256) public view returns(uint256[] memory,uint256,bool){}
    function getReleaseTransaction(uint256,uint256) public view returns (address , uint256 , uint256,address,uint256,uint256){}
}

// File: contracts/Deps/BokkyPooBahsDateTimeLibrary.sol

pragma solidity >=0.4.21 <0.6.0;

// ----------------------------------------------------------------------------
// BokkyPooBah's DateTime Library v1.01
//
// A gas-efficient Solidity date and time library
//
// https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
//
// Tested date range 1970/01/01 to 2345/12/31
//
// Conventions:
// Unit      | Range         | Notes
// :-------- |:-------------:|:-----
// timestamp | >= 0          | Unix timestamp, number of seconds since 1970/01/01 00:00:00 UTC
// year      | 1970 ... 2345 |
// month     | 1 ... 12      |
// day       | 1 ... 31      |
// hour      | 0 ... 23      |
// minute    | 0 ... 59      |
// second    | 0 ... 59      |
// dayOfWeek | 1 ... 7       | 1 = Monday, ..., 7 = Sunday
//
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018-2019. The MIT Licence.
// ----------------------------------------------------------------------------

library BokkyPooBahsDateTimeLibrary {

    uint constant SECONDS_PER_DAY = 24 * 60 * 60;
    uint constant SECONDS_PER_HOUR = 60 * 60;
    uint constant SECONDS_PER_MINUTE = 60;
    int constant OFFSET19700101 = 2440588;

    uint constant DOW_MON = 1;
    uint constant DOW_TUE = 2;
    uint constant DOW_WED = 3;
    uint constant DOW_THU = 4;
    uint constant DOW_FRI = 5;
    uint constant DOW_SAT = 6;
    uint constant DOW_SUN = 7;

    // ------------------------------------------------------------------------
    // Calculate the number of days from 1970/01/01 to year/month/day using
    // the date conversion algorithm from
    //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
    // and subtracting the offset 2440588 so that 1970/01/01 is day 0
    //
    // days = day
    //      - 32075
    //      + 1461 * (year + 4800 + (month - 14) / 12) / 4
    //      + 367 * (month - 2 - (month - 14) / 12 * 12) / 12
    //      - 3 * ((year + 4900 + (month - 14) / 12) / 100) / 4
    //      - offset
    // ------------------------------------------------------------------------
    function _daysFromDate(uint year, uint month, uint day) internal pure returns (uint _days) {
        require(year >= 1970);
        int _year = int(year);
        int _month = int(month);
        int _day = int(day);

        int __days = _day
          - 32075
          + 1461 * (_year + 4800 + (_month - 14) / 12) / 4
          + 367 * (_month - 2 - (_month - 14) / 12 * 12) / 12
          - 3 * ((_year + 4900 + (_month - 14) / 12) / 100) / 4
          - OFFSET19700101;

        _days = uint(__days);
    }

    // ------------------------------------------------------------------------
    // Calculate year/month/day from the number of days since 1970/01/01 using
    // the date conversion algorithm from
    //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
    // and adding the offset 2440588 so that 1970/01/01 is day 0
    //
    // int L = days + 68569 + offset
    // int N = 4 * L / 146097
    // L = L - (146097 * N + 3) / 4
    // year = 4000 * (L + 1) / 1461001
    // L = L - 1461 * year / 4 + 31
    // month = 80 * L / 2447
    // dd = L - 2447 * month / 80
    // L = month / 11
    // month = month + 2 - 12 * L
    // year = 100 * (N - 49) + year + L
    // ------------------------------------------------------------------------
    function _daysToDate(uint _days) internal pure returns (uint year, uint month, uint day) {
        int __days = int(_days);

        int L = __days + 68569 + OFFSET19700101;
        int N = 4 * L / 146097;
        L = L - (146097 * N + 3) / 4;
        int _year = 4000 * (L + 1) / 1461001;
        L = L - 1461 * _year / 4 + 31;
        int _month = 80 * L / 2447;
        int _day = L - 2447 * _month / 80;
        L = _month / 11;
        _month = _month + 2 - 12 * L;
        _year = 100 * (N - 49) + _year + L;

        year = uint(_year);
        month = uint(_month);
        day = uint(_day);
    }

    function timestampFromDate(uint year, uint month, uint day) internal pure returns (uint timestamp) {
        timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY;
    }
    function timestampFromDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) internal pure returns (uint timestamp) {
        timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + hour * SECONDS_PER_HOUR + minute * SECONDS_PER_MINUTE + second;
    }
    function timestampToDate(uint timestamp) internal pure returns (uint year, uint month, uint day) {
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function timestampToDateTime(uint timestamp) internal pure returns (uint year, uint month, uint day, uint hour, uint minute, uint second) {
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        uint secs = timestamp % SECONDS_PER_DAY;
        hour = secs / SECONDS_PER_HOUR;
        secs = secs % SECONDS_PER_HOUR;
        minute = secs / SECONDS_PER_MINUTE;
        second = secs % SECONDS_PER_MINUTE;
    }

    function isValidDate(uint year, uint month, uint day) internal pure returns (bool valid) {
        if (year >= 1970 && month > 0 && month <= 12) {
            uint daysInMonth = _getDaysInMonth(year, month);
            if (day > 0 && day <= daysInMonth) {
                valid = true;
            }
        }
    }
    function isValidDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) internal pure returns (bool valid) {
        if (isValidDate(year, month, day)) {
            if (hour < 24 && minute < 60 && second < 60) {
                valid = true;
            }
        }
    }
    function isLeapYear(uint timestamp) internal pure returns (bool leapYear) {
        uint year;
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        leapYear = _isLeapYear(year);
    }
    function _isLeapYear(uint year) internal pure returns (bool leapYear) {
        leapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
    }
    function isWeekDay(uint timestamp) internal pure returns (bool weekDay) {
        weekDay = getDayOfWeek(timestamp) <= DOW_FRI;
    }
    function isWeekEnd(uint timestamp) internal pure returns (bool weekEnd) {
        weekEnd = getDayOfWeek(timestamp) >= DOW_SAT;
    }
    function getDaysInMonth(uint timestamp) internal pure returns (uint daysInMonth) {
        uint year;
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        daysInMonth = _getDaysInMonth(year, month);
    }
    function _getDaysInMonth(uint year, uint month) internal pure returns (uint daysInMonth) {
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
            daysInMonth = 31;
        } else if (month != 2) {
            daysInMonth = 30;
        } else {
            daysInMonth = _isLeapYear(year) ? 29 : 28;
        }
    }
    // 1 = Monday, 7 = Sunday
    function getDayOfWeek(uint timestamp) internal pure returns (uint dayOfWeek) {
        uint _days = timestamp / SECONDS_PER_DAY;
        dayOfWeek = (_days + 3) % 7 + 1;
    }

    function getYear(uint timestamp) internal pure returns (uint year) {
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function getMonth(uint timestamp) internal pure returns (uint month) {
        uint year;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function getDay(uint timestamp) internal pure returns (uint day) {
        uint year;
        uint month;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function getHour(uint timestamp) internal pure returns (uint hour) {
        uint secs = timestamp % SECONDS_PER_DAY;
        hour = secs / SECONDS_PER_HOUR;
    }
    function getMinute(uint timestamp) internal pure returns (uint minute) {
        uint secs = timestamp % SECONDS_PER_HOUR;
        minute = secs / SECONDS_PER_MINUTE;
    }
    function getSecond(uint timestamp) internal pure returns (uint second) {
        second = timestamp % SECONDS_PER_MINUTE;
    }

    function addYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
        uint year;
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        year += _years;
        uint daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        require(newTimestamp >= timestamp);
    }
    function addMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
        uint year;
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        month += _months;
        year += (month - 1) / 12;
        month = (month - 1) % 12 + 1;
        uint daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        require(newTimestamp >= timestamp);
    }
    function addDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp + _days * SECONDS_PER_DAY;
        require(newTimestamp >= timestamp);
    }
    function addHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp + _hours * SECONDS_PER_HOUR;
        require(newTimestamp >= timestamp);
    }
    function addMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp + _minutes * SECONDS_PER_MINUTE;
        require(newTimestamp >= timestamp);
    }
    function addSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp + _seconds;
        require(newTimestamp >= timestamp);
    }

    function subYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
        uint year;
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        year -= _years;
        uint daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        require(newTimestamp <= timestamp);
    }
    function subMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
        uint year;
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        uint yearMonth = year * 12 + (month - 1) - _months;
        year = yearMonth / 12;
        month = yearMonth % 12 + 1;
        uint daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        require(newTimestamp <= timestamp);
    }
    function subDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp - _days * SECONDS_PER_DAY;
        require(newTimestamp <= timestamp);
    }
    function subHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp - _hours * SECONDS_PER_HOUR;
        require(newTimestamp <= timestamp);
    }
    function subMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp - _minutes * SECONDS_PER_MINUTE;
        require(newTimestamp <= timestamp);
    }
    function subSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp - _seconds;
        require(newTimestamp <= timestamp);
    }

    function diffYears(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _years) {
        require(fromTimestamp <= toTimestamp);
        uint fromYear;
        uint fromMonth;
        uint fromDay;
        uint toYear;
        uint toMonth;
        uint toDay;
        (fromYear, fromMonth, fromDay) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
        (toYear, toMonth, toDay) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
        _years = toYear - fromYear;
    }
    function diffMonths(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _months) {
        require(fromTimestamp <= toTimestamp);
        uint fromYear;
        uint fromMonth;
        uint fromDay;
        uint toYear;
        uint toMonth;
        uint toDay;
        (fromYear, fromMonth, fromDay) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
        (toYear, toMonth, toDay) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
        _months = toYear * 12 + toMonth - fromYear * 12 - fromMonth;
    }
    function diffDays(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _days) {
        require(fromTimestamp <= toTimestamp);
        _days = (toTimestamp - fromTimestamp) / SECONDS_PER_DAY;
    }
    function diffHours(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _hours) {
        require(fromTimestamp <= toTimestamp);
        _hours = (toTimestamp - fromTimestamp) / SECONDS_PER_HOUR;
    }
    function diffMinutes(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _minutes) {
        require(fromTimestamp <= toTimestamp);
        _minutes = (toTimestamp - fromTimestamp) / SECONDS_PER_MINUTE;
    }
    function diffSeconds(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _seconds) {
        require(fromTimestamp <= toTimestamp);
        _seconds = toTimestamp - fromTimestamp;
    }
}

// File: contracts/LicenseSale.sol

pragma solidity >=0.4.21 <0.6.0;





contract LicenseSale is ProductInventory
{
    uint256 ixxoDiscountOnAnnualPurchase;
    uint256 dappBoxFreeCount;
    SpendingAllowanceToken sat;
    ReleaseTransaction rt;

    constructor(address _t) public 
    {
        sat = SpendingAllowanceToken(_t);
        rt = ReleaseTransaction(_t);
        ixxoDiscountOnAnnualPurchase = 25;
        dappBoxFreeCount = 500;
        discountStructure.below10 = 0; // discount in specification is calculated down in the code , it is kept zero till no generic discount is described by the CEO ,for less than 10 dappbox purchase
        discountStructure.below20 = 15;
        discountStructure.below50 = 20;
        discountStructure.below100 = 25;
        discountStructure.above100 = 30;
    }

    /**
     * @dev structure to store the discount given at the time of dappCreator purchase , according to volume of purchase 
     */
    struct CreatorDiscountStructure{
        uint256 below10;
        uint256 below20;
        uint256 below50;
        uint256 below100;
        uint256 above100;
    }

    CreatorDiscountStructure public discountStructure;
   
   

  /**
  * @dev this function facilitates the purchasing of license for individual dappbox (dappboxFree , dappboxStart , dappboxPremium)
  * dappfree should be of _cycleType = 0 (monthly)
  * dappfree will be of _numCycles = 1 (as this trail is for only one month)
  */
    function purchaseDappBoxIndividual (uint256 _productId, uint256 _cycleType, uint256 _numCycles ) external whenNotPaused returns (uint256)
  {
        address _assignee;
        require(_numCycles != 0, "number of cycle should be atleast one");
        if(renewableOf(_productId)==false)   //it means purchasing dappbox free
          {
            bool result = _notAlreadyDappFreeOwner(_assignee);
            require(result == true, "Already dappfree Owner , dappfree is one per per entity");
            require(_cycleType == 0, "non-renewable products cannot be bought for yearly basis");  
            require(_numCycles == 1,"trail product can be purchased for one month only");
            require(checkDappBoxFreeRunning() < dappBoxFreeCount,"DappboxFree count exceeded");
          }
        bool flag = calculateAndDeductSat(_assignee,_productId, _cycleType, _numCycles);
        require(flag == true, "Payment failed");
        uint256 licenseId = _createDappBoxIndividualLicense(_assignee,_productId, _cycleType,_numCycles);         
        return licenseId;
    }

  /**
   *
   */
    function calculateAndDeductSat (address spender, uint256 product, uint256 cycleType , uint256 numOfCycle) internal returns (bool)
      {
        uint256 satToDeduct;
        uint256 prorateSat;
        uint256 satForMonthsLeft;
        bool res = false;
        uint256 productPrice = priceOfProduct(product);

        if(cycleType == 0)
        {
            prorateSat = calculateProrata(productPrice, cycleType);
            --numOfCycle;
            satForMonthsLeft = productPrice*(numOfCycle);
            satToDeduct = prorateSat+(satForMonthsLeft);
            res = deduct(spender,satToDeduct);
            return res;
        }
      else if(cycleType == 1)
      {
        prorateSat = calculateProrata(productPrice, cycleType);
        satForMonthsLeft = (productPrice*(numOfCycle*(12)));
        uint256 Price = prorateSat+(satForMonthsLeft);
        uint256 discount = (Price*(ixxoDiscountOnAnnualPurchase))/(100);
        satToDeduct = Price-(discount);
        res = deduct(spender, satToDeduct); 
        return res;
      }
    }

  /**
    * @dev creates and stores the license if Transaction is successfull 
    *
    */
    function _createDappBoxIndividualLicense(address owner ,uint256 _productId,uint256 _cycleType,uint256 _numCycles) internal returns(uint256)
    {

        uint256 expTime = expirationTime(_cycleType, _numCycles) ;
        string memory _name = _getProductName(_productId);
        License memory _license = License({
            owner: owner,
            productId: _productId,
            productName : _name,
            issuedTime: now, 
            expirationTime: expTime
            });

        uint256 newLicenseId = licenses.push(_license) - 1; 
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
   * @dev 
   */

    function purchaseDappCreator(uint256 _numOfDappbox,uint256 _productId, uint256 _cycleType, uint256 _numCycles) external whenNotPaused returns (uint256)
    {
        address sender = msg.sender;
        require(_numOfDappbox != 0, "Atleast one dappbox purchase is required");
        require(_numCycles != 0, "number of cycle should be atleast one");
        require(renewableOf(_productId) == true, "dappfree cannot be dappCreator");
        bool flag = calculateAndDeductSatDappCreator(sender,_numOfDappbox,_productId, _cycleType, _numCycles);
        require(flag == true, "payment failed ");

        // add sold dapp creator in products with dappbox volume 
        return  _createDappCreatorLicense( sender,_numOfDappbox , _productId , _cycleType , _numCycles);
        
    }

  /**
   * @dev calculate and deduct the amount of SAT for dapp individual8
   */

    function calculateAndDeductSatDappCreator(address sender ,uint256 numOfDappbox ,uint256 productId ,uint256 cycleType ,uint256 numCycles) internal returns (bool)
  { 
        uint256 productPrice = priceOfProduct(productId);
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
      bool res = deduct(sender , totalPrice);
      return res ;
}



function _createDappCreatorLicense(address _assignee,uint256 _numOfDappbox, uint256 _productId , uint256 _cycleType ,uint256 _numCycles) internal returns(uint256)
{
  string memory _name = _getProductName(_productId);
  uint256 expTime = expirationTime(_cycleType , _numCycles );
 
   CreatorLicense memory _license = CreatorLicense({
    owner: _assignee ,
    productId: _productId,
    productName: _name,
    dappboxVolume: _numOfDappbox,
    issuedTime: now ,
    expirationTime:expTime 
    });

    uint256 newLicenseId = creatorLicense.push(_license) - 1;
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



    function buyAddons( uint256 _addonId ,uint256 _productId  , uint256 _cycleType , uint256 _numCycle  ) external returns (uint256)
    {
      
      (bool flag , uint256 index )= checkDappCreator(msg.sender); // checking for dappcreator , as addons should be bought by dappCreators only
      require(_productId != 0, "dappboxFree cannot be base for addons ");
      // addon price comes with the base dappbox price as well
      uint256 price;
      uint256 totalPrice;
      uint256 productPrice = priceOfProduct(_productId); 
      uint256 addonPrice = priceOfAddon(_addonId);
      require(flag == true,"Not a dappCreator");
      if(_cycleType == 0)
      {
          price =addonPrice*(_numCycle);
          totalPrice = price+(productPrice*(_numCycle));
      }
    else 
      {
          price = addonPrice*(_numCycle*(12))+(productPrice*(_numCycle*(12)));
          uint256 discount = (price*(ixxoDiscountOnAnnualPurchase))/(100);
          totalPrice = price-(discount);
      }

      require(sat.totalTokensHeld() >= totalPrice , "not enough SAT");
      bool res =deduct(msg.sender, totalPrice);
      require(res == true , "payment failed");
      return _createAddonLicense( _addonId ,_cycleType , _numCycle , _productId);
      
        //add the license of addon brought to the account of dappcreator license 
        // add number of addon sold  

      }

  /**
  
   */
    function _createAddonLicense( uint256 addonId ,uint256 _cycleType , uint256 _numCycle , uint256 _productId ) internal returns(uint256)
    {        address spender = msg.sender ;
      uint256 expTime =expirationTime(_cycleType , _numCycle); 
      string memory name = _getProductName(_productId);
        AddonLicense memory newList = AddonLicense({
          owner: spender,
        addonId: addonId,
        baseProductId:_productId,
        addonName: name,
        issuedTime: now,
        expirationTime: expTime  
        });

        uint256 newAddonLicense = addonLicense.push(newList)-1;
        //if single entry than add abnew one by deleting 1 if none tstar checking fro idex zero
        return newAddonLicense;
    }
  



function dappCreatorSell(uint256 _dappPriceMonthly , uint256 _dappPriceAnnual) public returns(uint256)
{
  // checking of dappfree for being reseller is not required , since dappcreator can only be reseller and this condition we have checked earlier only 
  address dappcreator = msg.sender ;
  (bool flag , uint256 index ) =checkDappCreator(dappcreator);
  require(flag == true , "Not a dappCreator"); //only a dappcreator can be reseller of dapbox
  uint256 _monthlyPrice;
  uint256 _annualPrice;
  bool _monthlyDappLicense;
  bool _annualDappLicense;
  
  uint256 expTime = creatorLicense[index].expirationTime ;
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
    _annualDappLicense = false ;
    _annualPrice = 0;
  }
}

     CreateResaleLicense memory newList = CreateResaleLicense({
    creatorLicense: index ,
    MontlyLicense: _monthlyDappLicense ,
    AnnualLicense: _annualDappLicense ,
    MonthlyLicensePrice: _monthlyPrice ,
    AnnualLicensePrice: _annualPrice 
    });

  uint256 newLicenseId = ResaleLicense.push(newList) - 1;

 
return newLicenseId;
}


 

function renewIndividualDappboxLicense(uint256 LicenseId , uint256 _cycleType , uint256 _numCycles) public whenNotPaused returns (bool)
{
   // search for product type and then perform the actions 
  require(_numCycles != 0);
  address sender = msg.sender;
  uint256 productId = licenseProductId(LicenseId);
  require(renewableOf(productId)==true , "not a rewable product");
  bool flag = calculateAndDeductSat(sender ,productId, _cycleType, _numCycles);
  require (flag == true , "payment failed");
  uint256 currentExpTime = licenses[LicenseId].expirationTime;
  uint256 finalExpTime = _calculateRenewalTime(currentExpTime , _cycleType , _numCycles);
  licenses[LicenseId].expirationTime = finalExpTime;
  emit LicenseRenewal(
      msg.sender,
      LicenseId,
      productId,
      finalExpTime
    );

  return true ;
}



function renewDappboxCreatorLicense(uint256 LicenseId , uint256 _cycleType , uint256 _numCycles) public whenNotPaused returns (bool)
{
  require(_numCycles != 0);

  uint256 productId = licenseCreatorProductId(LicenseId);
  uint256 _numOfDappbox = creatorLicense[productId].dappboxVolume;

bool res = calculateAndDeductSatDappCreator(msg.sender ,_numOfDappbox,productId , _cycleType , _numCycles);
if(res == true )
{
  uint256 currentExpTime = creatorLicense[LicenseId].expirationTime;
  uint256 finalExpTime = _calculateRenewalTime(currentExpTime , _cycleType , _numCycles);
  creatorLicense[LicenseId].expirationTime= finalExpTime ;
  emit LicenseRenewal(
      msg.sender,
      LicenseId,
      productId,
      finalExpTime
    );

  return true ;
}
else 
{
  return false ;
}
}



function renewAddonLicense(uint256 LicenseId , uint256 _cycleType , uint256 _numCycles) public whenNotPaused returns (bool)
{
  require(_numCycles != 0);
  uint256 addonId = licenseAddonProductId(LicenseId);
  uint256 baseProductId = addonLicense[LicenseId].baseProductId;
  uint256 price;
  uint256 totalPrice ;
  uint256 addonPrice = priceOfProduct(addonId);
  uint256 productPrice = priceOfProduct(baseProductId);
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
     
     renewEvent(LicenseId , addonId  ,totalPrice , _cycleType , _numCycles);
   

}

function renewEvent (uint256 LicenseId , uint256 addonId   , uint256 totalPrice , uint256 _cycleType , uint256 _numCycles) internal returns (bool)
{
   require(sat.totalTokensHeld() >= totalPrice , "not enough SAT");
      require(deduct(msg.sender, totalPrice) ==true , "payment failed");
        uint256 currentExpTime = licenses[LicenseId].expirationTime;
    uint256 finalExpTime = _calculateRenewalTime(currentExpTime , _cycleType , _numCycles);
     addonLicense[LicenseId].expirationTime = finalExpTime;
 emit LicenseRenewal(
      msg.sender,
      LicenseId,
      addonId,
      finalExpTime
    ); 


  return true ;
}

function calculateProrata (uint256 _productPrice , uint256 _cycleType ) internal view returns (uint256)
{
    uint256 timestamp = now ;
    uint256 currentDay = BokkyPooBahsDateTimeLibrary.getDay(timestamp);
    uint256 daysInMonth = BokkyPooBahsDateTimeLibrary.getDaysInMonth( timestamp);
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



  function deduct(address _spender , uint256 _satToDeduct) internal returns (bool)
  {
    // This function should only send the transaction to the SAT contract 

    // call function transfer token

  }



  function changeIxxoDiscountOnAnnualPurchase(uint256 newDiscount) public onlyCEO whenPaused returns (bool)
  {
    ixxoDiscountOnAnnualPurchase = newDiscount ;
    return true;
  }

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
  * @dev supporting functions
  */

function expirationTime(uint256 _cycleType ,uint256  _numCycles) internal view  returns (uint256)
{
    uint256 timestamp = now ;
    uint256 currentDay = BokkyPooBahsDateTimeLibrary.getDay(timestamp) ;
    uint256 currentMonth = BokkyPooBahsDateTimeLibrary.getMonth(timestamp);
    uint256 daysInMonth = BokkyPooBahsDateTimeLibrary.getDaysInMonth( timestamp) ;
    uint256 daysLeft = daysInMonth-(currentDay);
    uint256 monthsInYear = 12 ;
       
  uint256 DaysInSec = daysLeft*(86400); // sec in day 
  _numCycles--;
  uint256 Time ;
  if (_cycleType == 0)
  {

    Time = (_numCycles*(2629746))+(DaysInSec); // sec in month
    return Time ;
  }
  else if (_cycleType == 1 )
  {
    uint256 numOfMonthsLeft = ((monthsInYear)-(currentMonth))*(2629746);
   Time = ((DaysInSec)+(numOfMonthsLeft))+(_numCycles*(monthsInYear)*(2629746));

    return Time ;
  }
}


 function checkDappBoxFreeRunning() internal view returns (uint256)
 {
   uint256 timestamp = now ;
   uint256 flag = 0;
   uint256 len = licenses.length -1;
   for(uint256 i= 0 ; i< len ; i++)
   {
     if(licenses[i].productId == 1 && licenses[i].expirationTime < timestamp )
     {
       flag++;
     }
     return flag;
   }
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
    newExpirationTime = calculatedTime+(currentExpirationTime);

    return newExpirationTime;
  }
    
  }


function checkDappCreator(address beneficiary) internal view  returns(bool , uint256)
{
  bool flag = false ;
  uint256 index ;
  uint256 len = creatorLicense.length -1 ;
  for(uint256 i= 0 ; i< len; i++)
{
    if(beneficiary == creatorLicense[i].owner )
      {
        index = i ;
        flag = true;
      }
}
return (flag , index);
} 


    function _notAlreadyDappFreeOwner(address beneficiary) internal view returns(bool)
   {
     uint256 len = licenses.length -1;
     for(uint256 i = 0 ; i<len;i++)
     {
       if(beneficiary == (licenses[i].owner))
       {
         return true;
       }

     }
     return false;
   } 




}
