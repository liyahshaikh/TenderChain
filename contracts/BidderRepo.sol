//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

contract BidderRepo {
    address[] bidders; //all contractors verified + unverified
    //address[] verifiedBidders;
    //address[] unverifiedContractors;
    
    // mapping (address=>bool) verifiedStatus; //false => unverified, true => verified
    // mapping (address=>address) contratorToVerifier;
    mapping (address=>address) public walletAddressToNode;


    

    function newBidder(address walletAddress, address nodeAddress) public returns (bool) {
        bidders.push(nodeAddress);
        //verifiedStatus[nodeAddress] = false;
        mapWalletAddressToNode(walletAddress,nodeAddress);
        return true;
    }

    function mapWalletAddressToNode(address walletAddress, address nodeAddress) public {
        walletAddressToNode[walletAddress] = nodeAddress;
    }

    // function verifyContractor(address contractorAddress, address verifierAddress) public {
    //     verifiedContractors.push(contractorAddress);
    //     verifiedStatus[contractorAddress] = true;
    //     contratorToVerifier[contractorAddress] = verifierAddress;
    // }

    // function getVerifiedContractorsCount() public returns (uint256) {
    //     return verifiedContractors.length;
    // }
        
    // function getVerifiedContractors() public returns (address[]) {
    //     return verifiedContractors;
    // }

    // function getVerifier(address contractorAddress) public returns (address) {
    //     return contratorToVerifier[contractorAddress];
    // }

    function getBidder() public view returns (address[] memory) {
        return bidders;
    }

    function getBidderCount() public view returns (uint256) {
        return bidders.length;
    }

    // function getVerificationStatus(address contractorAddress) returns (bool) {
    //     return verifiedStatus[contractorAddress];
    // }
    
    // function getUnverifiedContractors(uint256 index) public returns (address) {
    //     //loop at web3
    //     if (index > bidders.length) revert();
    //     // if (!verifiedStatus[bidders[index]]) {
    //     //     return bidders[index]; 
    //     // }
    //     revert();
    // }
}