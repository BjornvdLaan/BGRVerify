const Web3 = require('web3');
const bn = require('bn.js');
const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');
const web3helpers = require('../web3helpers');

const bgrcontract = web3helpers.initTruffleContract(web3, 'BGRUtils');

function sendRequest(bgrcontract) {
    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        console.log('Sending from ' + requester);

        bgrcontract.deployed()
            .then((bgr) => {

                return bgr.HHash.call("0x0234", {
                    from: requester,
                    gas: 1000000,
                    value: 0
                })
                    .then(function (result) {
                        console.log(result);
                    })
                    .catch(e => {
                        console.log("Error");
                        console.log(e);
                    })
            })
            .catch(e => {
                console.log("BGR contract not deployed");
                console.log(e);
            });
    })
}


sendRequest(bgrcontract);