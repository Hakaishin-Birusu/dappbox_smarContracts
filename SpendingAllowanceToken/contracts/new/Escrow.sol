pragma solidity >=0.4.24<0.6.0;

contract SpendingAllowanceToken
{
    function escrowPayments(address reciever,address initiator,uint256 amount) public returns (bool){}   
}

contract Escrow 
{   
    SpendingAllowanceToken sat;
    uint256 thresholdAmount;
    address owner;
    uint256 orderId;
    address escrowAddress;
    uint256 once=0;

    modifier onlyOwner()
    {
        require(msg.sender ==owner,"Authentication failed");
        _;
    }
    
    modifier onlyOnce()
    {
        once++;
        require(once <= 1,"contract address cannot be changed once set");
        _;
    }

    enum PaymentStatus{Pending, Completed}

    event PaymentCreation(uint256 orderId,address indexed reciever, address indexed initiator, uint256 value);
    event PaymentCompletion(uint256 orderId,address indexed reciever,address indexed initiator,uint256 value, PaymentStatus status);

    struct Payment {
        address reciever;
        address initiator;
        uint256 value;
        PaymentStatus status;
    }

    mapping(uint256 => Payment) public payments;
    uint256[]  public currentTransactionList;


    constructor() public
    {
        thresholdAmount = 100; 
        owner = msg.sender;
        orderId = 0;   
    } 


    /**
    * @dev function to set new threshold amount
    * @param newThreshold : new amount to be used as threshold limit
    */
    function changeThreshold(uint256 newThreshold) internal returns(bool)
    {
        thresholdAmount = newThreshold;
        return true;
    }

    function setSatReference(address _t) public onlyOwner onlyOnce
    {
        sat = SpendingAllowanceToken(_t);
    }

    
    /**
    * @dev function to store the payments
    * @param initiator : is the inititor of the specfic tokens which are been transferred
    * @param reciever : entity recieving the funds
    * @param value : Amount of funds sending
    */
    function createPayment(address reciever,address initiator,uint256 value) public returns(bool)
    {
        payments[orderId] = Payment(reciever,initiator,value,PaymentStatus.Pending);
        emit PaymentCreation(orderId,reciever,initiator,value);
        currentTransactionList.push(orderId);
        orderId++;
        thresholdReached();
        return true;
    }
    

    /**
    * @dev function to check , is threshold is reached or not and if thershold is reahced payments are released
    */
    function thresholdReached() internal 
    {
        if(thresholdAmount <= currentListAmount())
        {
            releasePayments();
        }
    }


    /**
    * @dev function that return the total amount of sat in the currentList     
    */
    function currentListAmount() public view returns(uint256)
    {
        uint256 len = currentTransactionList.length;
        uint256 totalAmount=0; 
        for(uint256 i = 0 ; i < len ; i++)
        {
            uint256 order = currentTransactionList[i];
            if(payments[order].status == PaymentStatus(0))    // refund payments are not considered while checking for the threshold
            {
                totalAmount = totalAmount + payments[order].value;
            }
        }
        return totalAmount;
    }


    /**
    * @dev function that release the payment to the real reciever 
    */
    function releasePayments() internal
    {
        uint256 len = currentTransactionList.length;
        address reciever;
        uint256 amount;
        address initiator;
        for(uint256 i =0 ;i < len ; i++)
        {
            uint256 order = currentTransactionList[i];
            if(payments[order].status == PaymentStatus(0))
            {
                reciever = payments[order].reciever;
                amount = payments[order].value;
                initiator = payments[order].initiator;
                payments[order].status = PaymentStatus(1);
                sat.escrowPayments(reciever,initiator,amount);
                emit PaymentCompletion(order,reciever,initiator,amount,PaymentStatus(1));
            }  
        }
        delete currentTransactionList;
    }



}