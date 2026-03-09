// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


// This contract implements the core functionality of the EvictionVault, including deposits, withdrawals, and claims based on a Merkle tree.
import {VaultStorage} from "./VaultStorage.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract VaultCore is VaultStorage {

    event Deposit(address indexed depositor, uint256 amount);

    event Withdrawal(address indexed withdrawer, uint256 amount);
    
    event Claim(address indexed claimant, uint256 amount);
    

    receive() external payable {

        require(msg.value > 0, "zero deposit");

        balances[msg.sender] += msg.value;

        totalVaultValue += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    
    function deposit() external payable {

        require(msg.value > 0, "zero deposit");

        balances[msg.sender] += msg.value;

        totalVaultValue += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {

        require(!paused, "vault paused");

        require(amount > 0, "invalid amount");

        require(balances[msg.sender] >= amount, "insufficient balance");


        balances[msg.sender] -= amount;

        totalVaultValue -= amount;

        (bool success,) = payable(msg.sender).call{value: amount}("");

        require(success);

        emit Withdrawal(msg.sender, amount);
    }

    function claim(bytes32[] calldata proof, uint256 amount) external {

        require(!paused, "vault paused");

        require(!claimed[msg.sender], "already claimed");

        require(amount > 0, "invalid claim");

        // Prevent vault underflow
        require(address(this).balance >= amount, "insufficient vault balance");


        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));

        require(
            MerkleProof.verify(proof, merkleRoot, leaf),
            "invalid proof"
        );

        require(!claimed[msg.sender], "already claimed");

        claimed[msg.sender] = true;

        totalVaultValue -= amount;

        (bool success,) = payable(msg.sender).call{value: amount}("");

        require(success);

        emit Claim(msg.sender, amount);
    }

}