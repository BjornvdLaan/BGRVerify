pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGRBig {

   bytes x = hex"2c8b8992f7eee1937afc9c3c9a708faed52aaf463189281058e7d9bf24718efcebc3c4fbc55ecce8b6bcd0a69e479b39df0324b53e1a92395767aa15e651501148b92c8e3ea2def9571a469e9e22fc8463fcfcf7319f6da24ad8578f978b114954edbea9c915236b8fa2fe88addbb571b8a1647ea22b47401e20e48e58f00e997099fecf6dd6791d820346a9313a74be3e77a4fcbf36da840fb29717bb9883504aa3be4b3e7982c32c412429890e53175e6dd263456b352fe36f9d264936ac4d0b18d6e7b448d12e4416e65fa86b1b236e7b9142d794ac747b07ffc4770a0ce2ec26ed298efb58cf72739c98175fd246ec4953ae41fbf29b0e5f9178493dfc21";
    bytes32 h = bytes32(67769612547580043071070140004826438300680680461396437723132034795480894759009);

    bool[] bg = [false, false, true];
    bytes16[] rg = [bytes16(292515598745754236261268930538829626862), bytes16(143732175038022762536275231211399109350), bytes16(155010501534977254474133447094281593683)];


   string[] messages = [
   "MESSAGE 0",
   "MESSAGE 1",
   "MESSAGE 2"
   ];

    //Simulation of PKI
    uint n_signers = 3;
    uint256 constant e = 65537;
    bytes modulus0 = hex"c3f8da94ac41be90e0e4a89720b1ff18ffa4e910415165880e437d6cb36c39aef02a15b83dfbf6a38390d01bdefcfc6886ef922ead9a7b44b51b62008db6b70f50e4a30d33c43622be3bd1fcb29d84d7fb13dbfc1214f829f41875c796dacbb384b297b279aabb633d7fe1186edd2560ea5131f2eefb0c20863866356d4c3c9b53647de6a54e1b1b4c14d714beaf1495cdbf956a741cf0ad56f75b5ea1d81d3d9f36d9243ba7ccc2e21d2019e5b5c7469302cd2f9c3ed764b9ed2fdc9c4297c60f96c07b7ff9c5402c1865b95ff3389a49ace631919e48a19678ae8a4b7d6da6df28c556e75c29a2ef2ddbb31f2e62cc657499c23288df8b90fbc33c42d83ccf";
    bytes modulus1 = hex"ccd3cd5659e9ef107a3678459259bdca6917ce14406365123586795e378b99823912434ce21e6bc435b837c919c25667229423d123b0c57d6d9eacdb5415d896bd26b7b4f94f578bf45d34200f765945bb051cf154e2222e0ef5ba2bc87df22f10cc4f504c9e094d91e135e5d4fef65888d57d284550070824cdcbbe7b1056f67e3c5513777f45490376e35271890f136f961d5d62dfcce3da283d1c2922d15b7235b2eedc4ac212d88b64877463e2e2745159053c8a66e586ab86c90c00614d7321728891e9ad5ffdfc7ee8861d7bab95662eba1623fd1dbf38642f3218a2eea720f3e2660bac1bc76893e3d324edd91449d6af1f18289b305d2ba6f44197d5";
    bytes modulus2 = hex"bda03f516f29b82db329b8485d9e8b661d30f435ef956a36bd7b11f496ff5ea185946d06c606ac4202a33422cf659376f0ed171d8a7e32c3174abbb74052309ef3dc02d690599cd26700792f0bfb7961ef9d78abd76ba4ba3ec9dcb257062e5342f93a182e5beed2fe3768c540299db1bd05f61468b8eba6ce39821451d329b79e8b79511d5bd7f6fb81f1f0cbb876867be3822cd8f61c61116b959548e6119237cfda119c6b940d454fa002c322ddd05faa677ef120cee096231f7c6f27453eaa065b9161b539cacb23cfe16431f4185bf30cb3ecf782a411da855fc4b73bd66d778e5c9dfd77448bc4ffd3ff36309482733a6531a64650c2b495b487e0686b";

    function test(string[] m) returns (string) {
        return m[0];
    }

    function verify(string[] messages, bool[] b, bytes16[] r) returns (bool) {
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
            eta = hhash(getModulus(i), messages[i], r[i], x_prev);

            //Line 6
            h_prev = h_prev ^ eta;
        }

        //Line 7
        bytes32 h_hash = hhashbase(modulus0, messages[0], r[0]);
        bytes memory g_hash = ghash(h_prev);

        bytes memory pig = modexp(split_inverse(x_prev, b[0]), e, modulus0);

        return h_hash == h_prev && equals(g_hash, pig);
    }

    function getModulus(uint i) returns (bytes) {
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
