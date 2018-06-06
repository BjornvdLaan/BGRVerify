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
    bytes modulus0 = hex"a4c78dbbd8eb4037580a181a202112c050003445447a85d746864da969f32699d506dd025c23d326df89c674d9ae829ec5e0bda38f9dcd3e758f8e349192fb18f4bb932eed9adcaa34290deb2890c0a6856244e479af545d6a20ae3335e28e69e687545aff968173ccb1a6b90dec68d1c118fd625e55f186761b09ac9ee4494562b2f072710a07cef9caaa7197c517051619e452490c105c7d270479b21d9859499838ccecef9fdb9b60862bdb114d46c949b261bcecb8ff7a6613d9a794168ae8c17bdf58097703fdb829dd4ca14e50a6826f7e8f2f59c2c4b50de914d301e5a79e5587dc9f8e106ab91d9686e781bf32aba1969bfad0a30507a31da5d79603";
    bytes modulus1 = hex"cea10cdeb393f9ad1d513b7b63418759030d375cd209eefae1ef32952bd8d769dbbdef56c27363a63eacc7b097733a8f19ff6efd6ac07e4bcbd3d2603859a56b39abd553ac1c8ec71a5f1a55954b52c0e7ea02e0bf10abe922807aedb3741bb0aa8ff785c0060f54fb5c524177a33d5e6ba3691f626a543c9703267c1a3d26a7fb3d093699482a06d3db431e40213d497652f2498b04a71cf061587dd49265eb6d5443c6a0b32d5d4bb2bb06fd42f46eba6a3d5366d8909f40975aef4713b08488938f5f834b4f19f1dba5fb2c527b7f17c45a0305237044446f2b0d4ae579c9c005fa9467eb698888c3aeae551589b6d47c738f388e9451d55cbf6b18cb1f6b";
    bytes modulus2 = hex"c7a535c575242dce4348529aefd812907f97bf7e009cedb89a1c820e14ebd9d2795f5dd961991eb84c727843691ff7a2c82ed2e247bfd6ae7d1bb1628c127968433c1152e1adabfe3cf092622e12e8e9d521caeddc94b1d0d34dd8788679ee7dbb46c17960a117bf0456a9619fddefbf3a3b1e7e6a2419106365341b78ecce97c3d1926276dbf320fae73fbb6940914425fcfdf8a6b194321cc88c345ab1c4e89aadf27e87679bd21e1f2ad62c031f9bcaec2c6f52006f48cdee160709b712c767f7ff931c77a5b9840830806f012c75971cf6ef91be0e72d274b8ba1f52230c447497dce37c751d10c5711373faae17db5fc19039675776696f3a66433bfbfb";

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

        for(uint i = 1; i < 256; i++) {
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
