// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {XPay} from "../src/XPay.sol";

contract XPayTest is Test {
    XPay public xpay;

    uint256 public signer = vm.envUint("PRIVATE_KEY");
    bytes32 public constant txHash = 0x252f474661272b6f9a5cef3a5660f313785eb5466aa00b18f5b74ad4b4c96620;
    uint256[] chains;
    bytes public bytecode = hex"60806040";

    // events
    event VerifyPaymentEvent(address indexed user, uint256 paid, bytes bytecode, uint256[] chains);

    function setUp() public {
        xpay = new XPay(0xa2F12d8c05c73b6497DB52E6dD7e988DBbCF7aa3);

        chains = new uint256[](3);
        chains[0] = 1;
        chains[1] = 2;
        chains[2] = 3;
    }

    function test_verifyPayment(uint256 time_delta, uint256 cost_delta) public {
        // Assumptions
        vm.assume(cost_delta <= 1 ether);
        vm.assume(time_delta <= 1 weeks);

        // Params from backend
        uint256 cost = 1000000000000000;
        uint256 sigTimestamp = 1700321388;

        bytes32 messageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(cost, sigTimestamp)))
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signer, messageHash);
        bytes memory sig = abi.encodePacked(r, s, v);

        // Expectations
        uint256 payment = cost + cost_delta;
        vm.expectEmit(true, true, false, true);
        emit VerifyPaymentEvent(address(this), payment, bytecode, chains);

        vm.warp(1700321388 - time_delta);
        xpay.verifyPayment{value: payment}(messageHash, sig, bytecode, cost, sigTimestamp, chains);
    }

    function testFailVerifyPaymentMoney(uint256 time_delta, uint256 cost_delta) public {
        // Assumptions
        vm.assume(cost_delta <= 1 ether && cost_delta > 0);
        vm.assume(time_delta <= 1 weeks);

        // Params from backend
        uint256 cost = 1000000000000000;
        uint256 sigTimestamp = 1700321388;

        bytes32 messageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(cost, sigTimestamp)))
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signer, messageHash);
        bytes memory sig = abi.encodePacked(r, s, v);

        // Expectations
        uint256 payment = cost - cost_delta;
        vm.expectEmit(true, true, false, true);
        emit VerifyPaymentEvent(address(this), payment, bytecode, chains);

        vm.warp(1700321388 - time_delta);
        xpay.verifyPayment{value: payment}(messageHash, sig, bytecode, cost, sigTimestamp, chains);
    }

    // function testFailVerifyPaymentTime(uint256 blockTimeStamp, uint256 cost_delta) public {
    //     // Assumptions
    //     vm.assume(cost_delta <= 1 ether && cost_delta > 0);
    //     vm.assume(blockTimeStamp > 1700321388 + 2 minutes);

    //     // Params from backend
    //     uint256 cost = 1000000000000000;
    //     uint256 sigTimestamp = 1700321388;

    //     bytes32 messageHash = keccak256(
    //         abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(cost, sigTimestamp)))
    //     );
    //     (uint8 v, bytes32 r, bytes32 s) = vm.sign(signer, messageHash);
    //     bytes memory sig = abi.encodePacked(r, s, v);

    //     // Expectations
    //     uint256 payment = cost + cost_delta;
    //     vm.expectEmit(true, true, false, true);
    //     emit VerifyPaymentEvent(address(this), payment, bytecode, chains);

    //     vm.warp(blockTimeStamp);
    //     xpay.verifyPayment{value: payment}(messageHash, sig, bytecode, cost, sigTimestamp, chains);
    // }
}
