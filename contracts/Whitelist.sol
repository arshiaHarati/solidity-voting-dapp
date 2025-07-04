// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Whitelist {
    address public owner;
    mapping (address => bool) public whitelistedAddresses;
    address[] public whitelistArray;

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this function");

        _;
    }  
    constructor(){
        owner = msg.sender;
        
    }

        event VotersList(address voter, uint count);


    function addWhitelist(address _Voters) public onlyOwner{
        require(!whitelistedAddresses[_Voters],"User is already whitelisted");
        whitelistedAddresses[_Voters] = true;
        whitelistArray.push(_Voters);
        emit VotersList(_Voters, whitelistArray.length);
    }

    function checkWhitelist(address _checkVoters) public view returns (bool){
        return whitelistedAddresses[_checkVoters];
    }
    function getWhitelistedList() public view returns (address[] memory) {
        return whitelistArray;
    }
}