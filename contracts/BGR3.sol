pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGR3 {

   string[] messages = [
   "MESSAGE 0",
   "MESSAGE 1",
   "MESSAGE 2"
   ];

    string[] labels = [
    "example.com/api/0",
    "example.com/api/1",
    "example.com/api/2"
    ];

    //Simulation of PKI (assumed to be available)
    uint n_signers = 3;
    uint256 constant e = 65537;
    bytes modulus0 = hex"c97f08c69eee071a13c6c842ed7a9746deaebdf060124a6d4f7ef9c66f627c49c59b0f2d83ef96d3e633372373874d498ee63ae04020a7d40faa8eecf6fa812d8048c6c7a5572b304d72387af9bed8d5dfc30b137885e9696b59e91c6ff4d4621c0380f292fe634a303fc9bc74939e8fa583000c202b839c4df7cde2e639e4a32e461dc48fbfe420be1fe7c66c005db9703779bfd3cd9efff4c2ef5c5ba25444d7ecd6e20e72a01b8dbd6ddbd53b0d537502473e0c25d96a9500bbca23a894155da7525ea32af6f859b3c840c13e5cfcfd2c4974f900102fbd0e138aa8ba5c8ee453295f4c516be99678422379e7f47c6189d0347927195298ea92476f421401";
    bytes modulus1 = hex"ef0a34bf20e43feed40c9f9af94395e32a37557f607b07947f26503b11acdd860e00ae0a3a342642c176c4f2d6c3895b36a1ddf2501c320b97cc09a59695b24da24a59e0ccbcb475c0f125331f9c6f255fe65d0fb5bd464204e70faeac4b684569af2b910f612ba788f6d5dae2ec96e856d0bb74586c59d9be67cc565e9791a8592739abc975d0e930c16435e70995691af5f305edab3266fcdf73033ca47918d4ac3feb3f3369882c548715c736cf07b4d681cf4a33a6919bde11375bb0d756068fce25e7f1b5af9e52116906cfb25ff57c0fc7e9edaf5961a31a6a92b9b55a8772cd0cf4ca8dbbe0bea719567306d53e49d96154604df57864dc1e88e3905f";
    bytes modulus2 = hex"e08ae6fe107265134d5f580d1fe87f2d8b5bc3572de762a2fd595a291283937462f31d6d14ff834fc4eff8f8b53887875e7ec445ea31efd98bdc8a46a951f931486dff1904d461f43b8236a76360fb9d81af994f54491e0a6837c2f63a4248140d6e8c73ac602fe9be2f902f7338b417868ead037c93227975effa03a5e2a5762b89b75e4bc7287d22b19bd00f16851ee3db13bb97f07c1e291dfebcbff9f7d6876dba5ad828b97ae5ce60366c683bb4dbf5d4f7b1c995be28a6c4ad65d4897a5004340fcd7852210121257f1cb9170ab6c631cefe980f7c44e836c5b9afad423c76f58a826b768feb6a95aaf411dd418de3eaf578f156e97a187fba6179036d";

    function verify(bytes m, bytes x, bytes32 h, bool[] b, bytes16[] r) returns (bool) {
        bytes memory x_prev = x;
        bytes32 h_prev = h;

        bytes memory g;
        bytes memory y;
        bytes memory X;
        bytes32 eta;

        for (uint i = n_signers - 1; i > 0; i--) {
            //Line 2
            X = split_inverse(x_prev, b[i]);
            y = modexp(X, e, getModulus(i));

            //Line 3
            g = ghash(h_prev);

            //Line 4
            x_prev = xorbytes(g, y);

            //Line 5
            eta = hhash(getModulus(i), messages[i], labels[i], r[i], x_prev);

            //Line 6
            h_prev = h_prev ^ eta;
        }

        //Line 7
        bytes32 h_hash = hhashbase(modulus0, messages[0], labels[0], r[0]);
        bytes memory g_hash = ghash(h_prev);

        bytes memory pig = modexp(split_inverse(x_prev, b[0]), e, modulus0);

        return h_hash == h_prev && equals(g_hash, pig);
    }

    function getModulus(uint i) view internal returns (bytes) {
        if (i == 0) {
            return modulus0;
        } else if (i == 1) {
            return modulus1;
        } else if (i == 2) {
            return modulus2;
        }
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
            xi[0] = byte(uint(xi[0]) + 128);
        }

        return xi;
    }

    function ghash(bytes32 y) internal pure returns (bytes) {
        bytes32 hash = keccak256(y);
        bytes memory res = hex"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

        for(uint i = 0; i < 256; i++) {
            res[i] = hash[i % 32];
        }

        return res;
    }

    function hhash(bytes modulus, string message, string label, bytes16 random, bytes x_prev) internal pure returns (bytes32) {
        return keccak256(modulus, message, label, random, x_prev);
    }

    function hhashbase(bytes modulus, string message, string label, bytes16 random) internal pure returns (bytes32) {
        return keccak256(modulus, message, label, random);
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
