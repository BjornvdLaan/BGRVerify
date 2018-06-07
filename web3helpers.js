const BN = require('bn.js');
const fs = require('fs');
const path = require("path");

web3 = connectToNode();


function monitorContractForEvent(contractName, event, action) {
    const contract = initTruffleContract(web3, contractName);

    const eventTopic = web3.eth.abi.encodeEventSignature(event);

    contract.deployed().then((instance) => {

        const contractAddress = instance.address;
        console.log('Monitoring contract ' + contractAddress + ' for ' + event);

        web3.eth.subscribe('logs', {
            fromBlock: 0,
            toBlock: 'latest',
            address: contractAddress,
            topics: [eventTopic]
        }, function(error){
            if (error)
                console.log(error);
        })
            .on("data", function(log){
                console.log('Event detected');

                if(log.topics[0] === eventTopic) {
                    console.log('Event identified as '+ event +'. Proceeding.');

                    //extract parameters
                    const requestEventABI = instance.abi.filter((item) => item.type === 'event' && item.name === event.substr(0, event.indexOf('(')))[0];

                    //get types
                    const types = [];
                    for(let i = 0; i < requestEventABI.inputs.length; i++) {
                        types[i] = requestEventABI.inputs[i].type;
                    }

                    //decode parameters
                    console.log(log.data)
                    const data = web3.eth.abi.decodeParameters(types, log.data);

                    //handle the request
                    action(web3, instance, data);
                } else {
                    console.log('Not a RequestEvent, but ' + log.topics + '. Ignore.');
                }
            });
    });
}

function estimateGas(contractName, functionName, parameters) {
    const contract = initTruffleContract(web3, contractName);

    contract.deployed().then((instance) => {

        instance[functionName]['estimateGas'].apply(null, parameters)
            .then(gas => console.log('Gas estimation for ' + contractName + '.' + functionName + ': ' + gas))
            .catch(e => console.log(e));
    });
}

function connectToNode() {
    const Web3 = require('web3');
    const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
    // connect to ethereum node
    web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');

    return web3;
}

function initTruffleContract(web3, contractName) {
    const contract = require('truffle-contract');
    const initContract = contract(require('./build/contracts/' + contractName + '.json'));
    initContract.setProvider(web3.currentProvider);

    //hack for web3js@1.0.0
    if (typeof initContract.currentProvider.sendAsync !== "function") {
        initContract.currentProvider.sendAsync = function() {
            return initContract.currentProvider.send.apply(
                initContract.currentProvider, arguments
            );
        };
    }

    return initContract;
}

function decodeParameter(type, hex) {
    return web3.eth.abi.decodeParameter(type, hex);
}

function convertTo32ByteHexArray(dataArray) {
    const data = [];

    for(let i = 0; i < dataArray.length; i++) {
        data[i] = convertTo32ByteHex(dataArray[i]);
    }

    return data;
}

function numberToHex(number) {
    return web3.utils.numberToHex(number);
}

function getRandomIntInHex() {
    const min = 1;
    const max = 5000;
    return web3.utils.numberToHex(Math.floor(Math.random() * (max - min + 1)) + min);
}

function stringToHex(string){
    let hex, i;
    let result = "";

    for (i=0; i< string.length; i++) {
        hex = string.charCodeAt(i).toString(16);
        result += hex;
    }

    return result
}

function numToBytes16(num) {
    let n = new BN(num).toString(16);
    while (n.length < 32) {
        n = "0" + n;
    }
    return "0x" + n;
}

function convertTo32ByteHex(data) {
    let hex;

    switch(typeof data) {
        case 'string':
            hex = stringToHex(data);
            break;
        case 'number':
            hex = web3.utils.numberToHex(data); //data.toString(16);
            break;
        default:
            console.log('Error');
    }

    while (hex.length < 32) {
        hex = hex + '0';
    }

    return hex;
}

function evaluationSetup(testFunction) {
    const web3 = connectToNode();
    const cbContract = initTruffleContract(web3, 'ChainBridge');
    const rContract = initTruffleContract(web3, 'Requester');

    const fee = 54151;

    web3.eth.getAccounts().then((accounts) => {
        const offchainWallet = accounts[0];
        const requester = accounts[1];

        cbContract.deployed()
            .then((chainbridge) => {

                rContract.deployed()
                    .then((callback) => {
                        console.log('Sending request to ChainBridge contract at ' + chainbridge.address);
                        console.log('Callback address: ' + callback.address);

                        testFunction(web3, offchainWallet, requester, chainbridge, fee, callback);
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

function readtlsnproof() {
    const file = fs.readFileSync(path.resolve(__dirname, "scripts/tls-n.proof"), 'utf8');
    return file.toString()
}

function readfile() {
    const file = fs.readFileSync(path.resolve(__dirname, "scripts/data.txt"));
    return file.toString()
}

module.exports = {
    initTruffleContract: initTruffleContract,
    monitorContractForEvent: monitorContractForEvent,
    convertTo32ByteHexArray: convertTo32ByteHexArray,
    estimateGas: estimateGas,
    getRandomIntInHex: getRandomIntInHex,
    connectToNode: connectToNode,
    evaluationSetup: evaluationSetup,
    numberToHex: numberToHex,
    numToBytes16: numToBytes16,
    readfile: readfile,
    readtlsnproof: readtlsnproof
};
