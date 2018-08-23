const ecdsa = require("../evaluation-utils/verifyecdsa");
const web3helpers = require('../../web3helpers');
const BN = require("web3").utils.BN;

const m = web3helpers.readfile();

const s0 = "f6da5793bcdbb8dba81fcbdba6b1b65121c326e0bc446d3ed8ae43d89b1a9f2b1009f3befd307edd50f6ddafd6c61183156c72658174997ec70aabccc0e6e3c200";

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
