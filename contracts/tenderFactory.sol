//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.16;

import "./Tender.sol";


contract tenderFactory {
    address[] allTenders;

    function createTender(address tenderManager, string memory tenderTitle, string memory tenderId, string memory tenderDescription, 
    uint bidSubmissionClosingDate, uint bidOpeningDate, uint covers, string[] memory clauses,
    string[] memory taskName, uint[] memory taskDays, 
    string[] memory constraints) public returns (address) {
        Tender newTender = new Tender();
        newTender.setTenderBasic(tenderManager, tenderTitle, tenderId, 
        tenderDescription,
        bidSubmissionClosingDate, bidOpeningDate, covers);
        newTender.setTenderAdvanced(clauses,
        taskName, taskDays, 
        constraints);
        allTenders.push(address(newTender));
        return address(newTender);
    }
}