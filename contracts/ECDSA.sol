pragma solidity ^0.4.20;


/**
 * @title Elliptic curve signature operations
 * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
 * TODO Remove this library once solidity supports passing a signature to ecrecover.
 * See https://github.com/ethereum/solidity/issues/864
 */

contract ECDSA {

    //bytes32 hash = hex"852daa74cc3c31fe64542bb9b8764cfb91cc30f9acf9389071ffb44a9eefde46";
    //string message = "TEST";
    //bytes32 hash = keccak256("\x19Ethereum Signed Message:\n", len(message), message);
    bytes32 hash = hex"fb96181ff706848b10a93f4028537caf17026e28ce5c0cce90af46b4d3ad04c6";
    bytes sig = hex"cd044278098c2e5e36cc716423638509bbc818b0daadd7b7bba6322a99de67373255201bac6634b6adeb29d4c3bd9b3a6a14363c4e5b5eb3087c7882c7ebca6800";
    bytes publickey = hex"0485d169380f762e82da692c4b50c8873b1ef9820f15ae6cd96d0d4741056a1b9c828f4f027d0374f22311cba8ceb5845232549e6e4df7ae490b6903a5ee1447be";

    function verificationcost() returns(address)
    {
        return address(keccak256(publickey));
        //return recover(hash, sig);
        //return address addr = address(keccak256(publickey));
    }

    /**
     * @dev Recover signer address from a message by using their signature
     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
     * @param sig bytes signature, the signature is generated using web3.eth.sign()
     */
    function recover(bytes32 hash, bytes sig) returns (address)
    {
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


/*
contract ECDSA {

    bytes publickey = hex"040ee1cd09d77dcbd9c4f78515c5d5091fa5f9633838128e7cf1f3babe5ce840475c845b1fcdbeebdd7c3b7406d54ad61d2cc77a105e5a5e762ee3c83a22af5c56";
    bytes32 hash = hex"852daa74cc3c31fe64542bb9b8764cfb91cc30f9acf9389071ffb44a9eefde46";
    bytes32 r = hex"bbf5cb59e1139f4be32dc3f32f67a5929dc39b1299a9fb5334727603a0fe1798";
    bytes32 s = hex"526344939d5ada61fe2810d7db49558f5322afdb03900e7874e8b8159344492a";
    uint8 v = 0;

    function verificationcost() returns(address)
    {
        address addr = address(keccak256(publickey));

        return ecrecover(hash, v, r, s);
        //return ecrecover(hash, v, r, s) == addr;
    }
}
*/
