pragma solidity 0.4.21;
pragma experimental ABIEncoderV2;

import "./SolRsaVerify.sol";

contract RSA {
    using SolRsaVerify for *;

   /* struct Delivery {
        bytes data;
        bytes s;
    }*/

    //uint counter = 0;
    //mapping (uint => Delivery) deliveries;

    //Simulation of PKI (assumed to be available)
    uint constant e = 65537;
    //bytes e = hex"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001";
    bytes modulus0 = hex"d4c6517398bac6e5a9a9f4986218d3ef467450e1557df5311cf3921c0027f5c2b2172103b17bf82e39be6459903baa1c4e97aeadfe314f9db4eaf3dd91446b259e28fba11421de48bcf18e859b24ed96602aace3329eed2c9beaf01b28d9694923dc67e10df22cbe3ea0fdb719b84f2e1c1c6c2cb849f2efa5a0ea885b9477a623da4440d67102a01e112b2cc0e6a135724493e2d8c8d3e2fcbbc9273189891ee730df80acb09e34b0f6ebb479210e6ccc69642b34b4e40de0f57641270315062d0148162e34f5fda7d6453f99ac124f2ce7ca5bd40df81a70708f3f3bcbbb860127b926c3d1ec303883223650c5621df7d92a38c2d9d7f1be944480f660871d";
    bytes modulus1 = hex"c9795040cd6abe21d6a2736d9f886fee63adb7b89dcfc25e1d2c068907ff37c56fcc6754fd1ceaabb8b948328ce370a08555cbe1b55e02b5c1d7e6f565465a813c1ce2fd398443d77859c3c1f572f7d13837926a8f390bf4852e3d4ecbdeab78d10853078c0fb51fbbb58dcd05d5d830d2e689cd63660529ff03814f8073111ff02eae6ced47d0e68718a185b3dc19fe28cedc51a20a19ed7f5f81b9ffda445af548908191c4e316e55f62594669c3da47b467909a2ac34bece023f683d8b2ea4f8aa55908b249e95eb6d13fef5accc933bf9a7de8af1a345137bfc2161f55aa8a72c7d26a70ada4a9e120a0c3d0ca66cbbce07cd73aae1f581861f111630307";
    bytes modulus2 = hex"bbb6d2fac942df2aa6447789d26b8b52be68c2119bce5cdb7a7a456e3254a616cb65235958ae93a40a5904280096fd4c853bfc1a8d73eefbee570b2b52aea2e3d3ee06b2bac6dc460a2f81911d54d92f35f557b317b3a108d71c626a83b17a9270a848b5c343bb0275b69f1fa33c7cfd54ca5a62640dc7f2913b6a46c43390610d0325bec8071d9aec0ccd673c7579fe83162c0af0062a5485d971f05412d2fbbfc39b5c443d88d7ffc26c014bd8d56d4b1950b136e60c94cbe38defd5ce2ae44b49f111373b28b76ec205ae8ca29136c432bc0c2d80d1c005b20782d031642c2b15946f5ee98a9d9c3ac8fea07fd99b77ce370efd613ce955d0808cec5e4ee9";
    bytes modulus3 = hex"cc970af3c9820aed6e810f453ec092a6d0e54ac9f9f772282ba660bbd45bf9301a8e3e0baff5e7d5480ca51d68fa7728c61163d24fab17bea6d3f5c1ef7ea28363642596c9fe6c6b229be7258474236980596bfc8cc107b0f9f0df648edf3e7ef2ad67e298cf505a9757a8dea70fb19999fc631fb5350519bb71e9a7a1b57f452aa8f43ac27debd7e3130c916c4f207ca5427509a42ef0b2a634e2bdfdb22d982abf252ae3227ccb24bcb0c770a0b86944383ca4e920b77b426fa26317844ad1e7e725e78766acf2de06657ab638fb1d02752f50569b9ff3cfb58c43fc954d8b3f796165794d7ecf7ed710a967434748f55b3259e342004a2e05d8c4170943d1";
    bytes modulus4 = hex"d36db9bb19a21123a52b4254bb0acb3e54f4742a69793a40f3907ceef45279d10f499bed1d014ea7ab814cd67dc6997cb51f401cb011d33f4b8282429d44da1f85aecfc07b2dbc44c1033c2238b0bf31b6a734b24597e38e6ea741fa20732e9295b18ac4294a197c1c4ecd88be1f7809c22a26375fc9f3d955b70907b29a2399e4eedaf9d9ba1e07692df441952f87e0b8e8c8dd1d6d1c58a530f6c5f28d2abfe9d52967405c35049663dacfe8a5ca1195729b47c58dd024b1fc3dd8413955cd4b9781a20170e0baec6c701a6f5268a72619e87d923ea9e46d1139345c295e85982ed17b2a41881cd90deed17f3d7c32e06e511727dca0cde6e1552839a6c35d";
    bytes modulus5 = hex"c4e9c21356185a76288c3377e43e0e12c523c522fe724d66a23f017305942086d9fcea9b280260db0b9fad07be29fa5a5707994cb2ddb5ce0d27da14484376a25ae5248489ebb23a0393521f8773ad5a865865b071fb23a4a3b903ccdc1b9539203df0c3cc72fbb056192c8194582312241279dccc774233fd6bed41e38f76c61d6f4282096a849d0279b4d6288666ffdd40d090711eb423a9ab4190c5db5c0cf477cf76126c63f5b480892fb666d3ffd1a71d069b9a63db83db88f7ee37f43a50ef50097cf469b1beab3f42f3da6767eee80a92a085172db861e225cff635a978efd53700a1cfde581cbc99ee00fe66c07e7b1c5186a941169fcc2cc75aa7ab";
    bytes modulus6 = hex"e55221411440a618e1408915a741f53137609e68d16af0b4dfe820377a3648658424d228bd2e6fda57feaaeb2892cf6b5f5a23601dffd209ac29318a40a6bedd87c335eae2bb71a87dec157cd50d808783461534caf4f1804cc37ba3cc423e5ef8359deb90b0dacf0781fd60c1abe8e9c20600112cccfb459a4ef1830d24920f88a0bfe9fd4ccaa2cb48a3d1eb7743122b6d76fd72c9583d78786250245ba73740fd304d7a8d9b88db67c873b5d9b976bf2e11e76bd317eace5288829bf2170913b49de171aecbdcea0e8d0b8fa306b00cf02e8b5d8d248358dedf895b3211130eb6b6c6a522930198aa169e1f1a48c3c394b7a41de548dc1d5b5a793539f773";
    bytes modulus7 = hex"c82177827ed4d0e9a0321873bc73c5e77c55fb99b691ea2a3e526cfbe42b8d9e4bb1b4b0a2b20205937f47e92e9b5054daf2a502826dc7e75d189a6d4c905ae8af1342ad3e4ce1a48c33213376b2d2e75cb13516d02f395c5b270eb8c5a75ba973225f399b481a19de8f694bf2f4d0b4e6c34ec0a590e23ab68d6784e934f3cb2a54ea93ef80f30c161824a78c20302169d0022767000ac076aeb3c81991ef95e455cc7e841b6f8108b62ad3f9812e3cd712753cef4a842a9328777e1826f885f438274bbe0846663f3e622d36fe84e3ec3acd0e514b89a6368a78d69e3b57932f2b01f02fe6386ef29939a8063c7551edbd3a047cdd9c6358414444baccda4f";
    bytes modulus8 = hex"e698293a112f0b29fd1952d8bdc156c05ccdc1f6f404f471cb7697af554be5ba227c32f5ffca64548325d66478efaf0a8310e51802cfa2e815ffa840625a362c38c4a54f4495934240afa4d67bfdb8f0736981109bc16987007899f61ecc0c6b6b5c7348f9434196b8843bbf9514c1a35b4c2d1982045bf8ee6c422e73c00ab97aa1448a8d4e438d5e379727d88b3a77a955e54a1edc49f0bd9644fef6148ac376ba7000273caf3d52301a92ba378c0611ed6863af31287969397b2254c4c360a63cc6b085f2f8cecd8c5211ec20da7cb4390d3d6a8a602b1b09a1598510091800d77a7879253a6672dd44d34b7a3bd60320d4bace03a5c5c53380ef3d466d43";
    bytes modulus9 = hex"c573703c11fa59d7c306de55edd5db78e77549c71106f289aed98bf0196360ea788ae351c499b572297f07b5b94a750ebe15d33b80e155e590ee13c97ac79feb043f280c19c125478d67f2312466a5ceb123c41ac238f168a1c4a11470b55a214268fc309776c21d8f569cb3a93721973034f666437058fc7f43a2c949074c34b9060c6faec3a8ebbd923f276d38941a38267b0890879be43a9d0d6cb4e38569f80ed24061f9b2feb985db302e7bcc9e594fdbb3a3ec17cde2637de87a57ba86985153c69f78f174426b6278a21eed8bf097a3857499f2ad7f78e26b32a1323f28bc654310219a9cad54c950f58f4ff6890139a34734330c96d9379f4995b0af";

    /**
    This method is used to measure only the transaction costs
    */
    function doNothing(bytes _data, bytes _s) returns (bool) {
        revert();
    }

    function verify(bytes _data, bytes _s, bytes _n) returns (bool) {
        return SolRsaVerify.pkcs1Sha256VerifyRaw(_data, _s, e, _n);
    }

    function verifyMulti(bytes _data, bytes _s, bytes _n) returns (bool) {
        return SolRsaVerify.pkcs1Sha256VerifyRaw(_data, _s, e, _n);
    }

    function getModulus(uint i) view internal returns (bytes) {
        if (i == 0) {
            return modulus0;
        } else if (i == 1) {
            return modulus1;
        } else if (i == 2) {
            return modulus2;
        } else if (i == 3) {
            return modulus3;
        } else if (i == 4) {
            return modulus4;
        } else if (i == 5) {
            return modulus5;
        } else if (i == 6) {
            return modulus6;
        } else if (i == 7) {
            return modulus7;
        } else if (i == 8) {
            return modulus8;
        } else if (i == 9) {
            return modulus9;
        }
    }

    /*function getSlice(bytes data, uint i, uint n) public returns (bytes) {
        uint size = data.length / n;

        bytes memory res = new bytes(size);
        for (uint j = i * size; j < (i+1) * size; j++) {
            res[j - (i * size)] = data[j];
        }
        return res;
    }*/

    /*
   function verifyStored(int[] indexes) returns (bool) {
        for (uint i = 0; i < indexes.length; i++) {
            return true;
            //return SolRsaVerify.pkcs1Sha256VerifyRaw(_data, _s, e, getModulus(i));
        }
    }

    function test(uint i) returns (bytes) {
        return deliveries[i].data;
    }

    function store(bytes _data, bytes _s) returns (uint) {
        Delivery memory d = Delivery(_data, _s);
        deliveries[counter] = d;
        counter++;
        return counter + 1;
    }
*/

}
