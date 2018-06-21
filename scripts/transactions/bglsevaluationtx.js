const bgls = require("../evaluation-utils/verifybgls");
const web3helpers = require('../../web3helpers');
const BN = require("web3").utils.BN;

//load message
const m = web3helpers.readfile();

measureTransactionCost(parseInt(process.argv[2]));

function measureTransactionCost(number_of_signers) {
    //create message of right size
    let message = "";
    for (let i = 0; i < number_of_signers; i++) {
        message += m;
    }

    //an example signature (size is always constant anyway)
    const sig = [new BN('5184658216108236166487848590876511837733486685529854097237373095672855537357'), new BN('8330930853020054953908886276405410407605755848046343130652944150060164059116')];

    bgls.transactioncost(sig, message)
}
