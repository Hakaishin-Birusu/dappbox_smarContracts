pragma solidity ^0.4.17;


import './SafeMath.sol';
import './ROKToken.sol';
import './Pausable.sol';
import './PullPayment.sol';


/*
*  Crowdsale Smart Contract for the Rockchain project
*  Author: Sébastien Jehan sebastien.jehan@rockchain.org

*
*/

contract CCOCrowdsale is Pausable, PullPayment {
    using SafeMath for uint256;

    address public owner;
    CCOToken public cco;
    address public escrow;                                                             // Address of Escrow Provider Wallet
    address public bounty ;                                                            // Address dedicated for bounty services
    address public team;                                                               // Address for ROK token allocated to the team
    address public projectPhases;                                                      // Address for the LinkedListInvestmentPeriod contract


    uint256 public rateETH_ROK;                                                        // Rate Ether per ROK token
    uint256 public constant minimumPurchase = 0.1 ether;                               // Minimum purchase size of incoming ETH
    uint256 public constant maxFundingGoal = 100000 ether;                             // Maximum goal in Ether raised
    uint256 public constant minFundingGoal = 18000 ether;                              // Minimum funding goal in Ether raised
    uint256 public constant startDate = 1509534000;                                    // epoch timestamp representing the start date (1st november 2017 11:00 gmt)
    uint256 public constant deadline = 1512126000;                                     // epoch timestamp representing the end date (1st december 2017 11:00 gmt)
    uint256 public constant refundeadline = 1515927600;                                // epoch timestamp representing the end date of refund period (14th january 2018 11:00 gmt)
    uint256 public savedBalance = 0;                                                   // Total amount raised in ETH
    uint256 public savedBalanceToken = 0;                                              // Total ROK Token allocated
    bool public crowdsaleclosed = false;                                               // To finalize crowdsale
    
    mapping (address => uint256) balances;                                             // Balances in incoming Ether
    mapping (address => uint256) balancesCCOToken;                                     // Enforcing KYClist
    mapping (address => bool) KYClist;

    // Events to record new contributions
    event Contribution(address indexed _contributor, uint256 indexed _value, uint256 indexed _tokens);

    // Event to record each time Ether is paid out
    event PayEther(
        address indexed _receiver,
        uint256 indexed _value,
        uint256 indexed _timestamp
    );
   

    // Initialization
    function CCOCrowdsale(address _cco, address _escrow, address _projectPhases){
        owner = msg.sender;
        // add address of the specific contract
        cco = CCOToken(_cco);
        _projectPhases = ProjectPhases(_projectPhases);
        escrow = _escrow;
        // bounty;
        // team;
        rateETH_ROK = 1000;
    }


    // Default Function, delegates to contribute function (for ease of use)
    // WARNING: Not compatible with smart contract invocation, will exceed gas stipend!
    // Only use from external accounts
    function() payable whenNotPaused{
        if (msg.sender == escrow){
            balances[this] = msg.value;
        }
        else{
            contribute(msg.sender);
        }
    }

    // Contribute Function, accepts incoming payments and tracks balances for each contributors
    function contribute(address contributor) internal{
        require(isStarted());
        require(!isComplete());
        assert((savedBalance.add(msg.value)) <= maxFundingGoal);
        assert(msg.value >= minimumPurchase);
        balances[contributor] = balances[contributor].add(msg.value);
        savedBalance = savedBalance.add(msg.value);
        uint256 Roktoken = rateETH_ROK.mul(msg.value) + getBonus(rateETH_ROK.mul(msg.value));
        uint256 RokToSend = (Roktoken.mul(80)).div(100);
        balancesRokToken[contributor] = balancesRokToken[contributor].add(RokToSend);
        savedBalanceToken = savedBalanceToken.add(Roktoken);
        escrow.transfer(msg.value);
        PayEther(escrow, msg.value, now);
    }


    // Function to check if crowdsale has started yet
    function isStarted() constant returns (bool) {
        return now >= startDate;
    }

    // Function to check if crowdsale is complete (
    function isComplete() constant returns (bool) {
        return (savedBalance >= maxFundingGoal) || (now > deadline) || (savedBalanceToken >= rok.totalSupply()) || (crowdsaleclosed == true);
    }

    // Function to view current token balance of the crowdsale contract
    function tokenBalance() constant returns (uint256 balance) {
        return rok.balanceOf(address(this));
    }

    // Function to check if crowdsale has been successful (has incoming contribution balance met, or exceeded the minimum goal?)
    function isSuccessful() constant returns (bool) {
        return (savedBalance >= minFundingGoal);
    }

    // Function to check the Ether balance of a contributor
    function checkEthBalance(address _contributor) constant returns (uint256 balance) {
        return balances[_contributor];
    }

    // Function to check the current Tokens Sold in the ICO
    function checkRokSold() constant returns (uint256 total) {
        return (savedBalanceToken);
        // Function to check the current Tokens Sold in the ICO
    }

    // Function to check the current Tokens affected to the team
    function checkRokTeam() constant returns (uint256 totalteam) {
        return (savedBalanceToken.mul(19).div(100));
        // Function to check the current Tokens affected to the team
    }

    // Function to check the current Tokens affected to bounty
    function checkRokBounty() constant returns (uint256 totalbounty) {
        return (savedBalanceToken.div(100));
    }

    // Function to check the refund period is over
    function refundPeriodOver() constant returns (bool){
        return (now > refundeadline);
    }

    // Function to check the refund period is over
    function refundPeriodStart() constant returns (bool){
        return (now > deadline);
    }

    // function to check percentage of goal achieved
    function percentOfGoal() constant returns (uint16 goalPercent) {
        return uint16((savedBalance.mul(100)).div(minFundingGoal));
    }

    // Calcul the ROK bonus according to the investment period
    function getBonus(uint256 amount) internal constant returns (uint256) {
        uint bonus = 0;
        //   5 November 2017 11:00:00 GMT
        uint firstbonusdate = 1509879600;
        //  10 November 2017 11:00:00 GMT
        uint secondbonusdate = 1510311600;

        //  if investment date is on the 10% bonus period then return bonus
        if (now <= firstbonusdate) {bonus = amount.div(10);}
        //  else if investment date is on the 5% bonus period then return bonus
        else if (now <= secondbonusdate && now >= firstbonusdate) {bonus = amount.div(20);}
        //  return amount without bonus
        return bonus;
    }

    // Function to set the balance of a sender
    function setBalance(address sender,uint256 value) internal{
        balances[sender] = value;
    }

    // Only owner will finalize the crowdsale
    function finalize() onlyOwner {
        require(isStarted());
        require(!isComplete());
        crowdsaleclosed = true;
    }

    // Function to pay out
    function payout() onlyOwner {
        if (isSuccessful() && isComplete()) {
            rok.transfer(bounty, checkRokBounty());
            payTeam();
        }
        else {
            if (refundPeriodOver()) {
                escrow.transfer(savedBalance);
                PayEther(escrow, savedBalance, now);
                rok.transfer(bounty, checkRokBounty());
                payTeam();
            }
        }
    }

    //Function to pay Team
    function payTeam() internal {
        assert(checkRokTeam() > 0);
        rok.transfer(team, checkRokTeam());
        if (checkRokSold() < rok.totalSupply()) {
            // burn the rest of ROK
            rok.burn(rok.totalSupply().sub(checkRokSold()));
            //Log burn of tokens
            BurnTokens(rok.totalSupply().sub(checkRokSold()), now);
        }
    }

    //Function to update KYC list
    function updateKYClist(address[] allowed) onlyOwner{
        for (uint i = 0; i < allowed.length; i++) {
            if (KYClist[allowed[i]] == false) {
                KYClist[allowed[i]] = true;
            }
        }
    }

    //Function to claim ROK tokens
    function claim() public{
        require(isComplete());
        require(checkEthBalance(msg.sender) > 0);
        if(checkEthBalance(msg.sender) <= (3 ether)){
            rok.transfer(msg.sender,balancesRokToken[msg.sender]);
            balancesRokToken[msg.sender] = 0;
        }
        else{
            require(KYClist[msg.sender] == true);
            rok.transfer(msg.sender,balancesRokToken[msg.sender]);
            balancesRokToken[msg.sender] = 0;
        }
    }

    /* When MIN_CAP is not reach the smart contract will be credited to make refund possible by backers
     * 1) backer call the "refund" function of the Crowdsale contract
     * 2) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH
     */
    function refund() public {
        require(!isSuccessful());
        require(refundPeriodStart());
        require(!refundPeriodOver());
        require(checkEthBalance(msg.sender) > 0);
        uint ETHToSend = checkEthBalance(msg.sender);
        setBalance(msg.sender,0);
        asyncSend(msg.sender, ETHToSend);
    }

    /* When MIN_CAP is not reach the smart contract will be credited to make refund possible by backers
     * 1) backer call the "partialRefund" function of the Crowdsale contract with the partial amount of ETH to be refunded (value will be renseigned in WEI)
     * 2) backer call the "withdrawPayments" function of the Crowdsale contract to get a refund in ETH
     */
    function partialRefund(uint256 value) public {
        require(!isSuccessful());
        require(refundPeriodStart());
        require(!refundPeriodOver());
        require(checkEthBalance(msg.sender) >= value);
        setBalance(msg.sender,checkEthBalance(msg.sender).sub(value));
        asyncSend(msg.sender, value);
    }

}