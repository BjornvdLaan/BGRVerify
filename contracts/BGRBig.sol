pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGRBig {

    bytes x = hex"585f73f1d5810e621e05969a4160712888cc9c236758296fd1d584263c405c7e14f185c6f5901c5b13e0ddb81bcb91e576050db65e2dd76a5d86f95359753fd2382397c6974e418497d4156eacdb30cd42b794d285878224bad681399db3c640964ba688f08ea401473c66d59ee8b625ae6d7d67d6eef6f8fc0cbca9088d68e0e75a5d53c6e68e2bb4a40e9daf882d0f75b99c9484c6b52415d145df839a2651dd1809d93bd27f5f031d9357671bdaf613fb917913ef57e6c8b2a57de0b9e0803c00f4959008e86b3f74078d4e85e1c834db52bd8b620e1e8444628de0d63784086b094fcf7ca7577d7a7a1fcc3c7a0b7d9b108661afde04c790a58768db0789";
    bytes32 h = bytes32(86915515892850825751871111556303678200606133112673033958729217122036233071834);

    bool[] b = [false, false, false];
    bytes16[] r = [bytes16(216513873425860228694659246539921023636)];

    string[] messages = [
    "MESSAGE 0",
    "MESSAGE 1",
    "MESSAGE 2"
    ];

    //Simulation of PKI
    uint256 constant e = 65537;
    bytes modulus0 = hex"c647797c220ae75053bb131ddfd8cb5a37f42e1ac0d34cb93aa88eeb6ce819f4ea028985b5b60c1494b5dca05064e0d18e99f3585f20b9ba6d80cb7e33eb2faebcf91cfef6f7249aee250617f782b37cb1a56d5e75ef56038b04049092ae5219e934ef787200e43876a63b4a395630330f05edc7144debaf023178998f163a8dae4efa83d7ed8feebaeb102d6d4491359b05c92cc1cd72e74e20bcb898f510b2b168c7deaff98176a7e6f49878e67ef72aef5d4ab653d0a60a97db1f425ce44017c4aad0f41de82e873b542777cbf5ecd43e469875109a9c39920b12cb874e796ee747d50e1de1f9b95b4ecc5915b520b53092e153804db749132dd8ce201f07";

    function test() returns (bytes32) {
        bytes memory N = hex"b4d9792443f462b3784cb8a1b48aabc1273e7ad8a419c2e9cfac1adb1c7e03cea7551f0fe98cd74c748a81626b0128827b27e90b2e9315f6faa4f15ec093b8a84cc7c6a90dbfa645b414a3c0f56d9e503a82554a78aa1128d0bf9deb5613171e1563f8e4080fe161fbf89e3bae9f0a2ccf9e787803e5a72d7c0e7c464f7f60ded5be4534cc27bfba9249651a93aaed03b8b7e49f6a1d82e25b6af8825725a16be8af5c611ba872a5f883ab0bc77422afbad68d937df012780cfe041ee369144bae82882ef17e267a77bdb0b79a05a0cdf052bc8277e806aa818fa2a3f5bd39720d5a6a6c85517baafaf5b442e6fbbcbaee386bbe3bf88f2edcebdfb3e15e6cab";
        string memory message = "MESSAGE 0";
        bytes16 r = bytes16(32100592615483184161980556893650132929);

        return hhashbase(N, message, r);
    }

//function verify(string[] messages, bytes32 x, bytes32 h, bytes16[] r, bool[] b) returns (bool) {
    function verify() returns (bytes32) {
        bytes memory x_prev = x;
        bytes32 h_prev = h;

        bytes memory g;
        bytes memory y;
        bytes memory X;
        bytes32 eta;

        /*
        for (uint i = moduli.length - 1; i > 0; i--) {
            //Line 2
            X = split_inverse(x_prev, b[i]);
            y = modexp(X, e, moduli[i]);

            //Line 3
            g = ghash(h_prev);

            //Line 4
            x_prev = xorbytes(g, y);

            //Line 5
            eta = hhash(moduli[i], messages[i], r[i], x_prev);

            //Line 6
            h_prev = h_prev ^ eta;
        }
        */

        //Line 7
        bytes32 h_hash = hhashbase(modulus0, messages[0], r[0]);
        bytes memory g_hash = ghash(h_prev);

        bytes memory pig = modexp(split_inverse(x_prev, b[0]), e, modulus0);

        return h_hash;
        //return  h_hash == h_prev; //equals(g_hash, pig) &&
    }

    function modexp(bytes base, uint exponent, bytes modulus) internal returns (bytes output) {
        //bytes memory modulus = bytes(modulus_str);
        uint base_length = base.length;
        uint modulus_length = modulus.length;

        uint size = (32 * 3) + base_length + 32 + modulus_length;
        bytes memory input = new bytes(size);
        output = new bytes(modulus_length);

        assembly {
            mstore(add(input, 32), base_length)
            mstore(add(input, 64), 32)
            mstore(add(input, 96), modulus_length)

            mstore(add(input, add(128, base_length)), exponent)
        }

        memcopy(base, 0, input, 96, base_length);
        memcopy(modulus, 0, input, 96 + base_length + 32, modulus_length);

        assembly {
            pop(call(gas(), 5, 0, add(input, 32), size, add(output, 32), modulus_length))
        }
    }

    function split_inverse(bytes xi, bool bi) internal pure returns (bytes) {
        if (bi) {
            xi[0] = byte(0);
        }

        return xi;
    }

    //not implemented yet
    function ghash(bytes32 y) internal pure returns (bytes) {
        return hex"c96b966f08643fcb17d438dc949c746817ec9fae47bc4917b5f66c8d55f6902683fb760490ab181af74c0fd52a5bf492e338871e3e209014ad8ca4308569c1b2a7db5bdceb676b7a244565dd466234dde9ec0d3922c8defcff9d348c20e140fc23239ff9d65e9828022f0fb58d804d84a76b527ab4e87e2f83816d158ea18a206195a9d4025b948fd26cbd98c756229d6670c7c461ba68e4dca6bbcbb1ea745019d2bff4728f3b6ff2734e42843c1a548909952aebe5003efe418d315cec58ce6a906e01ba33c11505f79a451fc21d3f50b78719d455e2691e2cf818298879fbe6ea93eca4aa7562834e39eb5835f16aec4427cf8e71d3dcefb62a6bd9fda18b";
    }

    function cut(bytes i) internal pure returns (bytes32 part1, bytes32 part2, bytes32 part3, bytes32 part4, bytes32 part5, bytes32 part6, bytes32 part7, bytes32 part8) {

        assembly {
            part1 := mload(add(i, 32))
            part2 := mload(add(i, 64))
            part3 := mload(add(i, 96))
            part4 := mload(add(i, 128))
            part5 := mload(add(i, 160))
            part6 := mload(add(i, 192))
            part7 := mload(add(i, 224))
            part8 := mload(add(i, 256))
        }
    }

    function xorbytes(bytes a, bytes y) internal pure returns (bytes) {
        bytes32 c1;
        bytes32 c2;
        bytes32 c3;
        bytes32 c4;
        bytes32 c5;
        bytes32 c6;
        bytes32 c7;
        bytes32 c8;

        assembly {
            c1 := xor(mload(add(a, 32)), mload(add(y, 32)))
            c2 := xor(mload(add(a, 64)), mload(add(y, 64)))
            c3 := xor(mload(add(a, 96)), mload(add(y, 96)))
            c4 := xor(mload(add(a, 128)), mload(add(y, 128)))
            c5 := xor(mload(add(a, 160)), mload(add(y, 160)))
            c6 := xor(mload(add(a, 192)), mload(add(y, 192)))
            c7 := xor(mload(add(a, 224)), mload(add(y, 224)))
            c8 := xor(mload(add(a, 256)), mload(add(y, 256)))
        }

        bytes memory merged = new bytes(256);

        uint k = 0;

        for (uint i = 0; i < 32; i++) {
            merged[k] = c1[i];
            k++;
        }

        for (i = 0; i < 32; i++) {
            merged[k] = c2[i];
            k++;
        }

        for (i = 0; i < 32; i++) {
            merged[k] = c3[i];
            k++;
        }

        for (i = 0; i < 32; i++) {
            merged[k] = c4[i];
            k++;
        }

        for (i = 0; i < 32; i++) {
            merged[k] = c5[i];
            k++;
        }

        for (i = 0; i < 32; i++) {
            merged[k] = c6[i];
            k++;
        }

        for (i = 0; i < 32; i++) {
            merged[k] = c7[i];
            k++;
        }

        for (i = 0; i < 32; i++) {
            merged[k] = c8[i];
            k++;
        }

        return merged;
    }

    function hhash(bytes modulus, string message, bytes16 random, bytes x_prev) internal pure returns (bytes32) {
        return keccak256(modulus, message, random, x_prev);
    }

    function hhashbase(bytes modulus, string message, bytes16 random) internal pure returns (bytes32) {
        return keccak256(modulus, message, random);
    }

    function memcopy(bytes src, uint srcoffset, bytes dst, uint dstoffset, uint len) pure internal {
        assembly {
            src := add(src, add(32, srcoffset))
            dst := add(dst, add(32, dstoffset))

        // copy 32 bytes at once
            for
            {}
            iszero(lt(len, 32))
            {
                dst := add(dst, 32)
                src := add(src, 32)
                len := sub(len, 32)
            }
            {mstore(dst, mload(src))}

        // copy the remainder (0 < len < 32)
            let mask := sub(exp(256, sub(32, len)), 1)
            let srcpart := and(mload(src), not(mask))
            let dstpart := and(mload(dst), mask)
            mstore(dst, or(srcpart, dstpart))
        }
    }

    function equals(bytes memory self, bytes memory other) internal pure returns (bool equal) {
        if (self.length != other.length) {
            return false;
        }

        uint addr;
        uint addr2;
        uint len = self.length;

        assembly {
            addr := add(self, /*BYTES_HEADER_SIZE*/32)
            addr2 := add(other, /*BYTES_HEADER_SIZE*/32)
            equal := eq(keccak256(addr, len), keccak256(addr2, len))
        }
    }

}
