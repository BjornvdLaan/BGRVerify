const Web3 = require('web3');
const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');
const web3helpers = require('../web3helpers');

const chainBridgeContract = web3helpers.initTruffleContract(web3, 'ChainBridge');
const requesterContract = web3helpers.initTruffleContract(web3, 'Requester');


function sendRequest(cbContract, rContract) {
    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];
        console.log('Sending from ' + requester);

        cbContract.deployed()
            .then((chainbridge) => {

                rContract.deployed()
                    .then((callback) => {
                        console.log('Sending transaction to contract ' + chainbridge.address);
                        console.log('Callback address ' + callback.address);
                        return chainbridge.request([22222222, 22222222], callback.address, {from: requester, gas: 1000000, value: 10000})
                            .then(function (result) {
                                console.log('Transaction successful');
                                console.log(result);
                                process.exit()
                            })
                            .catch(e => {
                                console.log("Transaction failed");
                                console.log(e);
                            });
                    })
                    .catch(e => {
                        console.log("Requester not deployed");
                        console.log(e);
                    });
            })
            .catch(e => {
                console.log("ChainBridge not deployed");
                console.log(e);
            });
    });
}

sendRequest(chainBridgeContract, requesterContract);
