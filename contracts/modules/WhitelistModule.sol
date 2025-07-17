// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract WhitelistModule {
    mapping(address => bool) public whitelistedAddresses;
    address[] public whitelistArray;

    event VotersList(address voter, uint count);

    function _addWhitelist(address _voter) internal {
        require(!whitelistedAddresses[_voter], "User already whitelisted");
        whitelistedAddresses[_voter] = true;
        whitelistArray.push(_voter);
        emit VotersList(_voter, whitelistArray.length);
    }

    function checkWhitelist(address _voter) public view returns (bool) {
        return whitelistedAddresses[_voter];
    }

    function getWhitelistedList() public view returns (address[] memory) {
        return whitelistArray;
    }
}

