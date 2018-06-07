const tlsn = require("../verifytlsn");
const web3helpers = require('../../web3helpers');

const m = web3helpers.readtlsnproof();


switch (parseInt(process.argv[2])) {
    case 0:
        z();
        break;
    case 1:
        one();
        break;
    case 2:
        two();
        break;
    case 3:
        three();
        break;
    case 4:
        four();
        break;
    case 5:
        five();
        break;
    default:
        console.log("Destination unknown");
}

function z() {
    tlsn.verify(web3helpers.readtlsnproof())
}

function one() {
    tlsn.measure(m)
}

function two() {
    tlsn.measure(m+m)
}

function three() {
    tlsn.measure(m+m+m)
}

function four() {
    tlsn.measure(m+m+m+m)
}

function five() {
    tlsn.measure(m+m+m+m+m)
}
