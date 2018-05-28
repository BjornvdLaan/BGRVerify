pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGRSmall {
    //Simulation of PKI
    uint e = 65537;
    uint[] modulus = [
        111407148525508025767718379751758291964614386688624532754672299329456855794899,
        102283952970760354931552657672140997299422871062984001550601562917514908012187
    ];


    function test() returns (bool) {
        string[] messages;
        for(uint i = 0; i < 2; i++) {
            messages[i] = "MESSAGE ";
        }

        bytes32 x = bytes32(997553209795998839);
        bytes32 h = bytes32(997553209795998839);

        bool[] b;
        b[0] = true;
        b[1] = false;

        bytes2[] r; //= [byte(2), byte(2), byte(2), byte(2), byte(2)];
        r[0] = bytes2(2);
        r[1] = bytes2(2);

        return verify(messages, x, h, r, b);
    }

    function verify(string[] messages, bytes32 x, bytes32 h, bytes2[] r, bool[] b) returns (bool) {
        bytes32 x_prev = x;
        bytes32 h_prev = h;

        bytes32 g;
        bytes32 eta;
        bytes32 y;


        /*
        for (uint i = modulus.length; i > 0; i--) {
            //Line 2
            //X := split_inverse(signature.b[i], x_prev)
            y = pi(x_prev, i); //pi(X, publickeys[i])

            //Line 3
            g = GHash(h_prev);

            //Line 4
            x_prev = g ^ y;

            //Line 5
            eta = HHash(r[i]);

            //Line 6
            h_prev = h_prev ^ eta;
        }*/

        //Line 7
        bytes32 h_hash = HHash(modulus[0], messages[0], r[0], bytes32(0)); //H(publickeys[0], messages[0], r[0], []byte{})
        bytes32 g_hash = GHash(h_prev);
        bytes32 pig = pi(x_prev, 0); //pi(split_inverse(signature.b[0], x_prev), publickeys[0])

        //return h_prev_num.Cmp(HHash_num) == 0 && pig_num.Cmp(GHash_num) == 0;
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
        //uint numval = uint(val);
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

}
