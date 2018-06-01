pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGRSmall {

    bytes32 x = bytes32(18543443660615378932570643235507234660096354137208764184642877548079534371636);
    bytes32 h = bytes32(64400662436092399894576493291672880472113578065623983671695867450760513872280);

    bool[] b = [true, true, true];
    bytes2[] r = [bytes2(36874), bytes2(58969), bytes2(30396)];

    string[] messages = [
    "MESSAGE 0",
    "MESSAGE 1",
    "MESSAGE 2"
    ];

    //Simulation of PKI
    uint256 e = 65537;
    uint256[] modulus = [
    73612464816052335400992580047668557085341025725554142784066508858772488150019,
    84905985520890542895799364674735873487301560068085832675359034793436421612461,
    87991568628308038867285581482124837672338016636575992667921349036047738079133
    ];

    //function verify(string[] messages, bytes32 x, bytes32 h, bytes2[] r, bool[] b) returns (bool) {
    function verify() returns (bool) {
        bytes32 x_prev = x;
        bytes32 h_prev = h;

        bytes32 g;
        bytes32 eta;
        bytes32 y;
        bytes32 X;

        for (uint i = modulus.length - 1; i > 0; i--) {
            //Line 2
            X = split_inverse(b[i], x_prev);
            y = pi(X, modulus[i]);

            //Line 3 G
            g = GHash(h_prev);

            //Line 4
            x_prev = g ^ y;

            //Line 5 H
            eta = HHash(modulus[i], messages[i], r[i], x_prev);

            //Line 6
            h_prev = h_prev ^ eta;
        }

        //Line 7
        bytes32 h_hash = HHashBase(modulus[0], messages[0], r[0]);
        bytes32 g_hash = GHash(h_prev);

        bytes32 pig = pi(split_inverse(b[0], x_prev), modulus[0]);

        return g_hash == pig && h_hash == h_prev;
    }

    function GHash(bytes32 x) internal pure returns (bytes32) {
        bytes32 hash = keccak256(x);
        return hash & 0x00ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    }

    function HHash(uint256 pk, string m, bytes2 r, bytes32 x) internal pure returns (bytes32) {
        return keccak256(pk, m, r, x);
    }

    function HHashBase(uint256 pk, string m, bytes2 r) internal pure returns (bytes32) {
        // this seems to work if Go uses x=nil
        return keccak256(pk, m, r);
    }

    function pi(bytes32 val, uint256 mod) returns (bytes32) {
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
