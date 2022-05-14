pragma solidity >=0.4.0;

contract Tender{

    uint public tenderCount = 0;
    uint public bidCount = 0;
    uint public contractorCount = 0;
    uint public bidderCount = 0;

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
        uint bid;
        address userHash;
        uint timeStamp;
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

    enum ProposalStatus{
        verified,
        unverified,
        rejected
    }
    // aliya change state accordingly 
    enum BidStatus{
        processing,
        accepted,
        rejected   
    }

    mapping (uint => Tender) public tenders;
    mapping (uint => Bid) public bids;
    mapping (uint => address) public whoIsContractor;
    mapping (uint => address) public whoIsBidder;
    mapping (address => Contractor) public contractors;
    mapping (address => Bidder) public bidders;

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

    modifier alreadyPresesntTender()



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
    function createTender(string memory _tenderName, string memory _tenderDescription,uint256 _bidOpeningDate,  uint256 _bidSubmissionClosingDate, string _tenderDescription ,uint256 _finalTenderAmount) public {
        tenderCount++;
        tenders[tenderCount] = Tender(tenderCount,_tenderName , _tenderDescription, _bidOpeningDate, _bidSubmissionClosingDate, _tenderDescription, _finalTenderAmount, msg.sender);
    }
