// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/access/Ownable.sol";
import "../modules/WhitelistModule.sol";
import "../modules/SecretVotingModule.sol";

contract BasicVoting is WhitelistModule, SecretVotingModule, Ownable  {

    string[] public candidates;
    mapping (string => uint) public votes;
    mapping (address => bool) public voted;
    uint256 startTime;
    uint256 endTime;
    uint public voterCount = 0;
    bool public voteOpen = true;

    constructor(string[] memory _candidates) Ownable(msg.sender) {

        startTime = block.timestamp;
        endTime =  block.timestamp + 5 minutes;
        for (uint i = 0; i < _candidates.length; i++) {

            bool exists = false;
            for (uint j = 0; j < candidates.length; j++) {
                if (keccak256(bytes(candidates[j])) == keccak256(bytes(_candidates[i]))) {
                    exists = true;
                    break;
                }
            }
            require(!exists, "Duplicate candidate name");
            candidates.push(_candidates[i]);
        }

    }

    event Voted(address voter, string candidates);
    event VotingTimesSet(uint start, uint end);
    
    function getCandidates() public view returns (string[] memory) {
        return candidates;
    }

    function setVotingTime(uint start, uint end) public onlyOwner() {
        require(block.timestamp < startTime, "Voting already started");
        require(start < end, "Start time must be before end time");
        startTime = block.timestamp + start;
        endTime = block.timestamp + end;
        emit VotingTimesSet(startTime, endTime);
    }

    function addVoter(address voter) public onlyOwner {
    _addWhitelist(voter);
    }


    // function vote(uint candidateId) public {
    //     require(checkWhitelist(msg.sender), "You are not in whitelist");
    //     require(block.timestamp <= endTime && block.timestamp >= startTime, "Voting is not active");
    //     require(!voted[msg.sender], "You have already voted");
    //     require(voteOpen, "Voting has ended");
    //     require(candidateId < candidates.length, "Invalid candidate ID");

    //     votes[candidates[candidateId]]++;
    //     voted[msg.sender] = true;
    //     voterCount++;
    //     emit Voted(msg.sender, candidates[candidateId]);
    // }

    function _registerVote(address voter, uint candidateId) internal {
        require(candidateId < candidates.length, "Invalid candidate ID");
        require(!voted[voter], "Already voted");

        votes[candidates[candidateId]]++;
        voted[voter] = true;
        voterCount++;
    }
    function revealVote(uint candidateId, string memory secretSalt) public {
        require(checkWhitelist(msg.sender), "You are not in whitelist");
        require(commitPhase[msg.sender] != bytes32(0), "You have not committed a vote.");
        bytes32 computedHash = keccak256(abi.encodePacked(candidateId, secretSalt));
        require(computedHash == commitPhase[msg.sender] , "Invalid vote");
        require(voteOpen, "Voting has ended");
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting is not active");
        _registerVote(msg.sender, candidateId);

        revealPhase[msg.sender] = candidateId;
        delete commitPhase[msg.sender]; 
        emit VoteRevealed(msg.sender,candidateId);
    }
    
    function getVotes(string memory candidateName) public view returns (uint) {
        bool validCandidate = false;

        for (uint i = 0; i < candidates.length; i++) {
            if (keccak256(bytes(candidates[i])) == keccak256(bytes(candidateName))) {
                validCandidate = true;
                break;
            }
        }

        require(validCandidate, "Invalid candidate");

        return votes[candidateName];
    }

    function endVote() public onlyOwner() {
        voteOpen = false;
    }


    function getWinners() public view returns (string[] memory winnerNames, uint[] memory winnerVotes) {
        require(candidates.length > 0, "No candidates found");
        uint maxVotes = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (votes[candidates[i]] > maxVotes) {
                maxVotes = votes[candidates[i]];
            }
        }

        uint winnersCount = 0;
        for (uint i = 0; i < candidates.length; i++) {
            if (votes[candidates[i]] == maxVotes) {
                winnersCount++;
            }
        }

        winnerNames = new string[](winnersCount);
        winnerVotes = new uint[](winnersCount);
        uint index = 0;
        for (uint i = 0; i < candidates.length; i++) {
            if (votes[candidates[i]] == maxVotes) {
                winnerNames[index] = candidates[i];
                winnerVotes[index] = votes[candidates[i]];
                index++;
            }
        }
        return (winnerNames,winnerVotes);

    }

    function getVoterCount() public view returns (uint) {
        return voterCount;
    }



}