pragma solidity >=0.4.21 <0.6.0;


contract ReleaseTransaction 
{
    enum Status{successful,failed,waiting}
    enum ChainStatus{successful,failed,chained,none}

    uint256 periodicTime = 7600;    // 2 hours 
    uint256 nextIterate = now + periodicTime;
    uint256 public listNumber = 1;
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
    function isContract(address addr) internal view returns (bool) 
    {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

/**
    *@dev returns the current working Period number of Release Transaction List
    */
       function getCurrentPeriod() internal returns (uint256)
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



