//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;


contract Bidder {

    address walletAddress;
    string name;
    string email;
    string phoneNumber;
    string panNumber;
    string gstNumber;
    bool isVerified;

    address[] placedBids;
    mapping (address=>bool) public bidStatus; //false =>rejected or not seen,true => accepted
    
    address[] contracts;
    mapping (address=>bool) public contractStatus; //true=> active,false=>completed

    
    
    function setContractor(address _walletAddress, string memory _email, string memory _name,
    string memory _phoneNumber, string memory _panNumber, string memory _gstNumber) public {
        walletAddress = _walletAddress;
        name = _name;
        email = _email;
        phoneNumber = _phoneNumber;
        panNumber = _panNumber;
        gstNumber = _gstNumber;
        isVerified = false;
    }

    // function updateOfficerVerifiedStatus() public {
    //     isVerified = true;
    // }

    function getContracts() public view returns (address[] memory) {
        return contracts;
    }

    function addToContracts(address contractAddress) public returns (bool) {
        contracts.push(contractAddress);
        contractStatus[contractAddress] = true;
        return true;
    }

    function getContractStatus(address contractAddress) public view returns (bool) {
        return contractStatus[contractAddress];
    }

    function changeContractStatus(address contractAddress) public {
        contractStatus[contractAddress] = false;
    }

    function placeBid(address tenderAddress) public returns (bool) {
        placedBids.push(tenderAddress);
        bidStatus[tenderAddress] = false;
        return true;
    }

    function getPlacedBids() public view returns (address[] memory) {
        //loop for Accepted Bids
        return placedBids;
    }

    function getBidStatus(address tenderAddress) public view returns (bool){
        return bidStatus[tenderAddress];
    }

    function updateBidStatus(address tenderAddress) public {
        bidStatus[tenderAddress] = true;
    }
}