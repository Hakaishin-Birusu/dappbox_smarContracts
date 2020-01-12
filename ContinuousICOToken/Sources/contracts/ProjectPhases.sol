pragma solidity ^0.4.11;

contract LinkedList {

  event AddEntry(bytes32 head,InvestmentTranche investmentTranche,bytes32 next);


   public struct FundingType

    // The possible FundingTypes
    // INITIAL: The amount should be raised before the project starts
    // PREVIOUS: The amount should be raised befre the project phase starts
    // PREDECESSOR: The amount should be raised at the previous project phase
    enum FundingType {INITIAL,PREVIOUS,PREDECESSOR}
  
    public struct InvestmentPeriod
    {
        // Start investment
        uint256 public constant startDate;
        uint256 public constant endDate;
        uint256 public constant extensionDate;  
        uint256 public constant requiredFunding;  
    }

    public struct InvestmentTranche
    {
        InvestmentPeriod investmentPeriod;
        uint stakingPercentage;
        // ipfs hash of document establishing the conditions of the current investment tranche
        bytes public CCOLegalWrapperIPFSHash;
        FundingType fundingType;
    }

  uint public length = 0;//also used as nonce

  struct LinkedInvestmentPeriod{
    bytes32 next;
    InvestmentTranche investmentTranche;
    boolean isStarted;
    boolean isExtended;
  }

  bytes32 public head;
  mapping (bytes32 => LinkedInvestmentPeriod) public ListLinkedInvestmentPeriod;

  function LinkedList(){}

  function addEntry(InvestmentTranche _investmentTranche) public returns (bool){
    LinkedInvestmentPeriod memory lip = LinkedInvestmentPeriod(head,_investmentTranche);
    bytes32 id = sha3(lip.investmentTranche.startDate,lip.investmentTranche.endDate,now,length);
    ListLinkedInvestmentPeriod[id] = object;
    head = id;
    length = length+1;
    AddEntry(head,object.number,object.name,object.next);
  }

  //needed for external contract access to struct
  function getEntry(bytes32 _id) public returns (bytes32,uint,bytes32){
    return (ListLinkedInvestmentPeriod[_id].next,ListLinkedInvestmentPeriod[_id].number,objects[_id].investmentTranche, objects[_id].isStarted, objects[_id].isExtended);
  }


  //------------------ Exploring project schedule

  function nextProjectRelease() public constant returns (uint) {
    bytes32 current = head;
    uint256 currentDate;
    while( current != 0 ){
      if (ListLinkedInvestmentPeriod[current].isStarted)
        currentDate = ListLinkedInvestmentPeriod[current].investmentTranche.endDate;
    }
    return currentDate;
  }

}
