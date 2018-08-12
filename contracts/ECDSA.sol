pragma solidity ^0.4.24;


/**
 * Solution from https://ethereum.stackexchange.com/questions/55474/verification-of-externally-created-ecdsa-signatures-in-solidity/55487#55487
 * Helper methods from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ECRecovery.sol
 */

contract ECDSA {

    /**
     * toEthSignedMessageHash
     * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
     * and hash the result
     */
    function toEthSignedMessageHash(string message) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(
            "\x19Ethereum Signed Message:\n32", keccak256(message)
        );
    }

    function verificationcost() public returns (bool) {
        //bytes32 message = 0x2b350a58f723b94ef3992ad0d3046f2398aef2fe117dc3a36737fb29df4a706a;
        bytes32 message = toEthSignedMessageHash("TEST");

        bytes memory sig = hex"bceab59162da5e511fb9c37fda207d443d05e438e5c843c57b2d5628580ce9216ffa0335834d8bb63d86fb42a8dd4d18f41bc3a301546e2c47aa1041c3a1823701";
        address addr = 0x999471bb43b9c9789050386f90c1ad63dca89106;

        return recover(message, sig) == addr;
    }

    /**
     * @dev Recover signer address from a message by using their signature
     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
     * @param sig bytes signature, the signature is generated using web3.eth.sign()
     */
    function recover(bytes32 hash, bytes sig) internal returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        // Check the signature length
        if (sig.length != 65) {
            return (address(0));
        }

        // Divide the signature in r, s and v variables
        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }

        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return (address(0));
        } else {
            // solium-disable-next-line arg-overflow
            return ecrecover(hash, v, r, s);
        }
    }
}
