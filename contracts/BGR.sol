pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGR {

    string[] labels = [
    "example.com/api/0",
    "example.com/api/1",
    "example.com/api/2",
    "example.com/api/3",
    "example.com/api/4",
    "example.com/api/5",
    "example.com/api/6",
    "example.com/api/7",
    "example.com/api/8",
    "example.com/api/9"
    ];

    bytes message = hex"7b0a2020226f70656e223a207b0a20202020227072696365223a2039353931372c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333134323430302c0a2020202020202269736f223a2022323031362d31322d33315430303a30303a30302e3030305a220a202020207d0a20207d2c0a202022636c6f7365223a207b0a20202020227072696365223a2039363736302c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d2c0a2020226c6f6f6b7570223a207b0a20202020227072696365223a2039363736302c0a20202020226b223a20312c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d0a7d0a";

    //Simulation of PKI (assumed to be available)
    uint256 constant e = 65537;
    bytes modulus0 = hex"cfb816f2802a2f0712795ff0bf5e557dbe22051b165bb59572cc968e54e2d11f2effcd42c2de87c066c48b3e45b1976cdfe0cecc06ce66611995266ac338880597523b8406a6d93b278ebd2198c8815e5a8e275e8f7dc1129eca4ad27e1d1b41aeeacc1f77c9fc4f100dcccd6d0671d54052d771782e5c06144d5d0f13403203c2958a3dba69f8c8a178a5ec9e82c06e69af9ed98502f375b1efa57b2f2a9d2d3b20233d06b62d960d319f1102fdcb6eab142c003410c45e47bbd780d53daa3ed08f5356b174eeaff6ef2370c3315166fecde2c1cd5b4dea99e6d612b7ef436fd3f39999fa15d762fd610e3c35c1f0a5ab42044adf0ab2b43eaa2e8439927a3d";
    bytes modulus1 = hex"993c748cc9038c603b288a48e0c23bf95ebe6a398e75f93b61be08b2410cf68dd9f1a3e4847b01ab3e6ac376474e97f6d4d21fabc31dd871340a657b0adcf89ada9e664114d1673c3a62d12aed027adccaeef28c112e91f76d7ce7c6f603dc6eae170ebe57e0eea617986ca3e48cb24c139f0c2f7406b58de98b65ad3ef9fdc728177d225a363eff1ccd9e8b0672a0457aa25008facb8984d7834c47be9f701ff406adcb4de0eebedd3dc9e3ee6acadbf0a897311e4622a22edc09dacb49e892622ad7f3d9139ed66122c2fad081e4260c38b8697c49012a8e023bb24519d13ba9d6262b9e3922988dc395497e3540c1157eaef83fb0b75a77f7512ea1d634b9";
    bytes modulus2 = hex"d3098e76c3ca004ad6482977e00e65d981f1a0bc9acdf6d6b5ae95b4d2751a47057fa363286aa9039b191268a305b656e4980987be0f6f523bda2cf89765ac5bf2ae0a9c5630af56f21bd97f4e91784183a052932d7a16a4e8ee6e7ae21ad5cb4cd99bfb3167d0ff3fd5376ccaaf4169e4630b623f278019aa03ae79b3516124afe8df70c19c0315034876200f58edf4d83dbf25e60af76f5e97bac967a11f813132ee6e7db6c47c6b75cc30d527c30c04e0ea06c4a784697195d16fa5041cd4cd08e238add5c5149e47a3fd8472363f646786baf1a477f394f2f6e4af7e06e0339aff913f9a0cfbba42e3858a685a66f43dfdfe6885ce5f8d27cbcd773dfed9";
    bytes modulus3 = hex"f659dc051e02f69f4b449e425737c22c263c44c6e4e70c54afbb1148550d907b7ef05880b83fac5d2691a3578955f264a2b9b4343e13fa617a2ff38d1719e55bbe002b5a40bfd00744cd40e5ced0c1981d46243181cd2c3c41b8447c368316b4e62b121ff1a5b49278c5765e44c2859fa436c72831c28c00d43467c0fa6ba5a9d928d76283efb1fc91e5b34a3197daedf0e85b491c1150bcb232799f16572e49760327d405fc9f058fce5a9c54f076a1f00c70beb98b557405d1777a86e3c97f36a3bbb6155edf06e604c1db93939c7bf4e1ea042d1907b6c14c0bab0be9cc9085aaa92f6847dad5272afa2b6299ae2c62666e2a38263aed35ce47a6eb5a6fb1";
    bytes modulus4 = hex"c4f7e1e0085843c11cd19f91deaefb01611761802717f326726137a5255a0a2da709f9d55d445657b3e2945b67ff1a077d0d108df931ba184974dcbd017d3127b21e8331caf836b8aa4ba03ac4695541ee0590ae34bc36d95f23a78b5df5588340db247a499f55dbecaed1f780a41400a57ab508dba210e1047f5bab1fa079ac994a846be936701e9bfadc081f657a040db446da525fab4b0c9cd45d6b81c7940f4b2f95ac531d68ac28b6feb23d9fd4685d503c6f3c24e64bb3ed7a281b1f729ab6c32440bd158655db11c3401f1849af2438789c7835228edb63ab81e6384db3ca441dd9850b1578a1ee98a64506f766200890a16916e98fc66117fe2bca09";
    bytes modulus5 = hex"d1ad7c55feffeb0d8bae01c0df90381968e3151d2ff65f5d4dc4532453a8e6adcf5fdcf50ff5c090ce62e562dbda88b48983396bb3138e802d45ee7b03b9cd29c992027111771039b4683b06d8b2ad10dccf291b6ed6f817920e99a4e5066ca560a0df409f82b3af0ad9bb631cb634e28dee91d2b249cbdcb77625e6b538ce119e3c16e959dd1135acdb9c3550519ee56c04cd86cd9b5847c4f9a6e99e17b5783a88c447a133533ee68f53bdb961694d629a7080921831dfe185a623fb6e60f3dc0133e68559702ee68f3cc83465d449db44feee7e48cfe4e59fa4334edb52906ed51986bf453e8a623301457457bc16e83d7b2354dd457ee14e6c15279ef613";
    bytes modulus6 = hex"ebe1f9ac4b09b2ebbbf82e7f3b7c0b623a3ea71f636ffd4cb9919d294eb15565ed84b955f375d0b6ab8124024600296c77dae4eb631a925e41ba015f62ae818412a99e51c4a281b3fd7b4a042996864e4463c709c6277f26fd257ae16439ce7a395216c908e43727cdc0462c0f43ceff48983dd637e80cd7ec9959f2ce4404f0edf5bdba1b99337ebe4a7147309545d760e8a4db6747d95dbee6620be2a0e408379afbcfe26d696db41351d95c323afc536a240b845eb5321e28a4a9640866bb3e26af3866a4bb0272d3e4076f91f70451a208b888a7e7cb29c8c6b988d35e0f8126e1d6c09b6e1a6acfb0885ad5ba94d4ac6e609dbac5ff7e02203c2bdb7507";
    bytes modulus7 = hex"e14891ebd21199f04c85d8fce03494fb6e6b7d43db1af62b4e13dc7594834c20cd805cd63f8fa4d27ee788a37ef133e1068d91f4539f81facdaa9e613757ca15659fb43165ad6bd47b62edfac11a08ca931d24d8090071a4f062fcadb5a5aa33d7b100dd46c9df0d18ad98757d056741a1b89f595632f62906bcb09a84c2eb63e868a97aafa89c49e9c38bbc6cf295e47676b2c6e3a978e670e3122b62ae39d4e568dc828e87182d90e3a4ffdc213f370e426d730fe98dd20a1548192f629290d98dd58f2a1f1e9abd59f116b47b0f8b7066e3de17f347025548d457fc53d24bd3294e2b4d9839a4687adc8ceb203f862f2f9e6bd2cbd4427aeec125515bbc47";
    bytes modulus8 = hex"b5be3e236c62a3e03d0d993ba5ccfc639620e5237bdc53e7dd52d24a0b7236f3143b16c7ff4d1cf31a5f9c6671f303a1504a50fd91137b4edf5e37fdb672b68ad14ace39d968da3ae3cfb83b1ee0a2550903e98d21b122a6fc34fa5f4ddc1f06fe659ccad06df638abf858019af66e291f84c5f394211764c50cdc46786a30d874cfcd0046e3e5d9ad899eaad543e32a3b1437088b22bbf443332026a1e46c7574713da7d0a6ab0a1822f9fda463c561d8d5d503dde26dfd323c80d8bb6831cfc9872b647d7ced6683125ec816a00e721f65b4aca5e1d861aa50901d9bbb5e9d9266122e39725b2ca7e575d3cbdab5f75a562d586a0b157acf8468757f78ce25";
    bytes modulus9 = hex"a68c37147fb740f3007c0794d7ece6168c6c465ee1c562cd22578fef2a6e884ba149bbc979e2463bde14fe21c3ae0ae34257156fa92db4e6c7eb6fc0597a4b5196fdc9be4032c47f4a4d76211244361b1a9b7d2629610fbe10ae6811ca1ccf0686198fe158d7d932a20bdf7a02e6ea9208f33fb989952cedb6c64db4a15cac40d053746499b9d6682974f911a403ea5add15c2a7f918cbfad784ef7536a68ef7678a613fe45aed0cfd5e4ae772f41b4f5f43129fcf7e550268f0781bc26e721bea3893b02c52a537e3a342833117b9c419fda280f307a258ef162c5b2dc0d48ae88de34f785b0368dca5310cbf5f434843d77797898a6b4faebb89079d15a60b";

    //example signature for measuring storage
    bytes x_ex = hex"040bb2f2151be77a766ffa74256a1f778bc45c4027d7ff6de44c14d77fc33a17efb6b18059af36d3a3c9b9db710412b25ad0393901f9877bf48bb95dbcc9b0a5679a52a92d32aac97d5f9b7e242c87049e528c31f229b3b2e115c80a0699ae25cd5564ba0056cc897126cba89221a2a6e516553c591f3406f05267513db8434d3ecf336bfc28b6998c12b5f07d96597ac32ea81a8e5f71b3ad37d4bda7ebd90a8c6fb2b27be797ac1ed1719f9978a55b98d194c55886b0db3dde6f8933632d0466a52a30944c877bcff04f79862a377d4779d5fcf69590bbedc39aaf0c1c2a3b29cbcd2e6c826ce4fb1f6ade94492ff8640412277e27ae86e7527d05da9c4d58";
    bytes32 h_ex = hex"382c197defb54043b80875be1de7fa4bb210c183e2e274c25296d9de5da09df1";
    bytes16 r_ex = bytes16(39591481140754388166925179461058716055);
    bool b_ex = false;

    //NOTE: add elements to set the number of messages signatures that will be stored in function store.
    bytes16[] r_arr = [r_ex, r_ex, r_ex, r_ex, r_ex,
                        r_ex, r_ex, r_ex, r_ex, r_ex];
    bool[] b_arr = [b_ex, b_ex, b_ex, b_ex, b_ex,
                        b_ex, b_ex, b_ex, b_ex, b_ex];

    /**
    This method is used to measure only the transaction costs
    */
    function doNothing(bytes data, bytes x, bytes32 h, bool[] b, bytes16[] r) returns (bool) {
        revert();
    }

    /**
    This method is used to measure only the storage costs
    */
    uint32 counter = 0;
    mapping(uint32 => bytes) msg_storage;
    mapping(uint32 => bytes) x_storage;
    mapping(uint32 => bytes32) h_storage;
    mapping(uint32 => bytes16[]) r_storage;
    mapping(uint32 => bool[]) b_storage;
    function store() {

        uint n = 10; //NOTE: change this parameter to set the number of messages signatures that will be stored

        x_storage[counter] = x_ex;
        h_storage[counter] = h_ex;
        r_storage[counter] = r_arr;
        b_storage[counter] = b_arr;

        for (uint i = 0; i < n; i++) {
            msg_storage[counter] = message;
            counter = counter + 1;
        }
    }

    /**
    This method is used to measure the total costs
    */
    function verify(bytes data, bytes x, bytes32 h, bool[] b, bytes16[] r) returns (bool) {
        bytes memory x_prev = x;
        bytes32 h_prev = h;

        uint n_signers = r.length;

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

        //Perform check
        //require(h_hash == h_prev && equals(g_hash, pig));

        //Store proof and messages
        x_storage[counter] = x_prev;
        h_storage[counter] = h_prev;
        r_storage[counter] = r;
        b_storage[counter] = b;
        for (uint j = 0; j < n_signers; j++) {
            msg_storage[counter] = message;
            counter = counter + 1;
        }

        return true;
    }

    function getModulus(uint i) view internal returns (bytes) {
        if (i == 0) {
            return modulus0;
        } else if (i == 1) {
            return modulus1;
        } else if (i == 2) {
            return modulus2;
        } else if (i == 3) {
            return modulus3;
        } else if (i == 4) {
            return modulus4;
        } else if (i == 5) {
            return modulus5;
        } else if (i == 6) {
            return modulus6;
        } else if (i == 7) {
            return modulus7;
        } else if (i == 8) {
            return modulus8;
        } else if (i == 9) {
            return modulus9;
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
