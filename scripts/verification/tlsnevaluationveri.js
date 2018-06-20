const tlsn = require("../evaluation-utils/verifytlsn");

verify();

//Here we have only one function because the parameters is set in the contract.
//Note that to measure only verification costs, we cannot send the parameters in the transaction as it must be empty.
function verify() {
    tlsn.verify()
}
