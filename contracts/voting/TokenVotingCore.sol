// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenCore is Ownable {
    IERC20 public voteToken;
    string[] public candidates;

    mapping(uint => uint) public votes;
    mapping(address => bool) public hasVoted;
    mapping(address => bool) public whitelist;

    event VoteCasted(address voter, uint candidateId, uint weight);
    event Whitelisted(address user);

    constructor(address _tokenAddress, string[] memory _candidates) Ownable(msg.sender) {
        voteToken = IERC20(_tokenAddress);
        candidates = _candidates;
    }

    function addToWhitelist(address user) external onlyOwner {
        whitelist[user] = true;
        emit Whitelisted(user);
    }

    function vote(uint candidateId) external {
        require(whitelist[msg.sender], "You are not whitelisted");
        require(!hasVoted[msg.sender], "Already voted");
        require(candidateId < candidates.length, "Invalid candidate ID");

        uint weight = voteToken.balanceOf(msg.sender);
        require(weight > 0, "No voting power");

        require(
            voteToken.transferFrom(msg.sender, address(this), weight),
            "Token transfer failed"
        );


        votes[candidateId] += weight;
        hasVoted[msg.sender] = true;

        emit VoteCasted(msg.sender, candidateId, weight);
    }

    function getCandidate(uint candidateId) external view returns (string memory) {
        require(candidateId < candidates.length, "Invalid candidate ID");
        return candidates[candidateId];
    }

    function getVotes(uint candidateId) external view returns (uint) {
        require(candidateId < candidates.length, "Invalid candidate ID");
        return votes[candidateId];
    }
}
