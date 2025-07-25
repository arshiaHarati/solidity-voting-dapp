# 🗳️ Voting DApp with Secret Voting, Whitelist, and Token-Based Voting

This smart contract project implements a **modular decentralized voting system** with advanced features designed for fairness, security, and flexibility.

---

## ✨ Features

- ✅ **Whitelist System**  
  Only approved (whitelisted) addresses are allowed to participate in the voting process.

- 🔐 **Secret Voting**  
  Uses a commit-reveal mechanism to protect vote confidentiality. Users first commit a hash of their vote and later reveal it along with a secret.

- 🎫 **Token-Based Voting (Optional)**  
  Voters can use ERC-20 tokens to cast weighted votes. The more tokens they hold (or approve), the more influence they have.

- 👑 **Admin Controls**  
  The contract owner can:
  - Set the voting time window.
  - End the voting process manually.
  - Add whitelisted addresses.

- 👥 **Multiple Candidates**  
  Supports a list of candidates, stores votes securely, and calculates winners automatically — including in case of tie.

---

## 🛠️ How to Use

1. **Deploy** the contract with a list of candidate names.
2. **Set voting time** (optional if default time is set in constructor).
3. **Add voters** to the whitelist via the admin.
4. **Users commit** their vote using `commitVote(candidateId, salt)`.
5. During the reveal phase, **users call** `revealVote(candidateId, salt)` to confirm their vote.
6. Admin or anyone can **query vote counts** and **fetch winner(s)**.

### 🔁 Token Voting (if using `TokenVoting` contract)
1. The voter **approves** the contract to use their tokens:
   ```js
   await token.approve(tokenVoting.address, amount);

2.Then votes are counted based on token balance or transferred for security (depending on contract version).

3.Token-based votes are tallied with weight.

## 🔧 Technologies Used
    Solidity ^0.8.20

    Remix IDE (for writing and testing)

    OpenZeppelin Contracts (Ownable, ERC20 interfaces)

    Ethereum-compatible blockchain (Hardhat / Remix / Ganache / etc.)

## 📁 Modules Structure
    This DApp is modularized for better separation of concerns:

    WhitelistModule.sol – Handles whitelist management.

    SecretVotingModule.sol – Manages commit-reveal logic.

    TokenVoting.sol – Optional contract for ERC-20 based voting.

    BasicVoting.sol – Main contract using SecretVoting + Whitelist (non-token-based).

## 📄 License
    This project is licensed under the MIT License.