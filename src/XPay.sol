// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {ECDSA} from "./dependencies/cryptography/ECDSA.sol";
import {Ownable} from "./dependencies/access/Ownable.sol";

contract XPay is Ownable {
    using ECDSA for bytes32;

    address public vendorEOA;

    event VerifyPaymentEvent(address indexed user, uint256 paid, bytes bytecode, uint256[] chains);

    constructor(address _vendorEOA) {
        vendorEOA = _vendorEOA;
    }

    // Errors
    error Unauthorized();

    /**
     * @dev Verify that the payment was made by the user and that the payment is sufficient.
     * @param _messageHash The hash of the message that was signed.
     * @param _signature The signature of the message.
     * @param _bytecode The bytecode of the contract to be deployed.
     * @param _cost The cost of the contract deployment.
     * @param _sigTimestamp The timestamp of the signature.
     * @param _chains The chains the contract will be deployed to.
     */
    function verifyPayment(
        bytes32 _messageHash,
        bytes calldata _signature,
        bytes calldata _bytecode,
        uint256 _cost,
        uint256 _sigTimestamp,
        uint256[] calldata _chains
    ) external payable {
        // Verify that the messageHash contains the cost
        bytes32 computedMessageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(_cost, _sigTimestamp)))
        );

        require(computedMessageHash == _messageHash, "Message hash does not match");

        // Recover signer from signature
        if (ECDSA.recover(_messageHash, _signature) != vendorEOA) revert Unauthorized();

        // Verify that the signature is not expired
        // require(_sigTimestamp >= block.timestamp - 2 minutes, "Signature expired");

        // Ensure the sent value is greater than or equal to the cost
        require(msg.value >= _cost, "Insufficient payment");

        // Do the thing

        emit VerifyPaymentEvent(msg.sender, msg.value, _bytecode, _chains);
    }

    /* ****************************************************************************
    **
    **  Admin Functions
    **
    ******************************************************************************/

    /**
     * @dev Allow contract admin to set the vendorEOA.
     * @param _vendorEOA The address of the vendorEOA.
     */
    function setvendorEOA(address _vendorEOA) public onlyOwner {
        vendorEOA = _vendorEOA;
    }
}
