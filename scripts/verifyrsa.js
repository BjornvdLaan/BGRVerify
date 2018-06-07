const Web3 = require('web3');
const BN = require('bn.js');
const fs = require('fs');
const path = require("path");
const web3helpers = require('../web3helpers');

const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');

function test() {
    const m = web3helpers.readtlsnproof();
    this.measure(m)
}

exports.measure = function(m, s) {
    const contract = web3helpers.initTruffleContract(web3, 'RSA');

    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        contract.deployed()
            .then((c) => {
                return c.doNothing(m, s, {
                    from: requester,
                    gas: 10000000000,
                    value: 0
                })
                    .then(function (result) {
                        console.log(result);
                        process.exit();
                    })
                    .catch(e => {
                        console.log("Error");
                        console.log(e);
                        process.exit();
                    })
            })
            .catch(e => {
                console.log("RSA contract not deployed");
                console.log(e);
            });

    })
};


exports.verify = function(S, N) {
    const contract = web3helpers.initTruffleContract(web3, 'RSA');

    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        //e = 65537
        //const e = "0x"+"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001";

        //const mess = "0x7b0a2020226f70656e223a207b0a20202020227072696365223a2039353931372c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333134323430302c0a2020202020202269736f223a2022323031362d31322d33315430303a30303a30302e3030305a220a202020207d0a20207d2c0a202022636c6f7365223a207b0a20202020227072696365223a2039363736302c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d2c0a2020226c6f6f6b7570223a207b0a20202020227072696365223a2039363736302c0a20202020226b223a20312c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d0a7d0a";
        const file = fs.readFileSync(path.resolve(__dirname, "data.txt"));
        const message = file.toString();

        contract.deployed()
            .then((c) => {
                return c.verify.call(message, S, N, { //Msg, S, e, N,
                    from: requester,
                    gas: 10000000000,
                    value: 0
                })
                    .then(function (result) {
                        console.log(result);
                        process.exit();
                    })
                    .catch(e => {
                        console.log("Error");
                        console.log(e);
                        process.exit();
                    })
            })
            .catch(e => {
                console.log("BTCPriceFeed contract not deployed");
                console.log(e);
            });

    })
};


