// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./VaultStorage.sol";

contract VaultGovernance is VaultStorage {

    event Submission(uint256 indexed txId);
    event Confirmation(uint256 indexed txId, address indexed owner);
    event Execution(uint256 indexed txId);
    event MerkleRootSet(bytes32 indexed newRoot);

    function setMerkleRoot(bytes32 root) external {

        require(isOwner[msg.sender], "not owner");

        merkleRoot = root;

        emit MerkleRootSet(root);
    }

    function emergencyWithdrawAll() external {

        require(isOwner[msg.sender], "not owner");

        uint256 bal = address(this).balance;

        (bool success,) = payable(msg.sender).call{value: bal}("");

        require(success);

        totalVaultValue = 0;
    }

    function pause() external {

        require(isOwner[msg.sender], "not owner");

        paused = true;
    }

    function unpause() external {

        require(isOwner[msg.sender], "not owner");

        paused = false;
    }
}