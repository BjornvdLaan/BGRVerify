pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGRBig {

    bytes x = hex"0a6b001601d88e4ef03dce9243eb59c0980c707f1056b025af99c68918167697cd486b818e3bda3a6421cd66e5bc5743bf3bc1db6dd41026720740bc78465b5b3b20f489dd2f993371e6a09ad86db50256df8d14856dc3bb8448f23f7995334b0721ac307d6673fad215d3f7ece97949cd083c598f8cf7beb557fd51f73a262aac5f71682280301340b6d5137d5f52cf0531ea4322d583f7e6bd338393570411645e7bf76bc4b9a9a8eb8324f05a62275066455a7e33b1659cfcb80771fceb3bb560a8b966f2cd0996eccd77f8904d6ea65642e9c59b7fafe42a7df190e9770018fe54a6db71074f4e1fdd834eff5273d7c57c1e4273158e87ff880557a14c08";
    bytes32 h = bytes32(34728111999442579394121245794230435665718566430100006988781986548790054759983);

    bool[] b = [false, false, false];
    bytes16[] r = [bytes16(26309366502006550357235258682065421591), bytes16(107860851480858833765813351312914261922)];

    string[] messages = [
    "MESSAGE 0",
    "MESSAGE 1",
    "MESSAGE 2"
    ];

    /*
        TODO:
        - Betere oplossing voor moduli
        - testen met de splits
    */

    //Simulation of PKI
    uint256 constant e = 65537;
    bytes modulus0 = hex"d2264650bddeeb673c103af54ea8427b10f9ae12174168216ddb611b0c2e07c8d35fa3a8e110102a50183006d085925adeb6c3d8e234407601d098e5cef3649eebabcb55eebe4b2a7cb79278de0fcf5f6f93379a7ad631d1962fbd7166e9a4722c453ffcfacc7e69f9049e144d5d4a7f486fa7beb68afaf710633ea77b40f75ecc29f9a94594b89368de81cc6381f5054131e546634ebe2943b588344be75907817d5d6b46240c2e7be86e3fc8993209a05ac47d0e48a160c0c9cd0e0ef3e45ac8324d77d6772be05834ca05e9d60997af9a4042619b2afcd81299cd85ce0f43a8892fe0b027ec82c152f20a3ae43b0fb754c6d94cf622abfc3fdbbc30ed9117";
    bytes modulus1 = hex"d80e31c5ccb3ed3661803eedb1bc701f3726b4628c66098d7c7ec0ec39645f8c0c50fb166160ed9ede5074cff7040082590994bf599f04976d7792ee5b47f5a89318fc8ed290eb8cd754861107ca4030ff7618294cef4a8bcbcc8cc5e6ea590ee96a2b196827ae9aab14a64d2f6a2315cf329d43778339d2e3788ee125ed25a6dbc52f505749fa7329e96e228270aa1ca6ac659c91fc3383116f85b107c86e2ba5099c100ec77717beda0c1bc645a1e070a0bcfecb56c042d76a072880957ae0c9b6786ca074527eacbb2b936571d4fa17345b0e277eae2fb767afb6b7917648262916e8a956b0b64db3cc25c01d69bd03e0836de169f7f3f0771081fc001377";

    function test() returns (bytes) {
        bytes32 hash = keccak256(h);
        bytes memory res = hex"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

        for(uint i = 32; i < 256; i++) {
            res[i] = hash[i % 32];
        }

        return res;
    }

    function verify() returns (bool) {
        bytes memory x_prev = x;
        bytes32 h_prev = h;

        bytes memory g;
        bytes memory y;
        bytes memory X;
        bytes32 eta;

        for (uint i = 1; i > 0; i--) { //moduli.length - 1
            //Line 2
            X = split_inverse(x_prev, b[i]);
            y = modexp(X, e, modulus1);

            //Line 3
            g = ghash(h_prev);

            //Line 4
            x_prev = xorbytes(g, y);

            //Line 5
            eta = hhash(modulus1, messages[i], r[i], x_prev);

            //Line 6
            h_prev = h_prev ^ eta;
        }

        //Line 7
        bytes32 h_hash = hhashbase(modulus0, messages[0], r[0]);
        bytes memory g_hash = ghash(h_prev);

        bytes memory pig = modexp(split_inverse(x_prev, b[0]), e, modulus0);

        return h_hash == h_prev && equals(g_hash, pig);
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

    function ghash(bytes32 y) internal pure returns (bytes) {
        bytes32 hash = keccak256(y);
        bytes memory res = hex"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

        for(uint i = 32; i < 256; i++) {
            res[i] = hash[i % 32];
        }

        return res;
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
