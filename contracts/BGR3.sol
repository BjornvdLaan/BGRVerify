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
    bytes modulus0 = hex"eaf7bd0282869c00e714a274a1b09c1f356ef55474cbea696909e600b7626d7bb37e984907c54ecf3a11bc09fe9d3e1392fb561e42ba76044722e2ce1c2deb0f1d46a375416b4f040f36b16a82aba0b810398175469699e0f62ba07c56b25352e0ed761aef5397d08e2b389c9b5e65a8124d0ab3e7fac7e9100b7a5d3e852548fb208a05157fd90e3c9a4db6f73b0c870095a89b58452a908704d768b2c8512b6c667d1498d4fd17620c52013ea91ea19da68da07a6ed5e44ab8b903ca1a2abe938e9d075447eab3dc723fc8859bf80a87d742ed15cb59353f4c505d24dd5985725951ee8eb00878901cd817767436b8fbc8eebccbe2291be2c3b1207a26f5fb";
    bytes modulus1 = hex"c7a740ca25a2512ac6b114da92669d356e7d12e3e5da2a9a99d68479e44b7cde46f1c9d0ba64bd49c444ccf190f94964b66fe29725abcd734955813689fc7542b5d4c3ffca665ad5171cabb2d5d75bf72a28dee8b646c01b3437464b42245fb07a1083886f6c4fddff173fb8651db617448b77959e2ca4e80699bf865b5665ae028d5868d6d6ae252e9afcbd060213772da7e7a74094c1555cd8fae676defe98759e21d4666baf41fce2ae7aaa1c85e966cd180d144769930a2fc3d9d20befa575c72432ef306f6f473a4b31f7a0941b220573cd3812e4f7375de3ea2aade444f1c5c8c8ef73aa3b34ff6e14dfa7cc6c6a78ed5b643fe839dbebd4993719eec9";
    bytes modulus2 = hex"bc01e5ad5675b6b60d7ade455d1a9ee1d2a22d094857032571302f996150031000a6c3339f5c288baa3a6a7d4a8e65b21fd8e82bf2127be63cb7012936be3141fe499bc6400e90a8a69e6405ebf466872a3e30813be1393626d78f98a47ef84ded72f66c10f24b2ee1999ebc8f1164389555ab743b006c81dbe02265efc8f4d571fdff91e32252df45350c4f7bbf94a549eb8fc564514f846552b4d08bf137c7615a6bb91e7e1e97e6101a257c1f1b1b3da2e86f758467521d14628108d88cdb497393359b6b1acbe1769e04005cf80071e9291acbcbd7f73819335b794b41bbbcf5fc7afcb174a8d0da8f592b7e2657edd55250c0c8def7886ac30c575d585f";

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

        for(uint i = 32; i < 256; i++) {
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
