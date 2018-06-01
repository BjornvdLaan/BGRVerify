pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

contract BGRSmall {

    bytes32 x = bytes32(42824850096903168933980549444850820531267307277747638740663904061453936159818);
    bytes32 h = bytes32(5501940602124613446706973589804112402000519963019969627929571506777536396930);

    bool[] b = [false];
    bytes2[] r = [bytes2(60884)];

    string[] messages = [
    "MESSAGE 0"
    ];

    //Simulation of PKI
    uint256 e = 65537;
    uint256[] modulus = [
    72929305810002043507619804809205202485847149948104996985858670357851653292683
    ];

    /*
        NOTE: test de split en split_inverse of die ook problemen hebben door circular.
    */

    //function verify(string[] messages, bytes32 x, bytes32 h, bytes2[] r, bool[] b) returns (bool) {
    function verify() returns (bytes32) {
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
        bytes32 h_hash = HHashBase(modulus[0], messages[0], r[0]);
        bytes32 g_hash = GHash(h_prev);

        bytes32 pig = pi(x_prev, modulus[0]); //split_inverse(b[0], x_prev)

        return g_hash;
        //return g_hash == pig && h_hash == h_prev;
    }

    function GHash(bytes32 x) internal pure returns (bytes32) {
        bytes32 hash = keccak256(x);
        return bytes32(uint256(hash) - uint256(57896044618658097711785492504343953926634992332820282019728792003956564819968));
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

    function testsplitinverse() returns (bytes32) {
        //output should be
        //{206, 119, 223, 247, 50, 131, 194, 188, 88, 248, 137, 233, 130, 2, 141, 71, 11, 164, 233, 127, 219, 134, 220, 38, 255, 153, 198, 120, 110, 214, 92, 229}
        bytes32 test = bytes32(35492202744065384896209724461799058330743915199574411635769998350682397498597);
        bytes32 test_joined = split_inverse(true, test);
        return test_joined;
    }

    function testIterationWhereBFalse() returns(bool) {
        /**
        x0 [120 160 71 100 185 115 201 93 218 213 179 164 103 196 235 6 25 224 180 37 65 174 12 246 150 50 43 212 162 22 204 123]
        x0 54560730099872202741014348823700252121970690209029593489829040881417946844283
        h0 [67 47 128 33 112 190 87 171 121 115 80 187 255 224 101 8 19 137 9 58 42 23 167 186 213 123 127 32 85 233 179 139]
        h0 30388886992207340305962404453616357726282684957228414817761178193477287654283

        b: [false false]
        pk0: [{102743022338080698399822885770321843460142630877362568352134398440806099155583 65537}
        pk1: {93927003878993796301442461976674285725878507388897556398417324507303901498211 65537}]
        x 41707842825415241247613949009888182739661538314057289794544731069070621009858
        h 56988013903001702417510710329046235085305234412217927901605658221842631750103
        r0 61769
        r1 6250
        */

        bytes32 x_prev = bytes32(41707842825415241247613949009888182739661538314057289794544731069070621009858); //sig.x
        bytes32 h_prev = bytes32(56988013903001702417510710329046235085305234412217927901605658221842631750103); //sig.h

        bytes32 g;
        bytes32 eta;
        bytes32 y;
        bytes32 X;

        //Line 2
        X = split_inverse(false, x_prev);
        y = pi(x_prev, 93927003878993796301442461976674285725878507388897556398417324507303901498211);

        //Line 3 G
        g = GHash(h_prev);

        //Line 4
        x_prev = g ^ y;

        //Line 5 H
        eta = HHash(93927003878993796301442461976674285725878507388897556398417324507303901498211, "MESSAGE 1", 6250, x_prev);

        //Line 6
        h_prev = h_prev ^ eta;

        //Now should be x1 h1
        bytes32 x_0 = bytes32(54560730099872202741014348823700252121970690209029593489829040881417946844283);
        bytes32 h_0 = bytes32(30388886992207340305962404453616357726282684957228414817761178193477287654283);
        return h_prev == h_0 && x_prev == x_0;
    }

    function testIterationWhereBTrue() returns(bool) {
        //Not working yet
        /*
       b: [false true]
       pk0: [{100559639697891460902764141020356907258428814093396659529555505846242710753001 65537}
       pk1: {75514132473334443068127286379962420780446675478900207212147158057076204097627 65537}]
       sigx 5478324901913405590120700960084756849033925727756286198862916110070595692811
       sigh 31908922008483892227221543185441079020097797844702142216235016446839414122921
       r0  31713
       r1 16181

       x0 48067657424336353606332271955203152262108042684260758989777771218257675402919
       h0 110698550962008875660816179094143079823491013343052579972863588172519883248496
       */

        bytes32 x_prev = bytes32(5478324901913405590120700960084756849033925727756286198862916110070595692811); //sig.x
        bytes32 h_prev = bytes32(31908922008483892227221543185441079020097797844702142216235016446839414122921); //sig.h

        bytes32 g;
        bytes32 eta;
        bytes32 y;
        bytes32 X;

        //Line 2
        X = split_inverse(true, x_prev);
        y = pi(x_prev, 75514132473334443068127286379962420780446675478900207212147158057076204097627);

        //Line 3 G
        g = GHash(h_prev);

        //Line 4
        x_prev = g ^ y;

        //Line 5 H
        eta = HHash(75514132473334443068127286379962420780446675478900207212147158057076204097627, "MESSAGE 1", 16181, x_prev);

        //Line 6
        h_prev = h_prev ^ eta;

        //Now should be x1 h1
        bytes32 x_0 = bytes32(48067657424336353606332271955203152262108042684260758989777771218257675402919);
        bytes32 h_0 = bytes32(110698550962008875660816179094143079823491013343052579972863588172519883248496);
        return x_prev == x_0;
    }

    function testIterationWhereBTrue2() returns(bytes32) {
        //Not working yet
        /**
        b: [false true]
        pk0: [{103461757571518832622635512335759653289686535967345491211562066594885636499703 65537}
        pk1: {99730258665501075335213668211394431132735782537502029889654257709728791831553 65537}]
        x 17345272308542689518344084692542391725387407987955954252876114177875730479097
        h 72508440660091421077602028370085314092271011290385113018893260330849832526754
        r0  27913
        r1 23120

        x0: [16 117 168 232 232 6 14 60 61 167 169 42 196 223 3 180 96 96 224 244 134 86 114 132 48 192 49 62 102 141 90 86]
        x0: 7444892456440163573410901007413933802788727521996010232230772429884100532822
        h0 [148 245 112 65 234 115 82 244 229 242 6 16 107 207 73 11 245 140 187 179 248 150 57 138 67 128 252 117 2 51 194 171]
        h0: 67375953893872021360571726900073981219547307846512650979748574264878368539307
        */

        bytes32 x_prev = bytes32(17345272308542689518344084692542391725387407987955954252876114177875730479097); //sig.x
        bytes32 h_prev = bytes32(72508440660091421077602028370085314092271011290385113018893260330849832526754); //sig.h

        bytes32 g;
        bytes32 eta;
        bytes32 y;
        bytes32 X;

        //Line 2
        X = split_inverse(true, x_prev);
        y = pi(x_prev, 99730258665501075335213668211394431132735782537502029889654257709728791831553);

        //Line 3 G
        g = GHash(h_prev);

        //Line 4
        x_prev = g ^ y;

        //Line 5 H
        eta = HHash(99730258665501075335213668211394431132735782537502029889654257709728791831553, "MESSAGE 1", 23120, x_prev);

        //Line 6
        h_prev = h_prev ^ eta;

        //Now should be x1 h1
        return x_prev;
    }

    function testsplitpi() returns(bytes32) {
        bytes32 a = split_inverse(true, 27923161953777573553354981145307315045607106610564892606139996960213013027258);
        return pi(a, 107533363795656919624871251264905461846385118845249129805258716736864472793907);

        //should be:
        //x [216 46 187 241 18 138 216 192 50 31 82 230 180 8 62 173 220 7 1 115 32 178 191 228 32 170 158 48 43 241 198 23]
        //x 97782147384832081648842991865189261321407426024020293440409439033677455672855
    }

}
