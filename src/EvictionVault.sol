// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import {VaultCore} from "./modules/VaultCore.sol";
import {VaultGovernance} from "./modules/VaultGovernance.sol";

contract EvictionVault is VaultCore, VaultGovernance {

    constructor(address[] memory _owners, uint256 _threshold) payable {

        require(_owners.length > 0, "no owners");

        threshold = _threshold;

        for (uint i = 0; i < _owners.length; i++) {

            address o = _owners[i];

            require(o != address(0));

            isOwner[o] = true;

            owners.push(o);
        }

        totalVaultValue = msg.value;
    }
}