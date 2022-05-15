//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;


contract Contract {   
    address public contractorAddress;
    string tenderId;
    uint creationDate;
    uint public completionDate;
    string[] public constraints;
    uint finalQuotationAmount;

    string public contractName;

    mapping (uint=>Task) private taskIndexMapping;
    
    struct Task {
        string description;
        uint deadlineTime;
        uint amount; 
        TaskStatus status;
        uint completionTime; 
    }

    enum TaskStatus {
        pending,
        reportedComplete,
        complete,
        contractorPaid
    }

    Task[] public tasks;


    modifier onlyContractor {
        if (msg.sender != contractorAddress) {
            revert();
            _;
        }
    }
    
    function setContractBasic (
        address _contractorAddress, 
        string memory _tenderId,
        uint  _completionDate,
        string[] memory _constraints
        ) public payable {
        
        contractorAddress = _contractorAddress;
        tenderId = _tenderId;
        constraints = _constraints;
        creationDate = block.timestamp;
        completionDate = _completionDate;
    }

    function setContractAdvanced (
        string memory _contractName, 
        uint _finalQuotationAmount,
        string[] memory _taskDescription, 
        uint[] memory _deadlineForEachTask, 
        uint[] memory _amountForEachTask, 
        uint _reviewtime) public payable {
        
        contractName = _contractName;
        finalQuotationAmount = _finalQuotationAmount;
        uint totalAmount = 0;
        for (uint i=0; i < _taskDescription.length; i++) {
            Task storage task = tasks[tasks.length++];
            task.description = _taskDescription[i];
            task.deadlineTime = _deadlineForEachTask[i];
            task.amount = _amountForEachTask[i];
            totalAmount += task.amount*(1 ether);
            task.status = TaskStatus.pending;
            taskIndexMapping[i] = task;
        }
        if (totalAmount > msg.value*(1 ether)) {
            revert();
        }
        if (totalAmount > finalQuotationAmount) {
            revert();
        }
        //ContractDeployed();
    }

    function getContractBasic() public view returns (string memory, address, string memory,
    uint, uint) {
        return (contractName, contractorAddress, tenderId,
        creationDate, completionDate);
    }

    function getContractAdvanced() public view returns (string memory, uint, string[] memory) {
        return (contractName, finalQuotationAmount, 
        constraints);
    }

    function getContractName() public view returns (string memory) {
        return contractName;
    }

    function getCompletionDate() public view returns (uint) {
        return completionDate;
    }

    function getNumberOfTasks() public view returns (uint) {
        return tasks.length;
    }

    function getTask(uint256 index) public view returns (string memory, uint, uint, TaskStatus, uint) {
        return (tasks[index].description, tasks[index].deadlineTime, tasks[index].amount,
        tasks[index].status, tasks[index].completionTime);
    }

    function taskCompletedByContractor(uint _taskIndex) public onlyContractor {
        if (_taskIndex >= tasks.length) revert();
        Task storage task = tasks[_taskIndex];

        if (msg.sender != contractorAddress) revert();
        if (task.status != TaskStatus.pending) revert();
        if (block.timestamp > task.deadlineTime) revert();
        task.status = TaskStatus.reportedComplete;
        task.completionTime = block.timestamp;
        //eventToFire
    }

    // function verifyTask(uint _taskIndex) public onlyGovernmentOfficer returns (bool) {
    //     if (_taskIndex >= tasks.length) revert();
    //     Task storage task = tasks[_taskIndex];

    //     if (task.status != TaskStatus.reportedComplete) revert();
    //     if (msg.sender == governmentOfficerAddress) {
    //         governmentOfficerVerified = true;
    //         task.status = TaskStatus.complete;
    //         return true;
    //     // }else if (msg.sender == specialOfficerAddress) {
    //     //     specialOfficerVerified = true;
    //     //     task.status = TaskStatus.partiallyVerified;
    //     // }
    //     }else {
    //         revert();
    //     }

        // if (governmentOfficerVerified && specialOfficerVerified) {
        //     task.status = TaskStatus.complete;
        // }
    // }

    function withdrawForTask(uint _taskIndex) public onlyContractor returns (bool) {
        if (_taskIndex >= tasks.length) revert();
        Task storage task = tasks[_taskIndex];

        if (msg.sender != contractorAddress) revert();
        if (task.status != TaskStatus.complete) revert();

        uint amount = task.amount*(1 ether);
        task.status = TaskStatus.contractorPaid;
        msg.sender.transfer(amount);
        return true;
    }
}