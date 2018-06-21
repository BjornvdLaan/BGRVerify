const verifybls = require("../evaluation-utils/verifybls");
const web3helpers = require('../../web3helpers');
const BN = require("web3").utils.BN;

const m = web3helpers.readfile();
const s0 = [new BN('11181692345848957662074290878138344227085597134981019040735323471731897153462'), new BN('6479746447046570360435714249272776082787932146211764251347798668447381926167')];


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
    const S = s0;
    verifybls.measure(S, m)
}

function two() {
    const S = s0.concat(s0);
    verifybls.measure(S, m+m)
}

function three() {
    const S = s0.concat(s0, s0);
    verifybls.measure(S, m+m+m)
}

function four() {
    const S = s0.concat(s0, s0, s0);
    verifybls.measure(S, m+m+m+m)
}

function five() {
    const S = s0.concat(s0, s0, s0, s0);
    verifybls.measure(S, m+m+m+m+m)
}

function six() {
    const S = s0.concat(s0, s0, s0, s0, s0);
    verifybls.measure(S, m+m+m+m+m+m)
}

function seven() {
    const S = s0.concat(s0, s0, s0, s0, s0, s0);
    verifybls.measure(S, m+m+m+m+m+m+m)
}

function eight() {
    const S = s0.concat(s0, s0, s0, s0, s0, s0, s0);
    verifybls.measure(S, m+m+m+m+m+m+m+m)
}

function nine() {
    const S = s0.concat(s0, s0, s0, s0, s0, s0, s0, s0);
    verifybls.measure(S, m+m+m+m+m+m+m+m+m)
}

function ten() {
    const S = s0.concat(s0, s0, s0, s0, s0, s0, s0, s0, s0);
    verifybls.measure(S, m+m+m+m+m+m+m+m+m+m)
}
