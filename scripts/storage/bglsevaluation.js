const verifybgls = require("../evaluation-utils/verifybgls");

//Here we have only one function because the parameters is set in the contract.
//Note that to measure only storage costs, we cannot send the parameters in the transaction as it must be empty.
function test() {
    verifybgls.storagecost()
}

test();
