// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {VaultStorage} from "./VaultStorage.sol";

// This contract manages administrative and governance functionality for the EvictionVault system.

contract VaultGovernance is VaultStorage {
    event Submission(uint256 indexed txId);
    event Confirmation(uint256 indexed txId, address indexed owner);
    event Execution(uint256 indexed txId);
    event MerkleRootSet(bytes32 indexed newRoot);

    function setMerkleRoot(bytes32 root) external {
        require(isOwner[msg.sender], "not owner");

        require(root != bytes32(0), "invalid root");

        merkleRoot = root;

        emit MerkleRootSet(root);
    }

    // Emergency withdrawal of all ETH stored in the vault to an owner address.
    function emergencyWithdrawAll() external {
        require(isOwner[msg.sender], "not owner");

        uint256 bal = address(this).balance;

        require(bal > 0, "vault empty");

        (bool success, ) = payable(msg.sender).call{value: bal}("");

        require(success, "withdraw failed");

        // Reset vault accounting after withdrawal
        totalVaultValue = 0;
    }

    function pause() external {

        require(isOwner[msg.sender], "not owner");

        require(!paused, "already paused");

        paused = true;
    }

    function unpause() external {

        require(isOwner[msg.sender], "not owner");

        paused = false;
    }
}
