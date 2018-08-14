const bls = require("../evaluation-utils/verifybls");
const web3helpers = require('../../web3helpers');
const BN = require("web3").utils.BN;

const m = web3helpers.readfile();
const s = [new BN('11181692345848957662074290878138344227085597134981019040735323471731897153462'), new BN('6479746447046570360435714249272776082787932146211764251347798668447381926167')];

measureTransactionCost(parseInt(process.argv[2]));

function measureTransactionCost(number_of_signers) {
    //create message of right size
    let message = "";
    let signatures = s;
    for (let i = 0; i < number_of_signers; i++) {
        message += m;

        if (i > 0) {
            signatures = [...signatures, ...s];
        }
    }

    bls.transactioncost(signatures, message)
}
