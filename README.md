# Voting DApp with Secret Voting and Whitelist

This smart contract project implements a decentralized voting system with the following features:

- **Whitelist:** Only approved addresses can participate in voting.
- **Secret Voting:** Votes are committed as hashes first (commit phase) and then revealed (reveal phase) to keep votes confidential until the reveal.
- **Admin control:** Admin can set voting time and end the voting process.
- **Multiple candidates:** Supports multiple candidates with vote tallying and winner calculation.

## How to Use

1. The admin deploys the contract with a list of candidates.
2. The admin sets the voting time window.
3. Whitelisted users commit their hashed votes during the commit phase.
4. Users reveal their votes during the reveal phase.
5. Votes are counted and winners can be queried.

## Technologies

- Solidity ^0.8.20
- Remix IDE for development and deployment
- Ethereum-compatible blockchain

## License

This project is licensed under the MIT License.
