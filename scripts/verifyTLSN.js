const Web3 = require('web3');
const fs = require('fs');
const path = require("path");

const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');
const web3helpers = require('../web3helpers');

const bpf = web3helpers.initTruffleContract(web3, 'BTCPriceFeed');

function test(contract) {
    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        const file = fs.readFileSync(path.resolve(__dirname, "btcfeed.proof"));
        const json = file.toString();
        const hex = web3.utils.asciiToHex(json);
        console.log(hex);

        //web3.utils.asciiToHex(string)
        contract.deployed()
            .then((bpf) => {
                return bpf.verify.call(json, {
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
}

test(bpf);
