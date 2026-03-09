// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import {Test} from "forge-std/Test.sol";
import {EvictionVault} from "../src/EvictionVault.sol";


contract VaultTest is Test {

    EvictionVault vault;

    address owner1 = address(0x123);
    address owner2 = address(0x456);

    function setUp() public {

        address[] memory owners = new address[](2);
        owners[0] = owner1;
        owners[1] = owner2;

        vault = new EvictionVault{value: 1 ether}(owners, 2);
    }

    function testDeposit() public {

        address user = address(0x789);

        vm.deal(user, 1 ether);   // fund user

        vm.prank(user);
        vault.deposit{value: 0.5 ether}();

        assertEq(vault.balances(user), 0.5 ether);
        assertEq(vault.totalVaultValue(), 1.5 ether);
    }

    function testWithdraw() public {

        vm.deal(owner1, 2 ether);  // fund owner

        vm.prank(owner1);
        vault.deposit{value: 1 ether}();

        vm.prank(owner1);
        vault.withdraw(0.5 ether);

        assertEq(vault.balances(owner1), 0.5 ether);
    }

    function testSetMerkleRoot() public {

        vm.prank(owner1);

        vault.setMerkleRoot(bytes32(uint256(1)));

        assertEq(vault.merkleRoot(), bytes32(uint256(1)));
    }

    function testEmergencyWithdrawOwner() public {

        vm.deal(owner1, 2 ether);  // fund owner

        vm.prank(owner1);
        vault.deposit{value: 1 ether}();

        vm.prank(owner1);
        vault.emergencyWithdrawAll();

        assertEq(address(vault).balance, 0);
    }
}