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


exports.verify = function() {
    const contract = web3helpers.initTruffleContract(web3, 'RSA');

    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        contract.deployed()
            .then((c) => {
                return c.sendNothing({//message, S, N, { //Msg, S, e, N,
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


