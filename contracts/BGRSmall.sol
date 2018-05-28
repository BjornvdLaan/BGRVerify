pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGRSmall {

    bytes32 x = bytes32(997553209795998839);
    bytes32 h = bytes32(997553209795998839);

    bool[] b = [true, false];
    bytes2[] r = [bytes2(2), bytes2(2)];

    string[] messages = [
    "MESSAGE 1",
    "MESSAGE 2"
    ];

    //Simulation of PKI
    uint e = 65537;
    uint[] modulus = [
        111407148525508025767718379751758291964614386688624532754672299329456855794899,
        102283952970760354931552657672140997299422871062984001550601562917514908012187
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
            y = pi(x_prev, i);

            //Line 3 G
            g = keccak256(h_prev);

            //Line 4
            x_prev = g ^ y;

            //Line 5 H
            eta = keccak256(modulus[i], messages[i], r[i], x_prev);

            //Line 6
            h_prev = h_prev ^ eta;
        }

        //Line 7
        bytes32 h_hash = keccak256(modulus[0], messages[0], r[0], bytes32(0));
        bytes32 g_hash = keccak256(h_prev);
        bytes32 pig = pi(split_inverse(b[0], x_prev), 0);

        return (h_prev == h_hash) && (pig == g_hash);
    }

    function GHash(bytes32 x) pure returns (bytes32) {
        bytes32 hash = keccak256(x);
        //hash[0] = 0x00;
        return hash;
    }

    function HHash(uint pk, string m, bytes2 r, bytes32 x) pure returns (bytes32) {
        return keccak256(pk, m, r, x);
    }

    function pi(bytes32 val, uint signer) returns (bytes32) {
        uint res = (uint(val)^e) % modulus[signer];
        return bytes32(res);
    }

    function stringToBytes32(string memory source) returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    function split_inverse(bool b, bytes32 x) returns (bytes32) {
        if (b) {
            return bytes32(uint(x) - 128);
        }
        else {
            return x;
        }
    }
}
