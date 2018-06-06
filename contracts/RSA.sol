pragma solidity 0.4.21;

import "./SolRsaVerify.sol";

contract RSA {
    using SolRsaVerify for *;

    struct Delivery {
        bytes data;
        bytes s;
        bytes n;
    }

    uint counter = 0;
    mapping (uint => Delivery) deliveries;

    //Simulation of PKI (assumed to be available)
    uint constant e = 65537;
    //bytes e = hex"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001";
    bytes N = hex"981738fcbbb695c3d97599593c39f153a386ff630b59bc566a34e86ca414db193976ccbe5680e063c1409278caa9ded202f2570f1f72f17f86338515c548de8473b024d25df8ed6270f3b949da6216b87e8b782677855275419470d258ba4f33646c3c09c790561deff7f0a340134d110c492a0389eef545f8a07bca8ded97e1691f591f172889ced1ffc5932d913debc28dd884ebc80f94b0b8b3fc50c76beb5558917b8758ebf05c9fcf8b09a8d68e30430bf0a9c4c19b09ae387bb32816a9fec1c7faa5c6a4958959cbc909f0113601fc36cf419d89af67ba42b3aefaec07ab0a2583c78c4243ae060d9236eee94395c37d608a6587fe419f38215b5488ed";

    function verify(bytes _data, bytes _s, bytes _n) returns (bool) {
        return SolRsaVerify.pkcs1Sha256VerifyRaw(_data, _s, e, _n);
    }

    function verifyStored(int[] indexes) returns (bool) {
        for (uint i = 0; i < indexes.length; i++) {
            return SolRsaVerify.pkcs1Sha256VerifyRaw(_data, _s, e, _n);
        }

    }

    function store() {
        Delivery d = Delivery(_data, _s, _n);
        deliveries[counter] = d;
        counter++;
    }

}
