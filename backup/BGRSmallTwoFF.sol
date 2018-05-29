pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGRSmall {

    bytes32 x = bytes32(45798797345008441471296603407528195405884422386972752514202061831699762520421);
    bytes32 h = bytes32(24669754057063388723536308177062567109991751309402131776417060733734807937861);

    bool[] b = [false, false];
    bytes2[] r = [bytes2(23016), bytes2(54291)];

    string[] messages = [
    "MESSAGE 0",
    "MESSAGE 1"
    ];

    //Simulation of PKI
    uint256 e = 65537;
    uint256[] modulus = [
    74568943577140306903732898029939400960367738012421432848789416632191998814509,
    84196605858849977364210888348878080667870125182309695527302283662066731432657
    ];

    function test() returns(bytes32) {
        return h;
    }

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
            g = GHash(h_prev);

            //Line 4
            x_prev = g ^ y;

            //Line 5 H
            eta = HHash(modulus[i], messages[i], r[i], x_prev);

            //Line 6
            h_prev = h_prev ^ eta;
        }

        //Line 7
        //bytes32 h_hash = HHash(modulus[0], messages[0], r[0], bytes32(0)); //this is tested
        bytes32 h_hash = HHashBase(modulus[0], messages[0], r[0]);
        bytes32 g_hash = GHash(h_prev); //this is tested

        bytes32 pig = pi(x_prev, 0); //this is tested

        return g_hash == pig && h_hash == h_prev;
    }

    function GHash(bytes32 x) pure returns (bytes32) {
        bytes32 hash = keccak256(x);
        //hash[0] = 0x00;
        return hash;
    }

    function HHash(uint256 pk, string m, bytes2 r, bytes32 x) pure returns (bytes32) {
        return keccak256(pk, m, r, x);
    }

    function HHashBase(uint256 pk, string m, bytes2 r) pure returns (bytes32) {
        // this seems to work if Go uses x=nil
        return keccak256(pk, m, r);
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
            return bytes32(uint256(x) + uint256(57896044618658097711785492504343953926634992332820282019728792003956564819968));
            //NOTE: 2 ** 255 = 57896044618658097711785492504343953926634992332820282019728792003956564819968
        }
        else {
            return x;
        }
    }


    function testsplitreverse() returns (bytes32) {
        //output should be
        //{206, 119, 223, 247, 50, 131, 194, 188, 88, 248, 137, 233, 130, 2, 141, 71, 11, 164, 233, 127, 219, 134, 220, 38, 255, 153, 198, 120, 110, 214, 92, 229}
        bytes32 test = bytes32(35492202744065384896209724461799058330743915199574411635769998350682397498597);
        bytes32 test_joined = split_inverse(true, test);
        return test_joined;
    }

}
