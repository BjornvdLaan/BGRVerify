pragma solidity ^0.4.24;


/**
 * Solution from https://ethereum.stackexchange.com/questions/55474/verification-of-externally-created-ecdsa-signatures-in-solidity/55487#55487
 * Helper methods from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ECRecovery.sol
 */

contract ECDSA {

    /**
    This method is used to measure only the transaction costs
    */
    function transactioncost(bytes msgs, bytes sigs) returns (bool) {
        revert();
    }

    /**
   This method is used to measure only the storage costs
   */
    mapping(uint32 => bytes) msg_storage;
    mapping(uint32 => bytes) sig_storage;
    function storagecost() {

        uint32 n = 10; //NOTE: change this parameter to set the number of messages signatures that will be stored

        for (uint32 i = 0; i < n; i++) {
            msg_storage[i] = message0;
            sig_storage[i] = signature0;
        }
    }

    /**
    This method is used to measure only the verification costs
    */
    function verificationcost() {
        uint n = 10; //NOTE: change this parameter to set the amount of signatures that will be verified

        for (uint32 i = 0; i < n; i++) {
            verifyTest();
        }
    }

    function verifyTest() public returns (bool) {
        bytes32 message = ethMessageHash("TEST");

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
