pragma solidity ^0.4.24;


/**
 * Solution from https://ethereum.stackexchange.com/questions/55474/verification-of-externally-created-ecdsa-signatures-in-solidity/55487#55487
 * Helper methods from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ECRecovery.sol
 */

contract ECDSA {

    bytes message0 = hex"7b0a2020226f70656e223a207b0a20202020227072696365223a2039353931372c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333134323430302c0a2020202020202269736f223a2022323031362d31322d33315430303a30303a30302e3030305a220a202020207d0a20207d2c0a202022636c6f7365223a207b0a20202020227072696365223a2039363736302c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d2c0a2020226c6f6f6b7570223a207b0a20202020227072696365223a2039363736302c0a20202020226b223a20312c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d0a7d0a6578616d706c652e636f6d2f6170692f31";
    bytes signature0 = hex"f6da5793bcdbb8dba81fcbdba6b1b65121c326e0bc446d3ed8ae43d89b1a9f2b1009f3befd307edd50f6ddafd6c61183156c72658174997ec70aabccc0e6e3c200";
    address address0 = 0xc8bc9062c7b85f0f1feac5e4923b409ad93bd4cb;

    /**
    This method is used to measure only the transaction costs
    */
    function transactioncost(bytes msgs, bytes sigs) public returns (bool) {
        revert();
    }

    /**
   This method is used to measure only the storage costs
   */
    mapping(uint32 => bytes) msg_storage;
    mapping(uint32 => bytes) sig_storage;
    function storagecost() public {

        uint32 n = 10; //NOTE: change this parameter to set the number of messages signatures that will be stored

        for (uint32 i = 0; i < n; i++) {
            msg_storage[i] = message0;
            sig_storage[i] = signature0;
        }
    }

    /**
    This method is used to measure only the verification costs
    */
    function verificationcost() public {
        uint n = 10; //NOTE: change this parameter to set the amount of signatures that will be verified

        for (uint32 i = 0; i < n; i++) {
            verifyTest();
        }
    }


    function verifyTest() internal returns (bool) {
        bytes32 message = ethMessageHashHex(message0);

        return recover(message, signature0) == address0;
    }

    /**
     * @dev Recover signer address from a message by using their signature
     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
     * @param sig bytes signature, the signature is generated using web3.eth.sign()
     */
    function recover(bytes32 hash, bytes sig) pure internal returns (address) {
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
    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:" and hash the result
    */
    function ethMessageHash(string message) internal pure returns (bytes32) {
        return keccak256(
            "\x19Ethereum Signed Message:\n32", keccak256(message)
        );
    }

    /**
    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:" and hash the result
    */
    function ethMessageHashHex(bytes message) internal pure returns (bytes32) {
        return keccak256(
            "\x19Ethereum Signed Message:\n32", keccak256(message)
        );
    }

}
