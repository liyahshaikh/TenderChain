pragma solidity >=0.4.0;
pragma experimental ABIEncoderV2;

contract Tender{

    uint public tenderCount = 0;
    uint public bidCount = 0;
    uint public organisationCount = 0;
    uint public bidderCount = 0;
    address public organisation;
    address public bidder;
    address private winner;
    uint private highestBid;

    struct Organisation {
        uint organisationId;
        string organisationName;
        address organisation;
        string emailId;
        uint phoneNumber;

    }

    struct Bidder{
        uint bidderId; // need?
        address bidder;
        string bidOrganisationName;
        string emailId;
        uint phoneNumber;

    }

    struct Bid{
        bytes32 bidId; //need?
        bytes32 tenderId;
        string tenderName;
        uint bidAmount;
        address organisation;
        uint timeStamp;
        BidStatus status;
    }

    struct Tender{
        bytes32 tenderId;
        string tenderName;
        address organisation; 
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

    enum TenderStatus{
        open,
        close
    }

    mapping (bytes32 => Tender) public tenders; 
    mapping (bytes32 => Bid) public bids;    
    mapping (address => string) public whoIsorganisation;
    mapping (address => string) public whoIsBidder;
    mapping (address => organisation) public organisations;
    mapping (address => Bidder) public bidders;
    mapping (address => bool) public bidExists;
    mapping (address=> Tender) public bidToTender; // see this 
    
    event OrganisationAdded(address indexed organistaion, string indexed organisationName, string emailId, uint phoneNumber, string username)
    event BidderAdded(address indexed bidderId, string bidOrganisationName, string emailId,uint phoneNumber,string username)
    event TenderAdded(address indexed organisation, string indexed tenderName, uint256 bidSubmissionClosingDate, uint256 bidOpeningDate, string tenderDescription)
    event BidAdded(address indexed bidder, bytes32 indexed bidId, uint256 bidAmount, BidStatus currentstatus, uint timeStamp)
    event BidStatusChanged(bytes32 indexed bidId, BidStatus currentstatus)
    event TenderStatusChanged(bytes32 indexed tenderid, TenderStatus currentstatus)

    // organisation and bidder should be unique
    modifier alreadyPresent(address _address) {
        for(uint i = 1; i <= organisationCount; i++) {
            if(whoIsorganisation[i] == address) {
                require(1 == 2, "Address already present");
            }
        }

        for(uint i = 1; i <= bidderCount; i++) {
            if(whoIsBidder[i] == _address) {
                require(1 == 2, "Address already present");
            }
        }
        ;
    }
    
    
    // fix needed for this modifier
    modifier alreadyPresentTender(bytes32 id){
        require(!tenders[id].exists,
        "Tender already exists");
        ;

    }

    // how to use? 
    function generateForTender(string memory tenderName, address organisation ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(tenderName));
        
    }
    function generateForBid( bytes32 tenderId,  address bidOrganisation) public pure returns (bytes32) {
     return keccak256(abi.encodePacked(tenderName, bidOrganisation));
}
    
    function createorganisation(string organisationName, string emailId, uint phoneNumber, string username) public alreadyPresent(msg.sender) {
        organisationCount++;
        whoIsorganisation[organisationCount] = msg.sender;
        organisations[msg.sender].organisations = msg.sender;
        organisations[msg.sender].username= username;
        organisations[msg.sender].organisationName = organisationName;
        organisations[msg.sender].emailId = emailId;
        organisations[msg.sender].phoneNumber = phoneNumber;

        emit OrganisationAdded(msg.sender, organisationName, emailId, phoneNumber, username)

    }

    function createBidder(string memory organisationName, address bidderId,string emailId,uint phoneNumber,string username) public alreadyPresent(msg.sender) {
        bidderCount++;
        whoIsBidder[bidderCount] = msg.sender;
        bidders[msg.sender].bidorganisationName = bidorganisationName;
        bidders[msg.sender].bidder = msg.sender;
        bidders[msg.sender].username= username;
        bidders[msg.sender].emailId = emailId;
        bidders[msg.sender].phoneNumber= phoneNumber;

        emit BidderAdded(msg.sender, bidOrganisationName, emailId, phoneNumber, username)

    }
    
    // add functionality : no two tenders can be the same 
    // modifier to be added : only a organisation can create a tender 

    function createTender(string tenderName, string memory tenderDescription,uint256 bidOpeningDate, uint256 bidSubmissionClosingDate) public {
        
        tenderid = generateForTenderorBid(tenderName, msg.sender); // hash for tender name and address?
        require(!tenders[tenderid].exist,"Tender already exists");
        tenders[tenderid].tenderId = tenderid;
        tenders[tenderid].tenderName = tenderName;
        tenders[tenderid].tenderDescription = tenderDescription;
        tenders[tenderid].bidOpeningDate = bidOpeningDate;
        tenders[tenderid].bidSubmissionClosingDate = bidSubmissionClosingDate;
        tenders[tenderid].organisationId = msg.sender;

        emit TenderAdded(msg.sender, tenderName, bidSubmissionClosingDate, bidOpeningDate, tenderDescription)


    }

    function createBid(bytes32 tenderId,uint bidAmount) public {

        bidid = generateForTenderorBid((tenderId, msg.sender));
        require(!bids[bidid].exists," Only one bid can be placed by a bidder");
        require(now < tenders[tenderId].bidSubmissionClosingDate, " Sorry, the bidding period is over");
        bids[bidid].tenderName = tenders[tenderId].tenderName;
        bids[bidid].bidAmount = bidAmount;
        bids[bidid].timeStamp = now;
        bids[bidid].status = BidStatus.processing; // check syntax
        
        emit BidAdded(msg.sender, bidid, bidAmount, BidStatus.processing, timeStamp)

    }

    function approveBid(bytes32 bidid){
        bids[bidid].status = BidStatus.approved;
        emit BidStatusChanged(bidid, BidStatus.approved)
    }

    function rejectBid(bytes32 bidid){
        bids[bidid].status = BidStatus.rejected;
        emit BidStatusChanged(bidid, BidStatus.rejected)
        
    }

    function negotiateBid(bytes32 bidid){
        bids[bidid].status = BidStatus.negotiate;
        emit BidStatusChanged(bidid,BidStatus.negotiating)
        
    }

    function selectWinner(bytes32 bidid){
        bids[bidid].status = BidStatus.approved;
        emit BidStatusChanged(bidid,BidStatus.approved)

    }











}
