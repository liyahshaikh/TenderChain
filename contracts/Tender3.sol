pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

contract TenderChain{

    uint public tenderCount = 0;
    uint public bidCount = 0;
    uint public contractorCount = 0;
    uint public bidderCount = 0;
    address public contractor;
    address public bidder;
    address private winner;
    uint private highestBid;

    event tenderEndsWithWinner(address winner, uint bid);
    event tenderEndsWithoutWinner();
    event ContractorAdded(address indexed account);
    event BidderAdded(address indexed account);

    struct Contractor {
        uint companyId; //should this be contractorId?
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
        bytes32 bidId;
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
        bool exists;

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
    mapping (bytes32 => Bid) public bids;    
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

        for(uint j = 1; j <= bidderCount; j++) {
            if(whoIsBidder[j] == _address) {
                require(1 == 2, "Address already present");
            }
        }
        _;
    }
    modifier onlyContractor() {
        require(contractors.has(msg.sender),
        "Contractor Only Access!");
        _;
    }
    modifier onlyBidder() {
        require(bidders.has(msg.sender),
        "Bidder Only Access");
    }

    function randomNumberGenerator() public view returns (uint randomNumber){
        randomNumber = uint(keccak256(abi.encodePacked(now)))%100000;
        return (randomNumber);
    }
    
    // fix needed for this modifier
    modifier alreadyPresentTender(bytes32 _id){
        require(!tenders[_id].exists,
        "Tender already exists");
        _;

    }

    // how to use? 
    function generateForTenderorBid(string _tenderName) public view returns (bytes32) {
        return keccak256(abi.encodePacked(_tenderName));
        
    }
    
    function createContractor(string _contractorName,uint _contractorId,string _emailId, uint _phoneNumber, string _username) public alreadyPresent(msg.sender) {
        contractorCount++;
        whoIsContractor[contractorCount] = msg.sender;
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

    function createTender(string memory _tenderDescription,bytes32 tender_id,string tenderName, uint256 _bidOpeningDate,  uint256 _bidSubmissionClosingDate) public onlyContractor() {
        
        //tenderName = contractors[msg.sender].contractorName; we already have tender name in the parameters.
        tender_id = generateForTenderorBid(tenderName);
        require(!tenders[tender_id].exist,"Tender already exists");
        tenders[tender_id].tenderId = tender_id;
        tenders[tender_id].tenderName = tenderName;
        tenders[tender_id].tenderDescription = _tenderDescription;
        tenders[tender_id].bidOpeningDate = _bidOpeningDate;
        tenders[tender_id].bidSubmissionClosingDate = _bidSubmissionClosingDate;
        tenders[tender_id].companyId = msg.sender;


    }

    function createBid(string bidName, bytes32 _tenderId,bytes32 bid_id, string _tenderName, uint _bidAmount) public onlyBidder() {
        bidName = bidders[msg.sender].companyName;
        //Check this.
        bid_id = generateForTenderorBid((bidName + string(_tenderId)));
        require(!bids[bid_id].exists," Only one bid can be placed by a bidder");
        require(now < tenders[_tenderId].bidSubmissionClosingDate, " Sorry, the bidding period is over");
        bids[bid_id].tenderName = tenders[_tenderId].tenderName;
        bids[bid_id].bidAmount = _bidAmount;
        bids[bid_id].timeStamp = now;
        bids[bid_id].status = BidStatus.processing; // check syntax

    }

    function approveBid(bytes32 bid_id) onlyContractor() {
        bids[bid_id].status = BidStatus.approved;
    }

    function rejectBid() onlyContractor() {
        bids[bid_id].status = BidStatus.rejected;
        
    }
    function negotiateBid() onlyContractor() {
        bids[bid_id].status = BidStatus.negotiate;
        
    }

    function getWinner(bytes32 bid_id){
        if (bids[bid_id].status == BidStatus.approved) {
            winner = bids[bid_id].companyAddress;
            emit tenderEndsWithWinner(winner, bid_id);
        }
        else {
            emit tenderEndsWithoutWinner();
        }

    }


}
