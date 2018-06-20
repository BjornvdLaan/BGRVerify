const verifybgls = require("../evaluation-utils/verifybgls");
const web3helpers = require('../../web3helpers');

const m = web3helpers.readfile();

switch (parseInt(process.argv[2])) {
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
    case 6:
        six();
        break;
    case 7:
        seven();
        break;
    case 8:
        eight();
        break;
    case 9:
        nine();
        break;
    case 10:
        ten();
        break;
    default:
        console.log("Destination unknown");
}

function one() {
    verifybgls.measure()
}

function two() {
    const S = s0+s1;

    verifybgls.measure(m+m, S)
}

function three() {
    const S = s0+s1+s2;
    verifybgls.measure(m+m+m, S)
}

function four() {
    const S = s0+s1+s2+s3;
    verifybgls.measure(m+m+m+m, S)
}

function five() {
    const S = s0+s1+s2+s3+s4;
    verifybgls.measure(m+m+m+m+m, S)
}

function six() {
    const S = s0+s1+s2+s3+s4+s5;
    verifybgls.measure(m+m+m+m+m+m, S)
}

function seven() {
    const S = s0+s1+s2+s3+s4+s5+s6;
    verifybgls.measure(m+m+m+m+m+m+m, S)
}

function eight() {
    const S = s0+s1+s2+s3+s4+s5+s6+s7;
    verifybgls.measure(m+m+m+m+m+m+m+m, S)
}

function nine() {
    const S = s0+s1+s2+s3+s4+s5+s6+s7+s8;
    verifybgls.measure(m+m+m+m+m+m+m+m+m, S)
}

function ten() {
    const S = s0+s1+s2+s3+s4+s5+s6+s7+s8+s9;
    verifybgls.measure(m+m+m+m+m+m+m+m+m+m, S)
}
