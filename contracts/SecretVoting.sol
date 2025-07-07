// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecretVote  {

    mapping (address => bytes32 ) public CommitPhase ;
    mapping (address => uint ) public RevealPhase ;

    event VoteCommitted(address voter);
    event VoteRevealed(address voter, uint candidateId);


    function commitVote(bytes32 hashedVote) public {
        require(CommitPhase[msg.sender] == bytes32(0), "Commit phase already active");
        CommitPhase[msg.sender] = hashedVote;
        emit VoteCommitted(msg.sender);
    }

}