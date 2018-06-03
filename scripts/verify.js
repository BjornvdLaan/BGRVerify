const Web3 = require('web3');
const BN = require('bn.js');
const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');
const web3helpers = require('../web3helpers');

const bgrcontract = web3helpers.initTruffleContract(web3, 'BGR');
const bgrsmall = web3helpers.initTruffleContract(web3, 'BGRBig');

function test(bgrcontract) {
    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];
        //console.log('Sending from ' + requester);

        //not working yet
        const messages = [
            "MESSAGE 0",
            "MESSAGE 1",
            "MESSAGE 2"
        ];

        const b = [
            false, false, true
        ];


        const r = [
           web3helpers.numToBytes16("292515598745754236261268930538829626862"),
            web3helpers.numToBytes16("143732175038022762536275231211399109350"),
            web3helpers.numToBytes16("155010501534977254474133447094281593683")
        ];

        bgrcontract.deployed()
            .then((bgr) => {
                return bgr.verify.call(messages, b, r, {
                    from: requester,
                    gas: 10000000000,
                    value: 0
                })
                    .then(function (result) {
                        console.log(result);
                        console.log(web3.utils.hexToBytes(result));
                        process.exit();
                    })
                    .catch(e => {
                        console.log("Error");
                        console.log(e);
                        process.exit();
                    })
            })
            .catch(e => {
                console.log("BGR contract not deployed");
                console.log(e);
            });

    })
}

test(bgrsmall);
