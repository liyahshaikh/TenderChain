pragma solidity ^0.5.0;

contract HashGenerator {
    
    constructor() public {

    }
    
    function generateHash(uint nonce, uint bidAmt) public pure returns (bytes32) {
        bytes memory toHash = abi.encodePacked(nonce, bidAmt);
        bytes32 hash = keccak256(toHash);
        return hash;
    }
}
