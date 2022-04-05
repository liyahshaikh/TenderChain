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

}

