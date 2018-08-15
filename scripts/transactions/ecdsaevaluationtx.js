const ecdsa = require("../evaluation-utils/verifyecdsa");
const web3helpers = require('../../web3helpers');
const BN = require("web3").utils.BN;

const m = web3helpers.readfile();

const s0 = "8d1e86a13bfd3ddd9512119d0ab638751b28c779eb30991e9459e4b18f53e8887656d2a76ae36423e9329fe498abbb6a8672ccc9f1f5e13eefeda50b59f80b6fc456b6a41882bc42753ad3eae5e082764ef142f6f69733b10dff36e10f71ddef0a36c1d52c36f2240ae155e9673d9a13dd730484bc71237dffcf6ef26d6a30bbf3ae2ea3548bf28ccdb4093944430b2203ae5d55cdb4e4a33ed0c611f8f239edd2512f589c6c193a0257bc1ac8e0665a7f838b47517a08d72510ec231bf3674c4a9a7fdb38b235e0f2930513da55246dcf0ede9e2af8e20e39e9b75c96d63669da155f6011ca69838c8d9aa9a98af3cb9852fa7ab986c33d263f47a7e61ef0cd";

measureTransactionCost(parseInt(process.argv[2]));

function measureTransactionCost(number_of_signers) {
    //create message of right size
    let message = "";
    let signatures = "0x";

    for (let i = 0; i < number_of_signers; i++) {
        message += m;
        signatures += s0;
    }

    ecdsa.transactioncost(signatures, message)
}
