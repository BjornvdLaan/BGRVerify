pragma solidity 0.4.21;

import "./SolRsaVerify.sol";

contract RSA {
    using SolRsaVerify for *;

    function verify(bytes _data, bytes _s, bytes _e, bytes _n) returns (bool) {
        return SolRsaVerify.pkcs1Sha256VerifyRaw(_data, _s, _e, _n);
    }


}
