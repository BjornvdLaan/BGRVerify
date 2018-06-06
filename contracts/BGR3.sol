pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGR3 {

    string[] labels = [
    "example.com/api/0",
    "example.com/api/1",
    "example.com/api/2"
    ];

    bytes message = hex"7b0a2020226f70656e223a207b0a20202020227072696365223a2039353931372c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333134323430302c0a2020202020202269736f223a2022323031362d31322d33315430303a30303a30302e3030305a220a202020207d0a20207d2c0a202022636c6f7365223a207b0a20202020227072696365223a2039363736302c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d2c0a2020226c6f6f6b7570223a207b0a20202020227072696365223a2039363736302c0a20202020226b223a20312c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d0a7d0a";

    //Simulation of PKI (assumed to be available)
    uint n_signers = 3;
    uint256 constant e = 65537;
    bytes modulus0 = hex"f5407d119e5e43d17b48e6b441132680009ec0997862d873b8b4345120de55e8ae85529346ec57f526119fb2dbb7d8b83b249799be37a880d6efc04793319b43ec8190ae95ac1654492666406178e8699445d96dd437a6250caf49b61e10817fb9382c5d9c46fc490a631879ba7f111a00a2d135d6608b4fbdae383241cbd4bbf2ec317b292a6121082c4dd48ff8b91c717de3b144f0838e949cb06bddde59a3b34666736dd70ff2714f2af432665efefd4193b7ecf28bc8ba47e56cf29cbaf829e8ddd56261fa9f07f4d8f3af277ece37224cbfd6b4eb2d3e3c9bb08329eff1aa4d9e8b936037244119bd1e7352a18464575cf23e959cffa8c303c47b29aad7";
    bytes modulus1 = hex"c5052db994c14fd03a0805b8124fd4f7ec36a25042b0db447c29545377f6b5ae8b1c8d001774194e1af7665ed62c2b8df15bb93ddeb39cfc2d0a2c19596cc41cd2da65c75c9787a7de80a0a123f910332162580f6f1f51e9723e325c132bac7627a377ffbe3a8d615c8f38596235b22de4b30ba3d51d657f190e5083641866d0e180a230ba3f7d8a784a0ac47bab01896ad2317a312df70d21f82a008899c67a194799442ba42517d51ed2a2b2c538882577fa2690266d3c31e749d3901a1bc430fa3f4191027c7c627930ea16043e1da02908c3f4b9f9cf2a5f4a0ef4e3f8f6e0243176cbe1a48962e1a76149ffb1a576c8ab0ccacabe01bc77224cb27a5e39";
    bytes modulus2 = hex"bda76ec96b85fad66d75c60fd010042ad9d8d4cc7d52adc3540d8e491cacc316de7c8067bfd96f5ef3ce628d35b5acaad357d47f3e2fa3e2211c04b99a53dddf83b56f94c91a2a13e366cfde4f1d724cda23e6433328946a8931e0b4e2f5567d0fc06ca94217c840b96841b32e63b3692fe1e4c83072636b5e2c441ae361028414aa02ad564285306bc322b1765739b5e22bd9206acb55dd67a8abb529f771867e9e326ec8053a399144401dc1db90c3899c5fa5eb4385a36e6193610db7e5903bd010794e5aa0debe4f0ab0d2360faa5f35bf14a5c4079dddb35a4decb4faed268c3f41464249f3d09b6c390ebdd9a5a5b16100df259602e29b7bd64abfa96b";
    
    function verify(bytes m, bytes x, bytes32 h, bool[] b, bytes16[] r) returns (bool) {
        bytes memory x_prev = x;
        bytes32 h_prev = h;

        bytes memory y;
        bytes memory X;

        for (uint i = n_signers - 1; i > 0; i--) {
            //Line 2
            y = modexp(split_inverse(x_prev, b[i]), e, getModulus(i));

            //Line 3 and 4
            x_prev = xorbytes(ghash(h_prev), y);

            //Line 5 and 6
            h_prev = h_prev ^ hhash(getModulus(i), getMessage(i), labels[i], r[i], x_prev);
        }

        //Line 7
        bytes32 h_hash = hhashbase(getModulus(0), getMessage(0), labels[0], r[0]);
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

    function getMessage(uint i) internal returns (bytes) {
        return message;
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

    function hhash(bytes modulus, bytes message, string label, bytes16 random, bytes x_prev) internal pure returns (bytes32) {
        return keccak256(modulus, message, label, random, x_prev);
    }

    function hhashbase(bytes modulus, bytes message, string label, bytes16 random) internal pure returns (bytes32) {
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
