// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract SecretVotingModule {
    mapping(address => bytes32) public commitPhase;
    mapping(address => uint) public revealPhase;

    event VoteCommitted(address voter);
    event VoteRevealed(address voter, uint candidateId);

    function commitVote(bytes32 hashedVote) external {
        require(commitPhase[msg.sender] == bytes32(0), "Already committed");
        commitPhase[msg.sender] = hashedVote;
        emit VoteCommitted(msg.sender);
    }

    function _revealVote(address voter, uint candidateId, string memory salt) internal returns (bool success) {
        require(commitPhase[voter] != bytes32(0), "No committed vote");
        bytes32 computedHash = keccak256(abi.encodePacked(candidateId, salt));
        require(computedHash == commitPhase[voter], "Invalid reveal");

        revealPhase[voter] = candidateId;
        delete commitPhase[voter];

        emit VoteRevealed(voter, candidateId);
        return true;
    }

    function getRevealedVote(address voter) external view returns (uint) {
        return revealPhase[voter];
    }
}
