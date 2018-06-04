pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGR2 {

   string[] messages = [
   "MESSAGE 0",
   "MESSAGE 1"
   ];

    string[] labels = [
    "example.com/api/0",
    "example.com/api/1"
    ];

    //Simulation of PKI (assumed to be available)
    uint n_signers = 2;
    uint256 constant e = 65537;
    bytes modulus0 = hex"b19d36f8310c348e9259fd5183203f246555d553c016780f078be4c0ac88c1fa0204c139127144f98345172bcb38a5c427151181f16ff0fb813a7916414fcbd109b4bfa727be3217050ed1b6616b13763970ddb221b1da5b42d9af47dd011e7baab476346c457d4e162b9164d882d52b7432da5b36a626d6e5a48d8cb1651699ed1b2e8eab6f6506299c12b70fc1dc881b6e047709de4ee22b4bdf453b326e10aa66d2e592bba29d4d56802fbcd82a35df449c6cfee27c2ade4dcc17c1734d4e1d7b4148d627bde666183002237277ddc3b101a5eaaae74bf233b44aabd123837f5917c4bafd32cd909f17e87b36f6bf48d571bc462e89b168fbfd78f456974b";
    bytes modulus1 = hex"f36c73623e747579ffd41fab95cf3b595c2118605ff4130d9e027c5f48016cb25b24d979cffc680bed9ef9863377cca5ae0488ffaceab694829f4e0faf7b5f3dc5633ba0da7684ba6876e9326bf70c890a2ae3285905add3d29a14b576bd0cc815fbca5a19cc94bb823ec268ee845d06d842ec3aa91db51222c401582fc0f1d3a83f608d61adbccf2525a7e306d3ef7805e4f3195333e170ddbbe197b236036c2fcbc5997d33f29e30d797cbddb03d8571b4cadf45e10ef9194350fc3ad6f9b910089395fcb7ed5e03ac1c6134cbb70583317a936a10ab20a313b889eac7f2607330c31ecefe9a98b3ebb2c4bc8786ee022782c5e380021ee578119b4d11e603";

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
        }
    }

    function modexp(bytes base, uint exponent, bytes modulus) internal returns (bytes output) {
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
