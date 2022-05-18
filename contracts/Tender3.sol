pragma solidity >=0.4.0;
pragma experimental ABIEncoderV2;

contract Tender{

    uint public tenderCount = 0;
    uint public bidCount = 0;
    uint public contractorCount = 0;
    uint public bidderCount = 0;
    address private winner;
    uint private highestBid;

    event tenderEndsWithWinner(address winner, uint bid);
    event tenderEndsWithoutWinner();

    struct Contractor {
        uint companyId;
        string contractorName;
        string emailId;
        uint phoneNumber;

    }

    struct Bidder{
        uint bidderId;
        string companyName;

        string emailId;
        uint phoneNumber;

    }

    struct Bid{
        bytes32 tenderId;
        string tenderName;
        uint bidAmount;
        address companyAddress;
        uint timeStamp;
        BidStatus status;
    }

    struct Tender{
        bytes32 tenderId;
        string tenderName;
        address companyId; 
        uint256 bidSubmissionClosingDate; 
        uint256 bidOpeningDate;
        string tenderDescription;

    }

    // maybe remove 
    enum ProposalStatus{
        verified,
        unverified,
        rejected
    }
    // aliya change state accordingly 
    enum BidStatus{
        processing,
        accepted,
        negotiating,
        rejected   
    }

    mapping (bytes32 => Tender) public tenders; 
    mapping (uint => Bid) public bids;    
    mapping (uint => address) public whoIsContractor;
    mapping (uint => address) public whoIsBidder;
    mapping (address => Contractor) public contractors;
    mapping (address => Bidder) public bidders;
    mapping (address => bool) public bidExists;
    mapping (address=> Tender) public bidToTender; // see this 

    // contractor and bidder should be unique
    modifier alreadyPresent(address _address) {
        for(uint i = 1; i <= contractorCount; i++) {
            if(whoIsContractor[i] == _address) {
                require(1 == 2, "Address already present");
            }
        }

        for(uint i = 1; i <= bidderCount; i++) {
            if(whoIsBidder[i] == _address) {
                require(1 == 2, "Address already present");
            }
        }
        _;
    }
    
    
    // fix needed for this modifier
    modifier alreadyPresentTender(uint _id){
        require(!tenders[_id].exists,
        "Tender already exists");
        _;

    }
    // modifier to be wriiten
    modifier onlyContractor(){

    }

    // modifier to be wriiten
    modifier onlyBidder(){

    }

    modifier onlyBefore(uint id, uint time) {
        require(Tender[id].bidOpeningDate > time, " The tender is now closed and is no longer accepting bids");
        _;
    }

    modifier onlyAfter(uint time) {
        require(now > time);
        _;
    }
    
    function hasBeenChecked() public view onlyAfter(revelationEnd) returns (bool) {
      return checkedByOwner;
    }

    // how to use? 
    function generateForTenderorBid(string memory _tenderName) public view returns (bytes32) {
        return keccak256(abi.encodePacked(_tenderName));
        
    }
    
    function createContractor(string _contractorName,uint _contractorId,string _emailId, uint _phoneNumber, string _username) public alreadyPresent(msg.sender) {
        contractorCount++;
        whoIsContractor[contractorCount] = msg.sender;
        contractors[msg.sender].companyId = msg.sender; // we need this
        contractors[msg.sender].username= _username;
        contractors[msg.sender].contractorName = _contractorName;
        contractors[msg.sender].emailId = _emailId;
        contractors[msg.sender].phoneNumber = _phoneNumber;

    }

    function createBidder(string memory _companyName, address _bidderId,string _emailId,uint _phoneNumber,string _username) public alreadyPresent(msg.sender) {
        bidderCount++;
        whoIsBidder[bidderCount] = msg.sender;
        bidders[msg.sender].companyName = _companyName;
        bidders[msg.sender].bidderId = msg.sender;
        bidders[msg.sender].username= _username;
        bidders[msg.sender].emailId = _emailId;
        bidders[msg.sender].phoneNumber= _phoneNumber;

    }
    
    // add functionality : no two tenders can be the same 
    // modifier to be added : only a contractor can create a tender 

    function createTender(string memory _tenderDescription,uint256 _bidOpeningDate,  uint256 _bidSubmissionClosingDate) public {
        
        tenderName = contractors[msg.sender].username;
        tender_id = generateForTenderorBid(tenderName);
        require(!tenders[tender_id].exist,"Tender already exists");
        tenders[tender_id].tenderId = tender_id;
        tenders[tender_id].tenderName = _tenderName;
        tenders[tender_id].tenderDescription = _tenderDescription;
        tenders[tender_id].bidOpeningDate = _bidOpeningDate;
        tenders[tender_id].bidSubmissionClosingDate = _bidSubmissionClosingDate;
        tenders[tender_id].companyId = msg.sender;

    }

    function createBid(string _tenderName, uint _bidAmount , address _companyAddress, uint _timeStamp, uint256 _bidSubmissionClosingDate ) public onlyBefore(_tenderId, _timestamp ) {
        bidName = bidders[msg.sender].username;
        bid_id = generateForTenderorBid((bidName));
        require(!bids[bid_id].exists," Only one bid can be placed by a bidder");
        require(now < _timeStamp, " Sorry, the bidding period is over");
        bids[bid_id].tenderName = 
        bids[bid_id].bidAmount = _bidAmount;



                

    }

    function approveBid(){

    }
    function rejectBid(){
        
    }
    function negotiateBid(){
        
    }










}
