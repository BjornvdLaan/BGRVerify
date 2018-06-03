pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGRBig {

    bytes x = hex"7b49500fca7f1f4aa1da9d04f09d4dc02351dfe01974c97cb9ae78d03c419a19bd69c480a0ece0ee2cb55d9ca33507719058ac03c8c81ee90d1d8313a124949dfef01ee44a1aa1fe8b3a7804eedebea92cfcd79ac1e033dc431c5dd1dca9030704bea183318c80045c709d5266c6b8f46d5216223208b03c349ab257e31080cf2fb7351077c82e366c0a9c465b93dc611ccc6249288982368fd99cb44100b15850b6fe0ffb76451f1cbb562fba1163f05995ea54ab68d3ece8aaa9c4c0bceeefc7a7cc8516dbca2ad51ecc96a0022ef4cd3f085226f9732a2fe200bf9ac94205e199a6da1f8a31b70c7b438d5b851301b4a78dd656e6abe55bd9f677b3874a84";
    bytes32 h = bytes32(50492151890823218821780904290475785556998480300898370025014579691936177640103);

    bool[] b = [false, false, false];
    bytes16[] r = [bytes16(255056192489919999080245718078957014030)];

    string[] messages = [
    "MESSAGE 0",
    "MESSAGE 1",
    "MESSAGE 2"
    ];

    //Simulation of PKI
    uint256 constant e = 65537;
    bytes modulus0 = hex"a6c9b442f07d31c5f7d421412d04a0672c6627bb78cd3d629c2d8a13815d1263ce2a04da9e023ce867bdfad79760861a7b85c54cb47fe4e3d5995cdf1ddd111ba4e48e5402be0921099c41e6bb067c39e4311fd03444be028973425f7385f2138841b08935083a973a2c830d806374541bba92d4360210146ca35828efd9de506f78cbc71419c0e9eda85424d424d54b5f8d1b53e8251b1fc533e36587128c1349c7856f152941853eadd6354dac5b19ee9ce424449f60a5b22006ac48d416852264c4f2f4936915253e9ee53c632348abbe6682aecb9639551145da5a9b5b52fb041dd0672ef389550bf01cc7cfe94be3a3ec0ba0df1132e545d561221a2469";

    function test() returns (bytes) {
        bytes32 hash = keccak256(h);
        bytes memory res = hex"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

        for(uint i = 32; i < 256; i++) {
            res[i] = hash[i % 32];
        }

        return res;
    }

    function verify() returns (bytes) {
        bytes memory x_prev = x;
        bytes32 h_prev = h;


    /*bytes memory g;
    bytes memory y;
    bytes memory X;
    bytes32 eta;*/

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

        return g_hash;
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
