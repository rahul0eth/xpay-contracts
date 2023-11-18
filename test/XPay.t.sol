// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { VmSafe } from "forge-std/Vm.sol";
import {Test, console2} from "forge-std/Test.sol";
import {XPay} from "../src/XPay.sol";
import "forge-std/Test.sol";
import "../src/XPay.sol";

// import { ERC1967Proxy } from "../../src/dependencies/proxy/ERC1967Proxy.sol";
// import { TestSetup, ChildrenWithConstructorArgs } from "./common/contracts/TestSetup.t.sol";
// import { AddressLib } from "./common/libraries/AddressLib.t.sol";

contract XPayTest is Test {
    XPay public xpay;
    address godServiceEOA = address(0x7a5717F0B8cAFD96821f419150C4966612FFbbAC); 
    bytes exampleBytecode = hex"60016000556001600055";
    uint256 cost;
    bytes32 messageHash;
    bytes signature;
    uint256 sigTimestamp;
    uint8[] chains;

    function setUp() public {
        xpay = new XPay(godServiceEOA);
        cost = 1 ether;
        sigTimestamp = block.timestamp;
        chains = new uint8[](3);
        chains[0] = 1;
        chains[1] = 2;
        chains[2] = 3;

        // Sign the messageHash with the godServiceEOA private key
        // For the purpose of the test, we're mocking the signature verification
        messageHash = keccak256(abi.encodePacked(cost, exampleBytecode, sigTimestamp, chains));
        signature = abi.encodePacked(godServiceEOA); // Mocked signature for testing purposes
    }

    function testVerifyPayment_Success() public {
        // Mock the transaction as if it's coming from the user
        vm.deal(address(this), cost);

        // Perform the call to verifyPayment and check the event
        vm.expectEmit(true, true, false, true);
        emit XPay.VerifyPaymentEvent(address(this), cost, exampleBytecode, chains);
        xpay.verifyPayment{value: cost}(messageHash, signature, exampleBytecode, cost, sigTimestamp, chains);
    }

    function testVerifyPayment_FailsWhenCostIsLower() public {
        // Mock the transaction with insufficient cost
        uint256 insufficientCost = 0.5 ether;
        vm.deal(address(this), insufficientCost);

        // Perform the call to verifyPayment and expect it to revert
        vm.expectRevert("Insufficient payment");
        xpay.verifyPayment{value: insufficientCost}(messageHash, signature, exampleBytecode, cost, sigTimestamp, chains);
    }

}

