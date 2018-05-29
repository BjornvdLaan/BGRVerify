pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGRSmall {

    bytes32 x = bytes32(21815010946920326725448554161391577562219037378072594164779468615641707773797);
    bytes32 h = bytes32(80301163518557209160327257243075188899345325040434022335849314277093177124118);

    bool[] b = [false];
    bytes2[] r = [bytes2(29493)];


    string[] messages = [
        "MESSAGE 0"
    ];

    //Simulation of PKI
    uint256 e = 65537;
    uint256[] modulus = [
    73992665385593046613433232500063923994334720920550463039164095254361992303669
    ];

    function test() returns (bytes32) {
        return bytes32(modExp(uint256(21815010946920326725448554161391577562219037378072594164779468615641707773797), e, modulus[0]));
    }

    //function verify(string[] messages, bytes32 x, bytes32 h, bytes2[] r, bool[] b) returns (bool) {
    function verify() returns (bytes32) {
        bytes32 x_prev = x;
        bytes32 h_prev = h;

        bytes32 g;
        bytes32 eta;
        bytes32 y;
        bytes32 X;

        /*
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
        */

        //Line 7
        bytes32 h_hash = HHash(modulus[0], messages[0], r[0], bytes32(0)); //this is tested
        bytes32 g_hash = GHash(h_prev); //this is tested

        bytes32 pig = pi(split_inverse(b[0], x_prev), 0); //this is only tested for b=false

        return pig;
        //return (h_prev == h_hash) && (pig == g_hash);
    }

    function GHash(bytes32 x) pure returns (bytes32) {
        bytes32 hash = keccak256(x);
        //hash[0] = 0x00;
        return hash;
    }

    function HHash(uint256 pk, string m, bytes2 r, bytes32 x) pure returns (bytes32) {
        return keccak256(pk, m, r, x);
        //return keccak256(pk, m, r, x);
    }

    function pi(bytes32 val, uint256 signer) returns (bytes32) {
        return bytes32(modExp(uint256(val), e, modulus[signer]));
    }

    function modExp(uint256 base, uint256 exp, uint256 mod) internal returns (uint256 result)  {
        result = 1;
        for (uint count = 1; count <= exp; count *= 2) {
            if (exp & count != 0)
                result = mulmod(result, base, mod);
            base = mulmod(base, base, mod);
        }
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

    function split_inverse(bool b, bytes32 x) internal returns (bytes32) {
        if (b) {
            return bytes32(uint256(x) - 128);
        }
        else {
            return x;
        }
    }
}
