pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGRBig {

    bytes x = hex"c96b966f08643fcb17d438dc949c746817ec9fae47bc4917b5f66c8d55f6902683fb760490ab181af74c0fd52a5bf492e338871e3e209014ad8ca4308569c1b2a7db5bdceb676b7a244565dd466234dde9ec0d3922c8defcff9d348c20e140fc23239ff9d65e9828022f0fb58d804d84a76b527ab4e87e2f83816d158ea18a206195a9d4025b948fd26cbd98c756229d6670c7c461ba68e4dca6bbcbb1ea745019d2bff4728f3b6ff2734e42843c1a548909952aebe5003efe418d315cec58ce6a906e01ba33c11505f79a451fc21d3f50b78719d455e2691e2cf818298879fbe6ea93eca4aa7562834e39eb5835f16aec4427cf8e71d3dcefb62a6bd9fda18b";
    bytes32 h = bytes32(32874016276410785723952341262669264316082375692834943036671182319508755362748);

    bool[] b = [false, false, false];
    bytes2[] r = [bytes2(55093), bytes2(64784), bytes2(13966)];

    string[] messages = [
    "MESSAGE 0",
    "MESSAGE 1",
    "MESSAGE 2"
    ];

    //Simulation of PKI
    uint256 e = 65537;
    bytes[] modulus = [
    hex"c96b966f08643fcb17d438dc949c746817ec9fae47bc4917b5f66c8d55f6902683fb760490ab181af74c0fd52a5bf492e338871e3e209014ad8ca4308569c1b2a7db5bdceb676b7a244565dd466234dde9ec0d3922c8defcff9d348c20e140fc23239ff9d65e9828022f0fb58d804d84a76b527ab4e87e2f83816d158ea18a206195a9d4025b948fd26cbd98c756229d6670c7c461ba68e4dca6bbcbb1ea745019d2bff4728f3b6ff2734e42843c1a548909952aebe5003efe418d315cec58ce6a906e01ba33c11505f79a451fc21d3f50b78719d455e2691e2cf818298879fbe6ea93eca4aa7562834e39eb5835f16aec4427cf8e71d3dcefb62a6bd9fda18b",
    hex"c96b966f08643fcb17d438dc949c746817ec9fae47bc4917b5f66c8d55f6902683fb760490ab181af74c0fd52a5bf492e338871e3e209014ad8ca4308569c1b2a7db5bdceb676b7a244565dd466234dde9ec0d3922c8defcff9d348c20e140fc23239ff9d65e9828022f0fb58d804d84a76b527ab4e87e2f83816d158ea18a206195a9d4025b948fd26cbd98c756229d6670c7c461ba68e4dca6bbcbb1ea745019d2bff4728f3b6ff2734e42843c1a548909952aebe5003efe418d315cec58ce6a906e01ba33c11505f79a451fc21d3f50b78719d455e2691e2cf818298879fbe6ea93eca4aa7562834e39eb5835f16aec4427cf8e71d3dcefb62a6bd9fda18b",
    hex"c96b966f08643fcb17d438dc949c746817ec9fae47bc4917b5f66c8d55f6902683fb760490ab181af74c0fd52a5bf492e338871e3e209014ad8ca4308569c1b2a7db5bdceb676b7a244565dd466234dde9ec0d3922c8defcff9d348c20e140fc23239ff9d65e9828022f0fb58d804d84a76b527ab4e87e2f83816d158ea18a206195a9d4025b948fd26cbd98c756229d6670c7c461ba68e4dca6bbcbb1ea745019d2bff4728f3b6ff2734e42843c1a548909952aebe5003efe418d315cec58ce6a906e01ba33c11505f79a451fc21d3f50b78719d455e2691e2cf818298879fbe6ea93eca4aa7562834e39eb5835f16aec4427cf8e71d3dcefb62a6bd9fda18b"
    ];

    /*function test() returns (bytes32) {
        bytes memory xl = hex"c96b966f08643fcb17d438dc949c746817ec9fae47bc4917b5f66c8d55f6902683fb760490ab181af74c0fd52a5bf492e338871e3e209014ad8ca4308569c1b2a7db5bdceb676b7a244565dd466234dde9ec0d3922c8defcff9d348c20e140fc23239ff9d65e9828022f0fb58d804d84a76b527ab4e87e2f83816d158ea18a206195a9d4025b948fd26cbd98c756229d6670c7c461ba68e4dca6bbcbb1ea745019d2bff4728f3b6ff2734e42843c1a548909952aebe5003efe418d315cec58ce6a906e01ba33c11505f79a451fc21d3f50b78719d455e2691e2cf818298879fbe6ea93eca4aa7562834e39eb5835f16aec4427cf8e71d3dcefb62a6bd9fda18b";
        bytes memory x3 = hex"c96b946f08643fcb17d438dc949c746817ec9fae47bc4917b5f66c8d55f6902683fb760490ab181af74c0fd52a5bf492e338871e3e209014ad8ca4308569c1b2a7db5bdceb676b7a244565dd466234dde9ec0d3922c8defcff9d348c20e140fc23239ff9d65e9828022f0fb58d804d84a76b527ab4e87e2f83816d158ea18a206195a9d4025b948fd26cbd98c756229d6670c7c461ba68e4dca6bbcbb1ea745019d2bff4728f3b6ff2734e42843c1a548909952aebe5003efe418d315cec58ce6a906e01ba33c11505f79a451fc21d3f50b78719d455e2691e2cf818298879fbe6ea93eca4aa7562834e39eb5835f16aec4427cf8e71d3dcefb62a6bd9fda18b";
        return
    }*/

    //function verify(string[] messages, bytes32 x, bytes32 h, bytes2[] r, bool[] b) returns (bool) {
    function verify() returns (bool) {
        bytes x_prev = x;
        bytes32 h_prev = h;

        bool s;
        bytes g;
        bytes y;
        bytes X;
        bytes32 eta;

        for (uint i = modulus.length - 1; i > 0; i--) {
            //Line 2
            X = split_inverse(x_prev, b[i]);
            (s, y) = modexp(X, e, modulus[i]);
            //pi

            //Line 3 G
            g = ghash(h_prev);
            //256 -> 2048

            //Line 4 and 5
            eta = line4and5(modulus[i], messages[i], r[i], x_prev);
            //256

            //Line 6
            h_prev = h_prev ^ eta;
            //256 ^ 256
        }

        //Line 7
        bytes32 h_hash = hhashbase(modulus[0], messages[0], r[0]);
        bytes32 g_hash = ghash(h_prev);

        bytes32 pig = modexp(split_inverse(x_prev, b[0]), e, modulus[0]);

        return g_hash == pig && h_hash == h_prev;
    }

    function modexp(bytes base, uint exponent, bytes modulus) internal returns (bool success, bytes output) {
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
            success := call(gas(), 5, 0, add(input, 32), size, add(output, 32), modulus_length)
        }
    }

    function split_inverse(bytes x, bool b) internal pure returns (bytes) {
        if (b) {
            x[0] = 0;
        }

        return x;
    }

    //not implemented yet
    function ghash(bytes32 h) internal pure returns (bytes) {
        return hex"c96b966f08643fcb17d438dc949c746817ec9fae47bc4917b5f66c8d55f6902683fb760490ab181af74c0fd52a5bf492e338871e3e209014ad8ca4308569c1b2a7db5bdceb676b7a244565dd466234dde9ec0d3922c8defcff9d348c20e140fc23239ff9d65e9828022f0fb58d804d84a76b527ab4e87e2f83816d158ea18a206195a9d4025b948fd26cbd98c756229d6670c7c461ba68e4dca6bbcbb1ea745019d2bff4728f3b6ff2734e42843c1a548909952aebe5003efe418d315cec58ce6a906e01ba33c11505f79a451fc21d3f50b78719d455e2691e2cf818298879fbe6ea93eca4aa7562834e39eb5835f16aec4427cf8e71d3dcefb62a6bd9fda18b";
    }

    function cut(bytes x) internal pure returns (bytes32 part1, bytes32 part2, bytes32 part3, bytes32 part4, bytes32 part5, bytes32 part6, bytes32 part7, bytes32 part8) {

        assembly {
            part1 := mload(add(x, 32))
            part2 := mload(add(x, 64))
            part3 := mload(add(x, 96))
            part4 := mload(add(x, 128))
            part5 := mload(add(x, 160))
            part6 := mload(add(x, 192))
            part7 := mload(add(x, 224))
            part8 := mload(add(x, 256))
        }
    }

    function line4and5(bytes a, bytes b) internal pure returns (bytes32) {
        // Line 4: XOR
        var (a1, a2, a3, a4, a5, a6, a7, a8) = cut(a);
        var (b1, b2, b3, b4, b5, b6, b7, b8) = cut(b);

        bytes32 c1 = a1 ^ b1;
        bytes32 c2 = a2 ^ b2;
        bytes32 c3 = a3 ^ b3;
        bytes32 c4 = a4 ^ b4;
        bytes32 c5 = a5 ^ b5;
        bytes32 c6 = a6 ^ b6;
        bytes32 c7 = a7 ^ b7;
        bytes32 c8 = a8 ^ b8;

        // Line 5: compute eta
        return keccak256(modulus[0], messages[0], r[0], c1, c2, c3, c4, c5, c6, c7, c8);
    }

    function hhashbase(bytes pk, string m, bytes2 r) returns (bytes32) {
        return keccak256(pk, m, r);
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

}
