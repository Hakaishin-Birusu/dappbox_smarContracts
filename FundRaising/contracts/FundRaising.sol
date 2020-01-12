
pragma solidity >=0.5.0;

import "./SafeMath.sol";

contract SpendingAllowanceToken
{
    function IxxoInstantPaymentSystem(address sender,address receiver, uint256 amount) public returns(bool){}
    function havePayableAmount(address sender,uint256 tokens) public returns(bool){}
}

contract FundRaising 
{
    using SafeMath for uint256;
    SpendingAllowanceToken sat;
    uint256 public StartDate ;
    uint256 public EndDate ;
    address private paymentAddress;
    address private owner;
    uint256[] bidList;
    bool SharesAllocationDone = false;
    bool public cancellingBids;
    bool inited ;
    bool satPayement;

       constructor () public 
    {
        paymentAddress = msg.sender;
        owner = msg.sender;
        inited = false;
        satPayement = false;
    }

    function setInitialValues(uint256 initialPrice,uint256 delta,uint256 companySharesPerBucket,uint256 maxSharesNumber,uint256 startDate,uint256 _EndDate)
    public onlyOwner onlyOnce{
    sharePriceStructure.initialPrice = initialPrice;
        sharePriceStructure.delta = delta;
        shareStructure.ComapnySharePerBucket = companySharesPerBucket;
        shareStructure.MaxBucketNumber = maxSharesNumber;
        StartDate = startDate;
        EndDate = _EndDate;
        AmountRaised = 0;
        nbSharesBidded = 0;
        SharesAllocated = 0;
        cancellingBids = false;
        
        inited = true;
    }
    function setSPendingAllowanceTOkenAddress(address _t) public onlyOwner onlyOnce {
        sat = SpendingAllowanceToken(_t);
    }

    function enableSatPayement() public onlyOwner  {
        satPayement = true;
    }

    function disableSatPayment() public onlyOwner {
        satPayement = false;
    }


    modifier onlyOwner()
    {
        require(msg.sender == owner,"Authentication Failed");
        _;
    }

    modifier onlyOnce()
    {
        require(inited == false,"Initialization already done");
        _;
    }

    struct SharePriceStructure
    {
        uint256 initialPrice ;
        uint256 delta;
    }
    SharePriceStructure public sharePriceStructure ;

     
    struct ShareStructure
    {
        uint256 ComapnySharePerBucket;
        uint256 MaxBucketNumber; 
    }
    ShareStructure public shareStructure ;


    struct ShareBid
    {
        address bidder;
        uint nbShares;
        uint256 MaxPrice;  
        uint256 timeOfBid;
        bool handled;
    }  
    ShareBid[] public bids;
    

    struct ShareOwner
    {
        address owner;
        uint256 numberOfShares;
    }
    ShareOwner[] public SOwner;

        
    uint256 public AmountRaised;
    uint256 private nbSharesBidded;
    uint256 public SharesAllocated;


    struct SellOrder 
    {
        address payable Seller; 
        uint256 SellingShares;
        uint256 AskingPrice;
    }
    SellOrder[] public SOrder;
    

    /**
     * @dev function for placing the bid ( for buying shares) or selling of shares(after end date only)
     * @param _nbShares ,number of shares to be bought or sell
     * @param _tradeDirection ,If currentTime < EndDate , tradeDirection 0 = Buy & 1 = Buy
     * && if currentTime > EndDate , tradeDirection 0=Buy (if stocks available ) && 1 = sell
     * @param _MaxPrice , maximum amount amount willing to pay if buying or minimum amount asking ,if selling
     * @return bool , true if transaction is completes successfully else false 
     */
    function PlaceOrder( uint256 _nbShares, uint256 _tradeDirection, uint256 _MaxPrice) public returns (bool , uint256)
    {       
        address payable beneficiary = msg.sender;
          
        uint256 Time = now;
        bool res;
        
        if(Time <= EndDate)
        {
            uint256 CurrentPrice = getSharePrice();
            if(_tradeDirection==0 || _tradeDirection==1 )

            {
                if(CurrentPrice <= _MaxPrice)
                {
                    res = PlaceBuyOrder (beneficiary,_nbShares,_MaxPrice,Time);
                    return (res , _nbShares) ;
                }
                else{return (false , 0);}
            } 

    }
   
     else if(Time > EndDate)
        { 
            if(_tradeDirection == 0) //buying Shares from seller
            {   
                bool flag;
                uint256 amount;
                uint256 sharesToAllocate;
                require(SOrder.length > 0,"seller list is empty");
                for(uint256 i = 0 ; i < SOrder.length; i++)
                {
                    if(SOrder[i].AskingPrice <= _MaxPrice && SOrder[i].SellingShares > 0)
                    {
                        if(SOrder[i].SellingShares >= _nbShares)
                        {   
                            sharesToAllocate = _nbShares;
                            amount = (SOrder[i].AskingPrice).mul(_nbShares);
                            flag = payment(msg.sender,SOrder[i].Seller,amount);
                            require(flag == true,"payment failed");
                            SOrder[i].SellingShares = (SOrder[i].SellingShares).sub(_nbShares);
                            _nbShares = 0;
                            allocateShares(msg.sender,sharesToAllocate);
                            
                            
                        }
                        else if (SOrder[i].SellingShares < _nbShares)
                        {
                            sharesToAllocate = SOrder[i].SellingShares;
                            amount = (SOrder[i].AskingPrice).mul(SOrder[i].SellingShares);
                            flag = payment(msg.sender,SOrder[i].Seller,amount);
                            require(flag == true,"payment failed");
                            _nbShares = _nbShares.sub(SOrder[i].SellingShares);
                            SOrder[i].SellingShares = 0; 
                            allocateShares(msg.sender,sharesToAllocate);
                            
                        }
                    }
                    if(_nbShares == 0)
                    {
                        break;
                    }
                }
          }
               
            if (_tradeDirection==1)  // placing sell order by share owners only
            {   
                uint256 i;
                uint256 OwnerShares = 0;
                
                for( i = 0 ; i < SOwner.length ; i++)
                {
                    if (SOwner[i].owner == msg.sender)
                    {
                        OwnerShares = SOwner[i].numberOfShares;
                        break;
                    }
                }

            if(OwnerShares >= _nbShares)
            { 
                SOwner[i].numberOfShares = OwnerShares.sub(_nbShares);
                res = PlaceSellOrder(beneficiary,_nbShares,_MaxPrice);
                return (res , _nbShares);
            }
            
            return (false ,_nbShares) ;
    
            }
        }
    }


    /**
     * @dev facilitates the payments of SAT tokens 
     */
    function payment(address sender,address payable receiver,uint256 amount) public payable returns(bool)
    {
        bool res;
        if(satPayement = true) {
         res = sat.IxxoInstantPaymentSystem(sender,receiver,amount);
        }
        else {
            require(amount == msg.value, "not send appropriate amount");
            receiver.transfer(amount);
        }
        return res ;
    }

    function cancelBids(uint256 bidId) public returns(bool)
    {
        require(cancellingBids == true,"cancelling bids is disabled");
        require(now < EndDate ,"bid cannot be canceled now");
        require(bidderExist() == true,"Not a bidder");
        require(msg.sender ==bids[bidId].bidder);

        uint256 len = bids.length;
        uint256 ind = len-1;

        //reduce the amount if bid is canceled successfuly  , mandatory since it only decides the current price fluctuation
        AmountRaised = AmountRaised - bids[bidId].MaxPrice;
        // copy last bid content at the position of this bid , then delete last bid (since we dont need bid sequence to maintained , bis can be in any order)
         bids[bidId].bidder = bids[ind].bidder;
         bids[bidId].nbShares = bids[ind].nbShares;
         bids[bidId].MaxPrice = bids[ind].MaxPrice;  
         bids[bidId].timeOfBid = bids[ind].timeOfBid;
         bids[bidId].handled = bids[ind].handled;
        return true; // if bid is canceled sucessfully 

    }

    /**
    * @dev function returns all the bids of user one by one 

    */
    function returnMybids(uint256 index) public view returns(address,uint256,uint256,bool,uint256)
    {
        //check list with user msg.sender
       //address bidder = msg.sender;
        require(bidderExist() == true,"Not a bidder");
        for(uint256 i = index ; i < bids.length ; i++)
        {
            if(msg.sender == bids[i].bidder)
            {
                //uint nbShares = bids[i].nbShares;
                uint256 MaxPrice = bids[i].MaxPrice;  
                uint256 timeOfBid = bids[i].timeOfBid;
                uint256 newIndex = i+1;
                if(newIndex < bids.length)
                {
                    return(msg.sender,MaxPrice,timeOfBid,true,newIndex);
                    //break;
                }
                else
                {
                    return(msg.sender,MaxPrice,timeOfBid,false,0);
                    //break;
                }
            }
        }
    }

    /**
    * @dev returns true if msg.sender is a bidder or not
    */
    function bidderExist() view internal  returns(bool)
    {
        bool res = false;
        for(uint256 i = 0 ; i < bids.length ; i++)
        {
            if(msg.sender == bids[i].bidder) 
            {
                res = true;
                break;
            }
        }

        return res;

    }
    
    /**
     * @dev returns the index of seller ,with lowest asking price 
     */
    function getMinimumAskingPriceSeller() public view returns (uint256)
    {
        uint256 min;
        uint256 i ;
        uint256 j ;
        uint256 len = SOrder.length;
        require(len > 0 , "list empty");
        for ( j = 0 ; j < len ; j++ ) //finding first entry which has atleast one share available for selling
        {
            if(SOrder[j].SellingShares != 0)
            {
                min = j;
                break;
            }
        }

        for (i= min ; i < len ; i++) // starting loop with j, as before entry has no shares available for selling , so no need to add in loop for checking
        {
            if(SOrder[min].AskingPrice >= SOrder[i].AskingPrice && SOrder[i].SellingShares > 0)
            {
                min = i;
            }
        }
        return min;
    }


    /**
     * @dev function calculates and returns the current price of shares according to number of shares bidded till now 
     * Note :  finds how much delta is to be added to add to intial price, to find current price according to the percentage of number of shares bidded on
     */
    function getSharePrice() public view returns(uint256 )
    {
        uint256 TotalShares = shareStructure.ComapnySharePerBucket.mul(shareStructure.MaxBucketNumber);
        uint256 deltaTimes = (nbSharesBidded).div(TotalShares);
        uint256 CurrentPrice = (sharePriceStructure.initialPrice).add(deltaTimes.mul(sharePriceStructure.delta));
        return CurrentPrice ;            
    }


    /**
     * @dev returns the number of shares on which bididng is done 
     */
    function getTotalSharesAllocated( ) public view returns (uint256) // finds total number of shares allocated till now
    {  // global variable which gets upadated when actual buying transaction takes place
        return SharesAllocated;
    }


    /**
     * @dev retuns the number of Shares held by an address
        */
    function getShares() public view returns (uint256) // finds total number of shares held by an individual
    {
        uint256 SharesHeld =0 ;
                // storing The adderss of the entity who made the request
            address person = msg.sender;
                // loop for running through out the list , to find out total shares held 
            for(uint256 i = 0 ; i <= SOwner.length-1 ; ++i)
            {
                // if address matches in list means , requesting person is owner of the perticular share          
                if (SOwner[i].owner == person)
                {
                    uint256 Shares = SOwner[i].numberOfShares;
                // variable storing total number of shares
                    SharesHeld = SharesHeld + Shares ;    
            }
                
        }
        return SharesHeld;
    }


    /**
     * @dev returns the total monry raised by the auction , via selling shares
     */
    function getRaisedMoneyAmount() public view onlyOwner returns (uint256)
    {  
        return AmountRaised;
    }

    
    /**
     * @dev checks if the span of auction is over and than triggers the actual allocation of shares 
     * Note : can be called by owner of the contract only 
     * @return bool : returns true/false if Raising EndPoint reached & assign shares to winning bidders
     */
    function IsRaisingMoneySuccessful() public  onlyOwner  returns (bool) 
    {    
        if(now > EndDate && SharesAllocationDone == false)
        {
            SharesAllocationDone = true;
            bool res = buy();
            return res;
        }
    }


   /**
    * @dev return total number of shares on which bidding is done
    * @return , total number of shares on which bidding is done 
    */
    function getNbSharesBidded() public view returns (uint256)   
    {  
        return nbSharesBidded; 
    } 


    /**
     * @dev add number of shars shares in total number of shares on which bidding is done
     * @return bool , true if transaction completes successfully 
     */
    function setNbSharesBidded(uint256 _nbShares) internal returns (bool)
    { 
        nbSharesBidded = nbSharesBidded.add(_nbShares);
        return true;
    }


    /**
     * @dev function that maintain the list of share owners willing to sell shares with related information
     * @param beneficiary , entity willing to sell the shares 
     * @param _nbShares , amount of shares entity is willing to sell
     * @param _AskingPrice , price entity willing to sell a single share for
     * @return bool , if transaction comletes successfully , else false  
     */
    function PlaceSellOrder(address payable beneficiary, uint256 _nbShares, uint256 _AskingPrice) internal returns(bool)
    { 
        SellOrder memory SOrders = SellOrder(beneficiary, _nbShares, _AskingPrice);
        SOrder.push(SOrders);
        return true ; 
    }


    /**
     * @dev function that maintain the list of enities willing to buy shares with related information 
     * @param beneficiary , entity willing to buy the shares 
     * @param _nbShares , amount of shares entity is willing to buy 
     * @param _MaxPrice , maximum price entity willing to pay for single share
     * @param _time , timestamp at which the bid was made 
     * @return bool , if transaction comletes successfully , else false 
     */
    function PlaceBuyOrder(address beneficiary,uint256 _nbShares,uint256 _MaxPrice, uint256 _time ) internal returns (bool)
    { 
        if(beneficiary == owner)
        {
            return false ;
        }
        else
        {
        ShareBid memory bid = ShareBid(beneficiary, _nbShares, _MaxPrice, _time,false);
        bids.push(bid);
        bool done = setNbSharesBidded(_nbShares);
        return done;
        }
    } 


    /**
     * @dev facilitates the buying of tokens from owner of tokens and carries out payment transaction
     */
    function buyFromSeller(address beneficiary , uint256 nbShares) internal  returns (bool)
    {
        uint256 len = SOwner.length;
        for (uint256 i = 0 ; i < len ; i++)
        {
            if(beneficiary == SOwner[i].owner)
            {
                SOwner[i].numberOfShares = (SOwner[i].numberOfShares).add(nbShares);
                break ;
            }
        }
        SOwner.push(ShareOwner(beneficiary, nbShares));
        return true;
    }


    /**
     * @dev facilitates the actual selling of shares by shares holders 
     * @param beneficiary ,the entity selling the shares 
     * @param _sharesToSell , amount of shares selling 
     * @param _AskingPrice , price asked by seller for single share
     * @return bool , if transaction completes successfully 
     */
    function sell(address payable beneficiary ,uint256 _sharesToSell,uint256 _AskingPrice)internal  returns (bool) 
    { 
        address payable seller = beneficiary ;
        uint256 ReceivingAmount = _AskingPrice.mul(_sharesToSell);
        bool res = payment(msg.sender,seller,ReceivingAmount );
        return res ;
    }    


    /**
     * @dev facililates the actual buying of shares on the basis of priorities 
     * @return bool , if transaction completes successfully 
     */
    function buy() public returns(bool) 
    {  
        uint256 i=0;
        bool res;
        uint256 TotalSharesForSale = shareStructure.ComapnySharePerBucket.mul(shareStructure.MaxBucketNumber);
        uint256 CurrentPrice = getSharePrice();
        
        for(uint256 z = 0 ; z < bids.length ; z++)
        {
            uint256 max;
            //uint256 i ;
            uint256 j ;
            uint256 len = bids.length;
        
        for (j = 0 ; j < len ; j++ ) //finding first entry which has atleast one share available for selling
        {
            if(bids[j].handled == false)
            {
                max = j;
                break;
            }
        }

        for (i=j ; i < len ; i++) // starting loop with j, as before entry has no shares available for selling , so no need to add in loop for checking
        {
            if(bids[max].MaxPrice <= bids[i].MaxPrice && bids[i].handled == false)
            {
                max = i;
            }
        }
        bids[max].handled=true;
        bidList.push(max);
        }
        uint256 sharetoAllocate;
        for(uint256 x =0 ; x < bidList.length; x++) 
        {
            uint256 index = bidList[x];
            if(bids[index].nbShares < TotalSharesForSale)
            {
                sharetoAllocate = bids[index].nbShares;
                TotalSharesForSale = TotalSharesForSale - bids[index].nbShares;
            }
            else
            {
                sharetoAllocate = TotalSharesForSale;   
                TotalSharesForSale = 0 ; 
        }
            address winningbidder = bids[index].bidder;
            uint256 Amount = CurrentPrice.mul(sharetoAllocate);
            //since require alts whole loop so , we are not using it here 
            //require(sat.havePayableAmount(winningbidder,Amount),"Insufficient funds");
            res = true;//sat.IxxoInstantPaymentSystem(winningbidder,paymentAddress,Amount);
                if(res == true)
                {   
                    allocateShares(winningbidder ,sharetoAllocate);
                   SharesAllocated= SharesAllocated.add(sharetoAllocate);
                   AmountRaised = AmountRaised.add(Amount);
                }

             if(TotalSharesForSale < 1)
             {
                 break;
             }
        }
       
        return true;
    }

     function allocateShares(address winningbidder ,uint256 sharetoAllocate) internal 
     {
         bool flag = false;
         for(uint256 j=0 ; j<SOwner.length ; j++)
            {
                if(SOwner[j].owner == winningbidder )
            {
                uint256 total = SOwner[j].numberOfShares.add(sharetoAllocate);
                SOwner[j].numberOfShares = total;
                flag = true;
                break;
            }
            }

            if (flag == false)
            {
                ShareOwner memory TOwners = ShareOwner(winningbidder, sharetoAllocate);
             SOwner.push(TOwners);
            }
     }
     
     function getCurrentRunningTime() public view returns(uint256)
     {
         return now;
     }

     function stopCancellingOfBids() public onlyOwner returns(bool)
     {
         require(cancellingBids == true,"already cancelling of bid is disallowed");
         cancellingBids = false;
         return true ;
     }


     function startCancellingOfBids() public onlyOwner returns(bool)
     {
         require(cancellingBids == false,"already bid cancelling allowed");
         cancellingBids = true;
         return true;
     }
     
}
