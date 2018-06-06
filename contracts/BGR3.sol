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
    bytes modulus0 = hex"ca89ec13412767301b2eb54cf9fc7dad4de078032f525d7ce4bc35ce0b1f1908461c18aa5735e500b84365f7b106e105d54b85374a4131c710603ea9e3f07845b3f5065a1b443751d73f2acbb7c08c81648b6dad830528363952dae6ea343f6af23121d8d57020ca945648341462ec6b8e5dce074dfd62b97d4286a71365b8ef631d63b10420525b9455800a93562431a928066dbaffa88b151d61c416edf0c9ec4bcad010797662da1bfcff9dd7e8d407fe5bf5ff3d8c6e12c5e7bb19db3f264fcefc518bae83c36c83d06ab758b1e4bed1292f93efb6054b9893c5b4f696a3146fe21cc74b022c45e21919ba74c701936391ba2b0db95c577871d20170f71b";
    bytes modulus1 = hex"b439b256cbb19e8f576a24d1ac8a0b0bea9df334972a4474b4443b4d75fd9d0fb8b223ec2a1dda9e0e8a03c40a5dd7e38f68a10aec21ea59016443f22cecb745c79b1271f332bfc39da2c4cedb77c0882859cf23f69852c3a8b633d68ba397f1ec73bcfd55ba8f815c3d30a0e33ee8ff78cd5f39fcb6890eb101a191fc564ddafa034dea6826c8f6fdc0fe1dbd5b31b18a321bb84806db147a979b2330b26fe58b010712535c72ad1d4b430c9d4ef71eba2cfadafe64f07363d15b1b68638d071928efa968c813236a811ff594c4be79bf5166f7d895169572b7ddb4f44dac05694668fc4de187e8525ecb7174712e82d025bbe37f464139b8e8d16f3112a5a3";
    bytes modulus2 = hex"acf04f885d217fc6f9569d1c4f0f7a21f5717959744def11a42c3081b0338296c1c7243fdaf0345cef2d0035bf77d92df93314c600744cb11ec8449d1123f4f33de9bb841a8f63e6bc536ba696b5ab166e1474b3520df664e716ca285ea4c6eb349a1a189ac6c56ee060843f7cf2b2f2b3b909521d6ce35cb3337349ea82290d9e5f6357c48bda76030938ecea3002cf40b39ce73842ba52a37fdf052e21acc3133998dfd35a24fc76ed14203a0579ab84ed8896908b677d7e341609ba9c7220f286c6fc326cdb05b67f644920036aca9605d104d3d99622bbed58207b1a1c9a72a500d2aef4a859af57fe1d0dbeb7150a7c4f3284adc40afa7d3761bef147d9";

    function verify(bytes data, bytes x, bytes32 h, bool[] b, bytes16[] r) returns (bool) {
        bytes memory x_prev = x;
        bytes32 h_prev = h;

        for (uint i = n_signers - 1; i > 0; i--) {
            //Line 2, 3 and 4
            x_prev = xorbytes(ghash(h_prev), modexp(split_inverse(x_prev, b[i]), e, getModulus(i)));

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
