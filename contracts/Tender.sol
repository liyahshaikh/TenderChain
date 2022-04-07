//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.16 <0.9.0;

contract Tender {
    address public tenderManager;
    string public tenderTitle; 
    string tenderId;
    string public tenderDescription; 
    uint256 public bidSubmissionClosingDate;
    uint256 public bidOpeningDate;
    uint256 public covers;
    string[] public clauses;
    string[] public taskName;
    uint256[] public taskDays;
    string[] public constraints;
    uint256 finalTenderAmount;
    
    struct BidderProposal {
        address bidderAddress;
        string[] quotationClause;
        uint256[] quotationAmount;
        uint256 proposalAmount;
        string[] constraintDocuments;
        ProposalStatus status;
    }
    enum ProposalStatus {
        verified,
        unverified,
        rejected
    }

    BidderProposal[] public allBidderProposals;
    mapping (address => ProposalStatus) isProposalVerified;

    function setTenderBasic(address _tenderManager, string memory _tenderTitle, string memory _tenderId, string memory _tenderDescription,
    uint256 _bidSubmissionClosingDate, uint256 _bidOpeningDate, uint256 _covers) public {
        tenderManager = _tenderManager;   
        tenderTitle = _tenderTitle;
        tenderId=_tenderId;
        tenderDescription = _tenderDescription;
        bidSubmissionClosingDate = _bidSubmissionClosingDate;
        bidOpeningDate = _bidOpeningDate;
        covers = _covers;
        finalTenderAmount = 0;
    }
    
    function setTenderAdvanced(string[] memory _clauses,
    string[] memory _taskName, uint256[] memory _taskDays,
    string[] memory _constraints) public {
        clauses = _clauses;
        taskName = _taskName;
        taskDays = _taskDays;
        constraints = _constraints;
    }

    function getTenderBasic() public view returns (address, string memory, string memory,
    uint, uint, uint) {
        return (tenderManager, tenderTitle, tenderId, 
        bidSubmissionClosingDate, bidOpeningDate, covers);
    }

    function getTenderAdvanced() public view returns (string[] memory, string[] memory, uint256[] memory, string[] memory) {
        return (clauses, taskName, taskDays, constraints );
    }

    function bid(address _bidderAddress,
    string[] memory _quotationClause, uint256[] memory _quotationAmount, string[] memory _constraintDocuments) public returns (bool) {
        allBidderProposals.push();
        BidderProposal storage temp = allBidderProposals[allBidderProposals.length];
        temp.bidderAddress = _bidderAddress;
        for (uint i=0; i < _quotationClause.length; i++) {
            temp.quotationClause[i] = _quotationClause[i];
            temp.quotationAmount[i] = _quotationAmount[i];
            temp.proposalAmount += _quotationAmount[i];
        }
        for (uint j=0; j < _constraintDocuments.length; j++) {
            temp.constraintDocuments[j] = _constraintDocuments[j];
        }
        temp.status = ProposalStatus.unverified;
        return true;
    }

    function getBiddindCloseDate() public view returns (uint256) {
        return bidSubmissionClosingDate;
    }

    function getProposalCount() public view returns (uint256) {
        return allBidderProposals.length;
    }

    function setTenderAmount(uint256 amount) public {
        if (amount != 0 && finalTenderAmount == 0)
            finalTenderAmount = amount;
    } 

    function getProposalsToVerify(uint index) public returns (string[] memory, string[][] memory, address) {
        //loop at web3
        string[][] storage tempDocuments;

        address tempAddresses;
        if (allBidderProposals[index].status == ProposalStatus.unverified) {
            tempDocuments.push(allBidderProposals[index].constraintDocuments);
            tempAddresses = allBidderProposals[index].bidderAddress;
        }
        return (constraints, tempDocuments, tempAddresses);
    }

    function verifyProposal(address contractorAddress) public {
        isProposalVerified[contractorAddress] = ProposalStatus.verified;
    }

    function rejectProposal(address contractorAddress) public {
        isProposalVerified[contractorAddress] = ProposalStatus.rejected;
    }

    function getProposal(uint256 index) public view returns (address, uint256, string[] memory, uint256[] memory, ProposalStatus) {
        if (index > allBidderProposals.length) revert();
        return (allBidderProposals[index].bidderAddress, 
        allBidderProposals[index].proposalAmount, allBidderProposals[index].quotationClause,
        allBidderProposals[index].quotationAmount, allBidderProposals[index].status);
    }

    function getVerifiedProposals(uint index) public returns (string[] memory, string[][] memory, address, uint[] memory) {
        //loop at web3
        string[][] memory tempDocuments = new string[](5);
        address tempAddresses;
        uint[] memory tempAmount;
        if (allBidderProposals[index].status == ProposalStatus.verified) {
            //This needs fixing, its broken. Too tired rn. 
            tempDocuments.push(allBidderProposals[index].constraintDocuments);
            tempAddresses = allBidderProposals[index].bidderAddress;
            tempAmount = allBidderProposals[index].quotationAmount;
        }
        return (constraints, tempDocuments, tempAddresses, tempAmount);
    } 



}

