// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../modules/WhitelistModule.sol";
import "../modules/SecretVotingModule.sol";

contract TokenVoting is WhitelistModule, SecretVotingModule {
    IERC20 public voteToken;
    string[] public candidates;

    mapping(string => uint) public finalVotes;
    mapping(address => bool) public hasRevealed;

    event VoteCasted(address voter, string candidate, uint weight);
    event VoteRevealed(address voter, string candidate);

    constructor(address _tokenAddress, string[] memory _candidates) {
        voteToken = IERC20(_tokenAddress);
        candidates = _candidates;
    }
    
    function getCandidates() public view returns (string[] memory) {
        return candidates;
    }
    function revealVote(string memory candidate, string memory salt) external {
        require(checkWhitelist(msg.sender), "Not whitelisted");
        require(_isValidCandidate(candidate), "Invalid candidate");

        bytes32 computed = keccak256(abi.encodePacked(candidate, salt));
        require(computed == commitPhase[msg.sender], "Invalid reveal");
        require(!hasRevealed[msg.sender], "Already revealed");

        uint weight = voteToken.balanceOf(msg.sender);
        require(weight > 0, "No token balance");

        hasRevealed[msg.sender] = true;
        finalVotes[candidate] += weight;

        emit VoteRevealed(msg.sender, candidate);
        emit VoteCasted(msg.sender, candidate, weight);
    }

    function getFinalVotes(string memory candidate) external view returns (uint) {
        return finalVotes[candidate];
    }

    function _isValidCandidate(string memory name) internal view returns (bool) {
        for (uint i = 0; i < candidates.length; i++) {
            if (keccak256(bytes(name)) == keccak256(bytes(candidates[i]))) {
                return true;
            }
        }
        return false;
    }
}
