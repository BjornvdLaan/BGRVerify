pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGRSmall {

    string[] messages = [
    "MESSAGE 0",
    "MESSAGE 1",
    "MESSAGE 2"
    ];

    function verify(bytes32 x, bytes32 h, bytes2[] r, bool[] b, uint256[] modulus) public returns (bool) {
        bytes32 x_prev = x;
        bytes32 h_prev = h;

        for (uint i = modulus.length - 1; i > 0; i--) {
            //Line 2, 3, 4
            x_prev = GHash(h_prev) ^ pi(split_inverse(b[i], x_prev), e, modulus[i]); //g ^ y

            //Line 5, 6
            h_prev = h_prev ^ keccak256(modulus[i], messages[i], r[i], x_prev); // ^ eta
        }

        //Line 7
        bytes32 h_hash = keccak256(modulus[0], messages[0], r[0]); // this seems to work if Go uses x=nil
        bytes32 g_hash = GHash(h_prev);

        bytes32 pig = pi(split_inverse(b[0], x_prev), e, modulus[0]);

        return g_hash == pig && h_hash == h_prev;
    }

    function GHash(bytes32 x) internal pure returns (bytes32) {
        bytes32 hash = keccak256(x);
        return hash & 0x00ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    }

    function pi(bytes32 val, uint256 e, uint256 mod) internal pure returns (bytes32) {
        return bytes32(modExp(uint256(val), e, mod));
    }

    function modExp(uint256 base, uint256 exp, uint256 mod) internal pure returns (uint256 result)  {
        result = 1;
        for (uint count = 1; count <= exp; count *= 2) {
            if (exp & count != 0)
                result = mulmod(result, base, mod);
            base = mulmod(base, base, mod);
        }
    }

    function split_inverse(bool b, bytes32 x) internal pure returns (bytes32) {
        if (b) {
            return bytes32(uint256(x) + uint256(57896044618658097711785492504343953926634992332820282019728792003956564819968));
            //NOTE: 2 ** 255 = 57896044618658097711785492504343953926634992332820282019728792003956564819968
        }
        else {
            return x;
        }
    }

}
