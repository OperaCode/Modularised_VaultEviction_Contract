// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "./VaultStorage.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract VaultCore is VaultStorage {

    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed withdrawer, uint256 amount);
    event Claim(address indexed claimant, uint256 amount);

    receive() external payable {
        balances[msg.sender] += msg.value;
        totalVaultValue += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function deposit() external payable {

        balances[msg.sender] += msg.value;

        totalVaultValue += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {

        require(!paused, "paused");
        require(balances[msg.sender] >= amount, "insufficient");

        balances[msg.sender] -= amount;

        totalVaultValue -= amount;

        (bool success,) = payable(msg.sender).call{value: amount}("");

        require(success);

        emit Withdrawal(msg.sender, amount);
    }

    function claim(bytes32[] calldata proof, uint256 amount) external {

        require(!paused, "paused");

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