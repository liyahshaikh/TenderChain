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
        uint id;
        string contractorCompany;
    }

    struct Bidder{
        uint id;
        string companyName;

    }

    struct Bid{
        uint id;
        uint tenderId;
        string tenderTitle;
        uint bidAmount;
        address bidder;
        uint timeStamp;
        BidStatus status;
    }

    struct Tender{
        uint id;
        string tenderName; 
        uint256 bidSubmissionClosingDate; 
        uint256 bidOpeningDate;
        uint256 bidRevelationDay;
        uint256 finalTenderAmount;
        string tenderDescription;

    }

    struct User{
        address accountAddress;
        string accountName;
        AccountType accountType;
        string userAddress;
        uint userContactNumber;
        string userEmail;
        bool exists;
    }

    enum AccountType{
        Bidder,
        Contractor
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

    mapping (uint => Tender) public tenders;
    mapping (uint => Bid) public bids;
    mapping (uint => address) public whoIsContractor;
    mapping (uint => address) public whoIsBidder;
    mapping (address => Contractor) public contractors;
    mapping (address => Bidder) public bidders;
    mapping (address => bool) public bidExists;
    mapping (uint => bool) public tenderExists; // see this aliya

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
    modifier alreadyPresesntTender(uint _id){
        require(!tenderExists[_id],
        "Tender already exists");
        _;

    }
    // modifier to be wriiten
    modifier onlyContractor(){

    }

    // modifier to be wriiten
    modifier onlyBidder(){

    }

    modifier onlyBefore(uint time) {
        require(now < time);
        _;
    }

    modifier onlyAfter(uint time) {
        require(now > time);
        _;
    }

    function hasBidBefore(address bidder) public view returns (bool) {
        ;
    }
    
    function hasBeenChecked() public view onlyAfter(revelationEnd) returns (bool) {
      return checkedByOwner;
    }

    // how to use? 
    function generateHash(uint nonce, uint bidAmt) public pure returns (bytes32) {
        bytes memory toHash = abi.encodePacked(nonce, bidAmt);
        bytes32 hash = keccak256(toHash);
        return hash;
    }
    
    function createContractor(string memory _username,) public alreadyPresent(msg.sender) {
        contractorCount++;
        whoIsContractor[contractorCount] = msg.sender;
        contractors[msg.sender] = Contractor(contractorCount, _username);
    }

    function createBidder(string memory _username) public alreadyPresent(msg.sender) {
        bidderCount++;
        whoIsBidder[bidderCount] = msg.sender;
        bidders[msg.sender] = Bidder(bidderCount, _username);
    }
    
    // add functionality : no two tenders can be the same 
    // modifier to be added : only a contractor can create a tender 

    function createTender(string memory _tenderName, string memory _tenderDescription,uint256 _bidOpeningDate,  uint256 _bidSubmissionClosingDate, string _tenderDescription ,uint256 _finalTenderAmount) public  {
        if (tenderExists[_id]! = true){
            tenderCount++;
            tenders[tenderCount] = Tender(tenderCount, _tenderName , _tenderDescription, _bidOpeningDate, _bidSubmissionClosingDate, _tenderDescription, _finalTenderAmount, msg.sender);
            tenderExists[_id]= true; // this line 
        }
        else{
            require(tenderExists[_id] == true, "Tender already exists");
        }   
    }

    function createBid()










}
