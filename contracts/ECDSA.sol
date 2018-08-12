pragma solidity ^0.4.21;


/**
 * Based on https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ECRecovery.sol
 */

contract ECDSA {

    function verificationcost() public returns (bool) {
        bytes32 message = 0x2b350a58f723b94ef3992ad0d3046f2398aef2fe117dc3a36737fb29df4a706a;
        bytes memory sig = hex"e6ca6508de09cbb639216743721076bc8beb7bb45e796e0e3422872f9f0fcd362e693be7ca40e2123dd1efaf71ebb94d38052458281ad3b69ec8977c8294928400";
        address addr = 0x8e6a1f13a9c6b9443fea4393291308ac4c965b69;

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

    /**
     * toEthSignedMessageHash
     * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
     * and hash the result
     */
    /*function toEthSignedMessageHash(bytes32 _hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
        );
    }*/
}
