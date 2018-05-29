pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGRSmallThreeFFF {

    bytes32 x = bytes32(18115390633149407653339833018649393973660880445469525020077358032081985937997);
    bytes32 h = bytes32(11559775926174368905745592433081596904384683309495480316690029641247127684734);

    bool[] b = [false, false, false];
    bytes2[] r = [bytes2(6566), bytes2(31966), bytes2(60634)];

    string[] messages = [
    "MESSAGE 0",
    "MESSAGE 1",
    "MESSAGE 2"
    ];

    //Simulation of PKI
    uint256 e = 65537;
    uint256[] modulus = [
    97885221880545131614956327669353796100886093042909598927834387463561749905353,
    91542019175266321384222930621953011415273958814303191515601836249299334964037,
    96346107315202996585852262992425589636144460118263479845834058492693067329513
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
            y = pi(x_prev, modulus[i]);

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

        bytes32 pig = pi(split_inverse(b[0], x_prev), modulus[0]); //this is tested

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

    function pi(bytes32 val, uint256 mod) returns (bytes32) {
        return bytes32(modExp(uint256(val), e, mod));
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
