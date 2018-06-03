pragma solidity 0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BGRSmall.sol";

contract TestBGRSmall {
    BGRSmall bgr = BGRSmall(DeployedAddresses.BGRSmall());

    function testThreeFFF() public {
        bytes32 x = bytes32(48574670302110873900186887930825348864862875264737285835557344117607811371373);
        bytes32 h = bytes32(32874016276410785723952341262669264316082375692834943036671182319508755362748);

        bool[] memory b;
        b[0] = false;
        b[1] = false;
        b[2] = false;

        bytes2[] memory r;
        r[0] = bytes2(55093);
        r[1] = bytes2(64784);
        r[2] = bytes2(13966);

        /*string[] memory messages;
        messages[0] = "MESSAGE 0";
        messages[1] = "MESSAGE 1";
        messages[2] = "MESSAGE 2";*/

        uint256[] memory modulus;
        modulus[0] = 71592459438769366555287905212920150282388951853471084808236715516732226882039;
        modulus[1] = 76723212719259523646191797913083315208539844433174054239968451621612127126299;
        modulus[2] = 92733209039681599712767330020819907773031548378901671974778944208981299740979;

        bool actual = bgr.verify(x, h, r, b, modulus);
        bool expected = true;

        Assert.equal(actual, expected, "Valid signature should pass.");
    }
}

