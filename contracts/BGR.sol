pragma solidity 0.4.21;

import "./BigNumber.sol";

contract BGR {
    using BigNumber for *;
    using BGRUtils for *;

    //simulation of PKI
    public int e = 66576; //TODO check this number.
    public string[] modulus = ["abc", "def"]; //TODO put keys here

    function verify(bytes x, bytes h, bytes[] r, bytes[] b) {
        x_prev = x;
        h_prev = h;

        for (i = modulus.length; i > 0; i--) {
            //Line 2
            //X := split_inverse(signature.b[i], x_prev)
            //y := pi(X, publickeys[i])

            //Line 3
            //g := G(h_prev)

            //Line 4
            //x_prev = xor(g, y)

            //Line 5
            //eta := H(publickeys[i], messages[i], r[i], x_prev)

            //Line 6
            //h_prev = xor(h_prev, eta)
        }


        //Line 7
        //HHash := H(publickeys[0], messages[0], r[0], []byte{})
        //GHash := G(h_prev)
        //pig := pi(split_inverse(signature.b[0], x_prev), publickeys[0])

        //convert everything to numbers for comparison
        //h_prev_num := new(big.Int).SetBytes(h_prev)
        //HHash_num := new(big.Int).SetBytes(HHash)
        //pig_num := new(big.Int).SetBytes(pig)
        //GHash_num := new(big.Int).SetBytes(GHash)

        //return h_prev_num.Cmp(HHash_num) == 0 && pig_num.Cmp(GHash_num) == 0;
    }

    //stack too deep error when passing in 9 distinct variables as arguments where 3 bignums are expected.
    //instead we encode each bitlen/neg value in a bytes array and decode.
    function modexp(bytes a_val, bytes a_extra, bytes b_val, bytes b_extra, bytes mod_val, bytes mod_extra) public returns(bytes, bool, uint){
        BigNumber.instance memory a;
        BigNumber.instance memory b;
        BigNumber.instance memory mod;

        uint neg;
        uint bitlen;

        assembly {
            neg := mload(add(a_extra,0x20))
            bitlen := mload(add(a_extra,0x40))
        }

        a.val = a_val;
        a.bitlen = bitlen;
        a.neg = (neg==1) ? true : false;

        assembly {
            neg := mload(add(b_extra,0x20))
            bitlen := mload(add(b_extra,0x40))
        }

        b.val = b_val;
        b.bitlen = bitlen;
        b.neg = (neg==1) ? true : false;

        assembly {
            neg := mload(add(mod_extra,0x20))
            bitlen := mload(add(mod_extra,0x40))
        }

        mod.val = mod_val;
        mod.bitlen = bitlen;
        mod.neg = (neg==1) ? true : false;

        BigNumber.instance memory res = a.prepare_modexp(b,mod);

        return (res.val, res.neg, res.bitlen);
    }

}
