const Web3 = require('web3');
const BN = require('../../node_modules/bn.js/lib/bn');
const fs = require('fs');
const path = require("path");
const web3helpers = require('../../web3helpers');

const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');

exports.measure = function(data) {
    const bgrcontract = web3helpers.initTruffleContract(web3, 'BTCPriceFeed');

    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        bgrcontract.deployed()
            .then((bgr) => {
                return bgr.doNothing(data, {
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
                console.log("BPF contract not deployed");
                console.log(e);
            });

    })
};

exports.verify = function() {
    const bpfcontract = web3helpers.initTruffleContract(web3, 'BTCPriceFeed');

    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        bpfcontract.deployed()
            .then((bpf) => {
                return bpf.sendNothing({
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
                console.log("BPF contract not deployed");
                console.log(e);
            });

    })
};

exports.store = function() {
    const bpfcontract = web3helpers.initTruffleContract(web3, 'BTCPriceFeed');

    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        bpfcontract.deployed()
            .then((bpf) => {
                return bpf.store({
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
                console.log("BPF contract not deployed");
                console.log(e);
            });

    })
};

exports.real = function(m) {
    const bpfcontract = web3helpers.initTruffleContract(web3, 'BTCPriceFeed');

    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        bpfcontract.deployed()
            .then((bpf) => {
                return bpf.verifyProof(m, {
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
                console.log("BPF contract not deployed");
                console.log(e);
            });

    })
};


