pragma solidity >=0.4.21 <0.6.0;

import "./BokkyPooBahsDateTimeLibrary.sol";
import "./ReleaseTransaction.sol";


contract Escrow{
    function createPayment(address reciever,address initiator,uint256 value) public returns(bool)
    {}
}

/** 
 * @title SpendingAllowanceToken => SAT
 * @author Sagar Chaurasia
 * @dev  Generate tokens and allocates to an enitity
 * Tranfer SAT tokens from one enitity to other entity within system 
 * pay for ixxo services
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
    address owner = msg.sender;
    uint256 internal totalCommissioned;
    uint256 internal currentTime;
    uint256 internal currentMonth = findMonth(currentTime);
    uint256 internal deployedMonth = currentMonth;
    uint256 internal marginPercent;
    address internal ixxoCommissionAddress;   
    address[] public belowMarginalList;
    bool micropayments = false;
    Escrow escrow;




/**
 * @dev Define ixxo SpendingAllowanceToken
 */
    string public name = "SpendingAllowanceToken";
    string public symbol = "SAT";
    uint8 public decimal = 18;

/**
 * @dev initialize the initial value to the variable
 */
    constructor(address _t) public 
    {
        minterAddress = msg.sender; // Minting Bank address 
        ixxoCommissionAddress = msg.sender;
        totalCommissioned = 0;
        ixxoPercent = 3;
        currentTime = now;
        _startTokenAllocation(ixxoCommissionAddress,0,"",0);
        marginPercent = 20; 
        escrow = Escrow(_t);
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
    mapping (address => uint256) internal marginalAccount;
    mapping (address => bool) internal lock;
/**
 * events thats are to be marked on blockchain
 */
    event tokenMinting (address indexed currentOwner,uint256 Amount,string proofOfCashTransfer,bool selfMode);
    event tokenTransfer (address indexed sender,address indexed initiator,address indexed reciever,uint256 Amount);
    event ixxoCommissioned (address indexed sender,uint256 Amount);
    event MarginMaintained(address indexed beneficiary,uint256 amount,bool lock);


/**
     *@dev to allocate the tokens to the benficiary 
     * here , we take in consideration that 0 index of array of struct mapped to each enity should be of self mode type
     * token allocation in this function are of Self mode only
     * @param beneficiary : address of the enity who is recieving tokens
     * @param numTokens : number of tokens to be allocated
     * @param CashRecieveProof : Proof of cash transfer in string format
     * @return ture if token allocation is successfull or else returns false  
     */
    function startTokenAllocation(address beneficiary,uint256 numTokens,string memory CashRecieveProof,uint256 newMarginalBalance) public onlyMinter PeriodCheck returns (bool) 
    {
        require(beneficiary != owner,"owner of contract cannot buy SAT");
        uint256 lenOfStructArray = balancesOF[beneficiary].length;
        uint256 newMargin = marginalAccount[beneficiary] + newMarginalBalance;
        marginalAccount[beneficiary] = newMargin; 
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
        lock[beneficiary] = false;
        emit tokenMinting(beneficiary,numTokens,CashRecieveProof,true);

        return true;
   }


    /**
    * @dev function to turn on micropayments
    */
    function OnMicropayment() public onlyOwner returns(bool)
    {
       micropayments = true;
       return true;
    }


    /**
    * @dev function to turn off micropayments
    */
    function OffMicropayment() public onlyOwner returns(bool)
    {
       micropayments = false;
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

        if(isContract(sender)==true || sender == ixxoCommissionAddress) 
        {
         if(havePayableAmount(sender,numOfTOkens) == true)
        {    
            _transferTokens(reciever , numOfTOkens);
            (listNumber,Index) = setReleaseTransaction(sender,reciever,numOfTOkens,Status(0));
        }
        else
        {
            (listNumber,Index) = setReleaseTransaction(sender,reciever,numOfTOkens,Status(2));
        }
        }
        else
        {
            checkMargin();
            if(lock[sender] == false)
            { 
                (listNumber,Index) = setReleaseTransaction(sender,reciever,numOfTOkens, Status(2));
            }
            else
            {
            return(0,0);
        }
        }
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
    function anyPrecedingTransactions(address sender,address reciever,uint256 amount,uint256 number,uint256 ind,uint256 currentListNumber) internal returns(bool)
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
    * @dev 
    */
    function _transferTokensToEscrow(address reciever,address initiator,uint256 value) internal returns(bool)
    {
        return escrow.createPayment(reciever,initiator,value);
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
            address initiator;
            uint256 min = 1;
            bool flag = false;
            if(SelfModeHasBeenDone[sender] == true && balancesOF[sender][0].amount >= tokens)  
                {
                    balancesOF[sender][0].amount = (balancesOF[sender][0].amount)-(tokens); 
                    if(micropayments == true)
                    {
                        initiator = sender;
                        return escrow.createPayment(reciever, initiator,tokens);
    
                    }
                    else
                    {
                    return (transition(sender,reciever,tokens)); 
                }
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
                    if(micropayments == true)
                    {
                        return escrow.createPayment(reciever, initiator,tokens);
                    }
                    else{
                    balancesOF[sender][min].amount = (balancesOF[sender][min].amount)-(tokens); 
                        initiator = balancesOF[sender][min].initiator;
                        return (transition(initiator,reciever,tokens));
                    }
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
                            break;
                        }
                    }
                     if(flag == false)
                {
                    currentEntry.currentOwner = reciever;
                    currentEntry.initiator = initiator;
                    currentEntry.amount = tokens;
                    balancesOF[reciever].push(currentEntry);
                }
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
        return totalCommissioned;
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

/**
    * @dev function to set the new margin percent 
    */
    function setNewMarginPercent(uint256 newMarginPercent) public onlyOwner returns (bool)
    {
        marginPercent = newMarginPercent;
    }

    /**
    * @dev function to check wether tokens are locked or not  and it also returns minimum amoun to maintain
    */
    function areTokensLocked() public view returns(bool,uint256)
    {
        address beneficiary = msg.sender;
        if(lock[beneficiary] == true)
        {
            uint256 currentAmount = marginalAccount[beneficiary];
            uint256 totalSatHeld = totalTokensHeld();
            uint256 amountTOmaintain = (totalSatHeld*marginPercent)/100;
            uint256 amountNeeded = amountTOmaintain - currentAmount;
            return (true,amountNeeded);
        }
        else
        {
            return (false,0);
        }
    }

    /**
    * @dev function to manage the margibal account
    * Note : It can be called by minting entity only
    */
    function maintainMarginalAccount(uint256 amountAddedInAccount , address beneficiary) public onlyMinter returns(bool)
    {
         marginalAccount[beneficiary] =  marginalAccount[beneficiary] + amountAddedInAccount;
         checkMargin();
         emit MarginMaintained(beneficiary,marginalAccount[beneficiary],lock[beneficiary]);
         return true;
    }


    /**
    * @dev function to check margin balance in beneficiary's account is maintained or not
    */
    function checkMargin() internal 
    {
        address beneficiary = msg.sender;
        uint256 currentAmount = marginalAccount[beneficiary];
        uint256 totalSatHeld = totalTokensHeld();
        uint256 amountTOmaintain = (totalSatHeld*marginPercent)/100;
        if(amountTOmaintain > currentAmount)
        {
            lock[beneficiary] = true;
            belowMarginalList.push(beneficiary);   
        }
        else 
        {
            uint256 len = belowMarginalList.length;
            for(uint256 i = 0 ; i < len ; i++)
            {
                if(belowMarginalList[i] == beneficiary)
                {
                    address temp = belowMarginalList[i];
                    belowMarginalList[i] = belowMarginalList[len-1]; 
                    belowMarginalList[len-1] = temp;
                    delete belowMarginalList[len-1];
                }
                
            }
            lock[beneficiary] = false;

        }
    }

    /**
    * @dev function to instantly transfer the token to ixxo , for ixxo services
    */
    function IxxoInstantPaymentSystem(address sender,address reciever,uint256 tokens) internal returns (bool)
        {
            uint256 lenStructArray = balancesOF[sender].length;
            uint256 min = 1;
            bool flag = false;
            if(SelfModeHasBeenDone[sender] == true && balancesOF[sender][0].amount >= tokens)  
                {
                    balancesOF[sender][0].amount = (balancesOF[sender][0].amount)-(tokens); 
                    return (transition(sender,reciever,tokens)); 
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
        * @dev function to facilitate escrow payment transaction
        */
        function escrowPayments(address reciever,address initiator,uint256 amount) internal returns(bool)
        {
            return transition(initiator,reciever,amount);   
        }
                   
}