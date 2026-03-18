# Modularised Eviction Vault Challenge

This project is aimed at refactoring and security hardening of the **EvictionVault smart contract** as part of the **WEB3BRIDGE_CXIV Phase 1 – Day 1 Milestone Eviciton Challenge**.

The goal of this challenge is to transform an insecure **monolithic smart contract** into a **modular and secure architecture**, while mitigating critical vulnerabilities and validating functionality through Foundry tests.

---

# Project Overview

The original `EvictionVault` contract combined multiple responsibilities in a single file - making it monolithic, the original file includes the below and it is stored in the **TaskContract Folder**:

- Vault deposit and withdrawal management
- Multisignature governance transactions
- Merkle-based reward claims
- Emergency administrative controls
- Pause / unpause functionality

This repository demonstrates a **refactored implementation** that improves maintainability, security, and auditability.

---

## Project Structure

```
.
├── src
│   ├── EvictionVault.sol
│   └── modules
│       ├── VaultStorage.sol
│       ├── VaultCore.sol
│       └── VaultGovernance.sol
│
├── test
│   └── Vault.t.sol
│
├── foundry.toml
└── README.md
```
---


# Security Fixes Implemented as Required

Several critical vulnerabilities present in the original contract were addressed.

## 1. Removal of `tx.origin`

### Fix

Replaced with `msg.sender`.

---

## 2. Unsafe ETH Transfers

The contract previously used `.transfer()` for ETH transfers.

### Risk

`.transfer()` limits gas to **2300**, which can break interactions with smart contracts.

### Fix

Replaced with the recommended low-level call pattern:
(bool success, ) = payable(recipient).call{value: amount}("");
require(success);

## Testing

Basic positive tests were implemented using Foundry.

### Test File
- test/Vault.t.sol
### Test Coverage and Description
- Deposit	Verifies users can deposit ETH into the vault
- Withdraw	Ensures users can withdraw their balance
- setMerkleRoot	Confirms only owners can update the Merkle root
- Emergency Withdraw	Validates owner-only emergency withdrawal

### Run tests with:

forge test

## Installation & Setup

### Clone the repository:

- git clone https://github.com/OperaCode/Modularised_VaultEviction_Contract.git
- cd Modularised-Eviction-Vault-Challenge

### Install dependencies:

- forge install


### Compile the smart contracts:

- forge build

### Run Tests
- forge test
## Tools Used

- Solidity

- Foundry

- OpenZeppelin Contracts(library)


### Author

Raphael Faboyinde

Full-Stack Developer & Blockchain Engineer
Focused on building secure and scalable Web3 systems.

### License

 MIT