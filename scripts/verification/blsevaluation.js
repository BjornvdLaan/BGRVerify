const verifybls = require("../evaluation-utils/verifybls");

//Here we have only one function because the parameters is set in the contract.
//Note that to measure only verification costs, we cannot send the parameters in the transaction as it must be empty.
function test() {
    verifybls.verificationcost()
}

test();
