const Web3 = require('web3');
const BN = require('bn.js');
const fs = require('fs');
const path = require("path");

const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');
const web3helpers = require('../web3helpers');

const bgr = web3helpers.initTruffleContract(web3, 'BGR1');

function test(bgrcontract) {
    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        const x = "0x"+"6aa4c8f9df23cd1a4c50dcec21ec46a7065548375d44692f8b0d22ec8f0ff66fb68d45c7880bf8285146e6b405a6b187217effba1eb6d513f36355d80e911b1a754582c21737132a8b67f1ba2095f9b68be9b66a804ad4d82b5a80fbb9b563511c47f6dfcc66ebb07701cc91e04fa029d1c2bc02a9ff923e93c9fe20b436e909395af3d75972d8c61a635c309f6adf2873053a1dcdf6e2eb606afa5c1ea85f583844b4d7723abef7e762d2487e5d94df2cf1e58aa652a02dce90a20b99267890e055865f8c702cd1bcfda98197668eae2b94e95d576a1c91aa340562b18d6cd020c30e4b39dcdce8b9a0acf83fac51905ac9f028cadf6264d2a8105649e6be81";
        const h = "0x"+"0a92dc927a31a94e271c75b4edf493979d6d8dd926fbe20959ac1eea21074cc0";

        const file = fs.readFileSync(path.resolve(__dirname, "data.txt"));
        const messages = web3.utils.fromAscii(file.toString());

        const b = [
            false
        ];

        const r = [
           web3helpers.numToBytes16("265835811824429664338401062584250790092"),
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
