const Web3 = require('web3');
const BN = require('../../node_modules/bn.js/lib/bn');
const fs = require('fs');
const path = require("path");
const web3helpers = require('../../web3helpers');

const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');

exports.transactioncost = function(sigs, msgs) {
    const ecdsacontract = web3helpers.initTruffleContract(web3, 'ECDSA');

    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        ecdsacontract.deployed()
            .then((ecdsa) => {
                return ecdsa.transactioncost(msgs, sigs, {
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
                console.log("ECDSA contract not deployed");
                console.log(e);
            });

    })
};

exports.verificationcost = function() {
    const contract = web3helpers.initTruffleContract(web3, 'ECDSA');

    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        contract.deployed()
            .then((c) => {
                return c.verificationcost({
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
                console.log("ECDSA contract not deployed");
                console.log(e);
            });

    })
};

exports.storagecost = function() {
    const contract = web3helpers.initTruffleContract(web3, 'ECDSA');

    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        contract.deployed()
            .then((c) => {
                return c.storagecost({
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
                console.log("ECDSA contract not deployed");
                console.log(e);
            });

    })
};
