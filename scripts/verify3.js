const Web3 = require('web3');
const BN = require('bn.js');
const fs = require('fs');
const path = require("path");

const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');
const web3helpers = require('../web3helpers');

const bgr = web3helpers.initTruffleContract(web3, 'BGR3');

function test(bgrcontract) {
    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        const x = "0x"+"36ce11d618b71bd08778e18e6585ce6eec46f76bfeab97ccabbda6c2776517429379b8878d90d386f60754bd2d6d94812fc9f2a0bd09114adccb715344b2a60e6bb25832f88cc3bf67dd5f9ada10c21285d974dd1821f88ff4a426e5ebfa730a724299cc93e1f2fc9082cd89d0e86e8207f12ef17da5bf2bbe7feb09b3a97596e13f8b3d8476141232d24c0f1c2eb06efcb1b224c3bcc4cde25b8ea84aac039109c4b5ed85f19277a4850b1a54064a9a0f8a96d23ad296670e510135b59fde549a81bdc53cdd892243155bcd2cc8d106528a61bebb2eed7245ab77f0aa0b6304e437a9682fd0cc89a981eedac0fef19cbd0ab12798b78694eaf34cb9e7d3df16";
        const h = "0x"+"23783dc26864903f19f605bac0215b326766b34fea20fe336475b4a9058228ac";

        const file = fs.readFileSync(path.resolve(__dirname, "data.txt"));
        const messages = web3.utils.fromAscii(file.toString());

        const b = [
            false, true, true
        ];

        const r = [
           web3helpers.numToBytes16("225495445128036427548827023765912921461"),
            web3helpers.numToBytes16("334408905011104911514059075100393524892"),
            web3helpers.numToBytes16("63066584171137077207317940529173657416")
        ];

        bgrcontract.deployed()
            .then((bgr) => {
                return bgr.verify.call(messages, x, h, b, r, {
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
                console.log("BGR contract not deployed");
                console.log(e);
            });

    })
}

test(bgr);
