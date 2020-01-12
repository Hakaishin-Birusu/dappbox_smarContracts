
// File: contracts/BokkyPooBahsDateTimeLibrary.sol

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

// File: contracts/ReleaseTransaction.sol

pragma solidity >=0.4.21 <0.6.0;


contract ReleaseTransaction 
{
    enum Status{successful,failed,waiting}
    enum ChainStatus{successful,failed,chained,none}

    uint256 periodicTime = 7600;    // 2 hours 
    uint256 nextIterate = now + periodicTime;
    uint256 public listNumber = 0;
    uint256 runningTime;

    struct TransactionList
    {
        address Source;
        address Destination;
        uint256 Value;
        Status status;
        address ChainedDestination;
        uint256 ChainedValue;
        ChainStatus Chainedstatus;
    }
    
    struct ReleaseTransStruct
    {
        uint256 Period;
        uint256 Index;
    }

    ReleaseTransStruct[] public ReleaseTransactions;
    
    struct ValidationDetail
    {
        uint256 Period ;
        uint256 Index ;
    }



    mapping (uint256 => TransactionList[]) public currentReleaseTransactionList;
    mapping (address => ValidationDetail[]) private ValidationDetails;
    

/**
     * @dev records all the release trasaction requests in the list (array) of structs with releated information
     * @param source : address of the entity which wants to send
     * @param destination : reciever address
     * @param amount :  amount that sender wants to send to reciever
     * @return true is transaction detail is recorded successfully
     */
    function setReleaseTransaction(address source, address destination, uint256 amount ,Status status ) internal returns (uint256 , uint256) // return count and transaction index 
    {
        uint256 listnumber = getCurrentPeriod();
        TransactionList memory currentList;
        currentList.Source = source;
        currentList.Destination = destination;
        currentList.Value = amount;
        currentList.status = status; 
        currentList.ChainedDestination = destination;
        currentList.ChainedValue = 0;
        currentList.Chainedstatus = ChainStatus(3);        
        uint256 ind = currentReleaseTransactionList[listnumber].push(currentList) - 1;
        ValidationDetail memory currentValidationDetail;
        currentValidationDetail.Period = listnumber;
        currentValidationDetail.Index = ind;
        ValidationDetails[msg.sender].push(currentValidationDetail);
        return (listnumber, ind);
    }


/**
    *@dev checks that supplied address is contract or not 
    */
    function isContract(address addr) public view returns (bool) 
    {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

/**
    *@dev returns the current working Period number of Release Transaction List
    */
       function getCurrentPeriod() public returns (uint256)
    {
        runningTime = now;
        if (runningTime >= nextIterate)
        {
            nextIterate = now + periodicTime ;
            ++listNumber;
            return listNumber;
        }
        else
        {
            return listNumber; 
        }       
    }


/**
     *@dev Returns all the valid and non expired release transaction left for validation for an entity
     *if index if zero  menas list checking from starting and if supply index then 
     */
    function getReleaseTransaction(uint256 listnumber ,uint256 index) public view returns (address,uint256,Status,address,uint256,ChainStatus)
    {
        return(currentReleaseTransactionList[listnumber][index].Destination
        ,currentReleaseTransactionList[listnumber][index].Value,
        currentReleaseTransactionList[listnumber][index].status,
        currentReleaseTransactionList[listnumber][index].ChainedDestination
        ,currentReleaseTransactionList[listnumber][index].ChainedValue,
        currentReleaseTransactionList[listnumber][index].Chainedstatus
        );
    }
    

   /**
     * @dev returns all the transaction one by one which needs to be validated by calling entity
     * it returns the period number and index of the transaction , which can be used in getReleaseTransaction
     * function to get all the infoormation regarding the transaction
     */
    function getAllPendingRequests(uint256 startingIndex) public view returns(uint256[] memory  , uint256 , bool)
    {       
        uint256 len = ValidationDetails[msg.sender].length;
        for(uint256 i = startingIndex ; i < len ; i++)
        {
        uint256 ReleaseListNumber = ValidationDetails[msg.sender][i].Period;
        uint256 IndexOfTransaction = ValidationDetails[msg.sender][i].Index;
        if( currentReleaseTransactionList[ReleaseListNumber][IndexOfTransaction].status == Status(2) || 
        currentReleaseTransactionList[ReleaseListNumber][IndexOfTransaction].Chainedstatus == ChainStatus(2))
        {
            uint256[] memory listAndIndex  = new uint256[](2);
            listAndIndex[0] = ValidationDetails[msg.sender][i].Period;
            listAndIndex[1] = ValidationDetails[msg.sender][i].Index;

            if(len -1 > i)
            {
                return (listAndIndex , i+1 ,true);
            }
            else
            {
                return (listAndIndex , 0 ,false);
            }
        }
        }
      }


/**
     * @dev finds the least amount that is common in the whole chained transaction
     */
      function getLeastAmount (address sender,uint256 currentListNumber,address tempReciever,uint256 tempAmount) internal view returns(bool ,uint256)
    {
    uint256 i;
    uint256 listnumber=1;
    bool flag = false;
    while(listnumber <= currentListNumber)
        {
         uint256 len = currentReleaseTransactionList[listnumber].length;
        for ( i= 0 ; i < len ; i++ )
        {
            if(currentReleaseTransactionList[listnumber][i].Source == tempReciever && 
                currentReleaseTransactionList[listnumber][i].status == Status(2))
            {
                flag = true;
                tempReciever = currentReleaseTransactionList[listnumber][i].Destination;
                if(currentReleaseTransactionList[listnumber][i].Value < tempAmount) 
                {
                    tempAmount = currentReleaseTransactionList[listnumber][i].Value;
                      
                }
                break;
            }
        }
        if( i == len && sender != tempReciever )
        {
            listnumber++;
        }
        else if (sender == tempReciever)
        {
            break;
        }
        else
        {
            listnumber = 0;
        }
        }
        return (flag , tempAmount);
        
}


/**
    *@dev sets the new periodic time
    */    
    function _changePeriodicTime(uint256 newTime) internal returns(bool)
    {
        periodicTime = newTime;
        return true ;
    }

}

// File: contracts/SpendingAllowanceToken.sol

pragma solidity >=0.4.21 <0.6.0;





/** 
 * @title SpendingAllowanceToken => SAT
 * @author Sagar Chaurasia
 * @dev  Generate tokens and allocates to an enitity
 * Tranfer SAT tokens from one enitity to other entity within system 
 * Release Transaction
 * Has variables which records the total number of tokens generated,running ,etc
 */
contract SpendingAllowanceToken is ReleaseTransaction 
{
    using BokkyPooBahsDateTimeLibrary for uint256 ;


/**
 * ixxoPercent : Defines the amount of SAT recieved as commission on every transaction
 * minterAddress : Only address that can mint the tokens 
 * ixxoCommissionAddress : ixxo account address , which recieves the commission
 * owner : owner of the contract
 * totalCommissioned : total commission recieved by ixxo till date
 * currentTime : time at which contract is deployed
 * currentMonth : current running month
 * deployedMonth : month in which , contract was deployed
*/
    uint256 internal ixxoPercent; 
    address internal minterAddress;
    address internal ixxoCommissionAddress;
    address owner = msg.sender;
    uint256 internal totalCommissioned;
    uint256 internal currentTime;
    uint256 internal currentMonth = findMonth(currentTime);
    uint256 internal deployedMonth = currentMonth;


/**
 * @dev Define ixxo SpendingAllowanceToken
 */
    string public name = "SpendingAllowanceToken";
    string public symbol = "SAT";
    uint8 public decimal = 18;

/**
 * @dev initialize the initial value to the variable
 */
    constructor () public 
    {
        minterAddress = msg.sender; // Minting Bank address 
        ixxoCommissionAddress = msg.sender;
        totalCommissioned = 0;
        ixxoPercent = 3;
        currentTime = now;
        _startTokenAllocation(ixxoCommissionAddress,0,"",0);
    }


/**
 * @dev Defining modifiers to restrict access
 * But, PeriodCheck is the timeBased modifier , that calls another function when a function with this modifiers 
 * is called if certain time based condition is met
 */
    modifier onlyMinter ()
        {
            require(minterAddress == msg.sender , "authentication failed");
            _;
        }

    modifier onlyOwner()
        {
            require(owner == msg.sender,"authentication failed");
            _;
        }

    modifier PeriodCheck()
        {
            if(now >= nextIterate)
            {
                ChainAllTransactions();
            }
            _;
        }
/**
 * @dev structure to record each transaction's SAT flow with Initiator 
 * of the token intact
 */
    struct TransactionDetails 
    {
        address currentOwner;
        address initiator;
        uint256  amount;
    }

/**
 * mapping to record the transaction details and track the balance of each entities account
 * mapping to check that selfMode for given address is done or not
 */
    mapping (address => TransactionDetails[]) internal balancesOF;
    mapping (address => bool) internal SelfModeHasBeenDone;

/**
 * events thats are to be marked on blockchain
 */
    event tokenMinting (address indexed minterAdddres,address indexed currentOwner,uint256 Amount,string proofOfCashTransfer,bool selfMode);
    event tokenTransfer (address indexed sender,address indexed initiator,address indexed reciever,uint256 Amount);
    event ixxoCommissioned (address indexed sender,uint256 Amount);


/**
     *@dev to allocate the tokens to the benficiary 
     * here , we take in consideration that 0 index of array of struct mapped to each enity should be of self mode type
     * token allocation in this function are of Self mode only
     * @param beneficiary : address of the enity who is recieving tokens
     * @param numTokens : number of tokens to be allocated
     * @param CashRecieveProof : Proof of cash transfer in string format
     * @return ture if token allocation is successfull or else returns false  
     */
    function startTokenAllocation(address beneficiary,uint256 numTokens,string memory CashRecieveProof) public onlyMinter PeriodCheck returns (bool) 
    {
        require(beneficiary != owner,"owner of contract cannot buy SAT");
        uint256 lenOfStructArray = balancesOF[beneficiary].length;
        return _startTokenAllocation(beneficiary,numTokens,CashRecieveProof,lenOfStructArray);
    }


/**
     *@dev supporting function to facilitates the token minting and allocation
     */
    function _startTokenAllocation(address beneficiary,uint256 numTokens,string memory CashRecieveProof,uint256 lenOfStructArray) internal returns (bool) 
   {
       TransactionDetails memory transactionEntry;
        if(lenOfStructArray==0)
        {
            transactionEntry.currentOwner = beneficiary;
            transactionEntry.initiator = beneficiary;
            transactionEntry.amount = numTokens;
            balancesOF[beneficiary].push(transactionEntry);
            SelfModeHasBeenDone[beneficiary] = true;
        }
         else
        {
            uint256 currentBal = balancesOF[beneficiary][0].amount;
            balancesOF[beneficiary][0].amount = currentBal+(numTokens);           
        }
         emit tokenMinting(minterAddress,beneficiary,numTokens,CashRecieveProof,true);
        return true;
   }


/**
     * @dev Transfer the token from one entity to other
     * @param sender : entity sending the tokens
     * @param reciever : address of recieving enity
     * @param numOfTOkens : number of tokens to send 
     * @return : returns true is transaction is recorded successfully
     */
    function transferTokens(address sender ,address reciever,uint256 numOfTOkens) PeriodCheck public returns(uint256, uint256)
    {
        uint256 listNumber;
        uint256 Index;
        if(isContract(sender)==true && havePayableAmount(sender,numOfTOkens) == true)
        {    
            _transferTokens(reciever , numOfTOkens);
            (listNumber,Index) = setReleaseTransaction(sender,reciever,numOfTOkens,Status(0));
        }
        (listNumber,Index) = setReleaseTransaction(sender,reciever,numOfTOkens, Status(2));
        return (listNumber,Index);
    }


    /**
     * @dev returns true is any single entry in the senders account has sufficient ammount to drive the transaction
     * or else function returns false 
     */
    function havePayableAmount(address sender,uint256 tokens) internal view returns(bool)
    {
        uint256 len = balancesOF[sender].length;
        for(uint256 i = 0 ; i < len ; i++)
        {
            if(tokens >= balancesOF[sender][i].amount)
            {
                return true;
            }
        } 
        return false;
    }


/** 
     * @dev make the chain of transaction and
     * Decrease the validation process and automates the transaction
    */
    function ChainAllTransactions() internal returns(bool)
{
    delete ReleaseTransactions;
    uint256 currentListNumber = getCurrentPeriod();
    uint256 workingListNumber = 0;

    while(workingListNumber <= currentListNumber)
    {
        uint256 len = currentReleaseTransactionList[workingListNumber].length;
        for(uint256 ind = 0 ; ind < len ; ind++)
        {
            if(currentReleaseTransactionList[workingListNumber][ind].status == Status(2))
            {
                ReleaseTransStruct memory current;
                current.Period = workingListNumber;
                current.Index = ind;
                ReleaseTransactions.push(current);
                address sender = currentReleaseTransactionList[workingListNumber][ind].Source;
                address reciever = currentReleaseTransactionList[workingListNumber][ind].Destination;
                uint256 amount = currentReleaseTransactionList[workingListNumber][ind].Value;
                anyPrecedingTransactions(sender,reciever,amount,workingListNumber,ind,currentListNumber);   
            }
        }  
        ++workingListNumber;  
    }
}   


    /**
     * @dev function facilitating chaining of transactions
     */
    function anyPrecedingTransactions(address sender,address reciever,uint256 amount,uint256 number,uint256 ind,uint256 currentListNumber ) internal returns(bool)
    {        
        address tempReciever = reciever; 
        uint256 listnumber =0;
        uint256 i;
        uint256 len;

        (bool flag ,uint256 tempAmount)= getLeastAmount(sender,currentListNumber,reciever ,amount);
        if(flag == true)
        { 
        while(listnumber <= currentListNumber)
        {
            len = currentReleaseTransactionList[listnumber].length;
        for ( i= 0 ; i < len ; i++ )
        {
            if(currentReleaseTransactionList[listnumber][i].Source == tempReciever && 
                currentReleaseTransactionList[listnumber][i].status == Status(2))
            {

                tempReciever = currentReleaseTransactionList[listnumber][i].Destination;
                currentReleaseTransactionList[listnumber][i].Value = currentReleaseTransactionList[listnumber][i].Value - tempAmount;
                if(currentReleaseTransactionList[listnumber][i].Value <=0)
                {
                    currentReleaseTransactionList[listnumber][i].status = Status(0);
                }      
                break;
            }
        }
        if( i == len && sender != tempReciever )
        {
            listnumber++;
        }
        else if (sender == tempReciever)
        {
            break;
        }
        else
        {
            listnumber = 0;
        }
        }
        amount = amount - tempAmount;
        currentReleaseTransactionList[number][ind].Value = amount;
        if(amount == 0)
        {
            currentReleaseTransactionList[number][ind].status = Status(0);    
        }
        currentReleaseTransactionList[number][ind].Chainedstatus = ChainStatus(2);
        currentReleaseTransactionList[number][ind].ChainedDestination = tempReciever;
        currentReleaseTransactionList[number][ind].ChainedValue = tempAmount;             
        }
        }



    /** 
     * @dev function to validate and facilitate the transaction
     * @param listnumber : period of the validating entry 
     * @param index : index of the valdating entry
     */
    function validateTransaction(uint256 listnumber , uint256 index) PeriodCheck public returns(bool)
    {   
        bool res;
        address reciever;
        uint256 amount;
        require(currentReleaseTransactionList[listnumber][index].Source == msg.sender,"only tranaction owner can validate the transaction");
        if(currentReleaseTransactionList[listnumber][index].status == Status(2))
        {
            reciever = currentReleaseTransactionList[listnumber][index].Destination;
            amount = currentReleaseTransactionList[listnumber][index].Value; 
            res = _transferTokens(reciever,amount);
            if(res == true)
            {
            currentReleaseTransactionList[listnumber][index].status = Status(0);  
            }
            else 
            {
                currentReleaseTransactionList[listnumber][index].status = Status(1);
            }
        }
        if(currentReleaseTransactionList[listnumber][index].Chainedstatus == ChainStatus(2))
        {
            reciever = currentReleaseTransactionList[listnumber][index].ChainedDestination;
            amount = currentReleaseTransactionList[listnumber][index].ChainedValue;  
            res = _transferTokens(reciever,amount);
            if(res == true)
            {
                currentReleaseTransactionList[listnumber][index].Chainedstatus = ChainStatus(0) ;
            }
            else
            {
                currentReleaseTransactionList[listnumber][index].Chainedstatus = ChainStatus(1);
            }
        }
        return true;
    } 


/**
     * @dev faciliattes the transferring of tokens from one entity to other and ctransfer ixxo commission
     * @param reciever : entity recieving the tokens
     * @param tokens : number of SAT tokens send by sender 
     * @return bool : true if payment is sucessfull
     */
        function _transferTokens(address reciever,uint256 tokens) internal returns (bool)
        {
            address sender = msg.sender;
            uint256 lenStructArray = balancesOF[sender].length;
            uint256 min = 1;
            bool flag = false;
            if(SelfModeHasBeenDone[sender] == true && balancesOF[sender][0].amount >= tokens)  
                {
                    balancesOF[sender][0].amount = (balancesOF[sender][0].amount)-(tokens); 

                    return (transition(sender,reciever,tokens )); 
                }
            else
            {
                for(uint i = 1 ; i< lenStructArray ; i++)
                {
                    if(balancesOF[sender][i].amount >= tokens && balancesOF[sender][min].amount >= balancesOF[sender][i].amount)
                    {
                        min = i;
                        flag = true;
                    }
                }
                if(flag == true)
                {
                    balancesOF[sender][min].amount = (balancesOF[sender][min].amount)-(tokens); 
                        address initiator = balancesOF[sender][min].initiator;
                        return (transition(initiator,reciever,tokens));
                    
                }
                }
            return false;
            }

           
/**
     * @dev supporting function to facilitate the transferring Of Tokens 
     */
        function transition(address initiator,address reciever,uint256 nbTokens ) internal returns (bool)
        {
            uint256 tokens = transferIxxoComission(nbTokens,initiator);
            bool flag = false;
            TransactionDetails memory currentEntry;
            if(SelfModeHasBeenDone[reciever] == false)  
                {
                    currentEntry.currentOwner = reciever;
                    currentEntry.initiator = reciever;
                    currentEntry.amount = 0;
                    balancesOF[reciever].push(currentEntry);
                    SelfModeHasBeenDone[reciever] = true; 
                    currentEntry.currentOwner = reciever;
                    currentEntry.initiator = initiator;
                    currentEntry.amount = tokens;
                    balancesOF[reciever].push(currentEntry);
                }
                else
                {
                    uint256 len =  balancesOF[reciever].length;
                    for(uint256 i = 0 ; i<len ; i++)
                    {
                        if(initiator == balancesOF[reciever][i].initiator)
                        {
                            balancesOF[reciever][i].amount = (balancesOF[reciever][i].amount)+(tokens);
                            flag = true;
                        }
                    }
                }
                if(flag == false)
                {
                    currentEntry.currentOwner = reciever;
                    currentEntry.initiator = initiator;
                    currentEntry.amount = tokens;
                    balancesOF[reciever].push(currentEntry);
                }
                return true;
        }
        

/**
    *@dev calculates and transfer the ixxo commission 
    */
    function transferIxxoComission(uint256 tokens,address _initiator) internal returns(uint256)
        {
            uint256 tokensToSend;
            uint256 commission = (tokens*ixxoPercent)/100;
            tokensToSend = tokens-commission;
            totalCommissioned = totalCommissioned + commission;
            
                uint256 len = balancesOF[ixxoCommissionAddress].length;
                bool flag = false;
                for(uint256 i = 1 ;i < len ; i++)
                {
                    if(balancesOF[ixxoCommissionAddress][i].initiator == _initiator)
                    {
                        balancesOF[ixxoCommissionAddress][i].amount = balancesOF[ixxoCommissionAddress][i].amount + commission;
                        flag = true ;
                        break;
                    }   
                }
                if(flag==false) 
                { 
                    TransactionDetails memory currentEntry;
                    currentEntry.currentOwner = ixxoCommissionAddress;
                    currentEntry.initiator = _initiator;
                    currentEntry.amount = tokens;
                    balancesOF[ixxoCommissionAddress].push(currentEntry);
                }
                emit ixxoCommissioned(msg.sender,commission);
                return tokensToSend;
        }

      
/**
     * @dev finds total number of SAT tokens comissioned to ixxo till now 
     * @return the number of SAT
     */
    function TokensCommissionedToIxxo() public view onlyOwner returns (uint256)
    {
        return totalCommissioned ;
    }


/**
    * @dev calculates total number of tokens held by specific user at current time 
    * @return the calculated total amount of tokens 
    */
    function totalTokensHeld() public view returns (uint256) 
    {
        uint256 len = balancesOF[msg.sender].length;
        uint256 _amountOfTokens = 0;
        for(uint256 i = 0 ; i < len ; i++)
        {
            _amountOfTokens = _amountOfTokens+(balancesOF[msg.sender][i].amount);
        } 
        return _amountOfTokens ;
    }


/**
     * @dev sets the new ixxo comission percent 
     * can only be called by contract owner 
     * @param _rate : new rate of commission
     * @return true if changing rate is done successfully
     */
    function SetRate(uint256 _rate) public onlyOwner returns (bool)
    {
        uint256 runningMonth = findMonth(now);
        if(currentMonth != runningMonth  || currentMonth == deployedMonth)
        {
            uint256 diff = ixxoPercent-(_rate);
            if(diff <= 10 )
           {
                currentMonth = runningMonth;
                ixxoPercent = _rate;
                return true;
           }
        }  
        else 
        {
            return false;
        }
    }
    
    
/**
     * @dev check what is the current rate of ixxo_percent
     * Cann only be called by owner of the contract
     * @return current percentage in uint
     */
    function checkCurrentRate() public view onlyOwner returns(uint256)
    {
        return ixxoPercent ;
    }


/**
     * @dev how many Self mode tokens requesting entity has 
     * @return number of self mode tokens in uint
     */
    function checkSelfModeAmount() public view returns(uint256)
    {
        uint256 SelfModeTokens = balancesOF[msg.sender][0].amount;
        return SelfModeTokens;
    }


/**
     * @dev finds the current month using the timestamp
     * @return the number of the month
     */
    function findMonth(uint256 timeStamp) internal pure returns (uint256)
    {        
         uint256 month = (BokkyPooBahsDateTimeLibrary.getMonth(timeStamp));
         return month; 
    }


/**
     * @dev set new perioidc time
     */
    function changePeriodicTime(uint256 newTime) public onlyOwner returns (bool)
    {
        return _changePeriodicTime(newTime);
    }

}
