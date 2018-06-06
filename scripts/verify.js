const Web3 = require('web3');
const BN = require('bn.js');
const fs = require('fs');
const path = require("path");

const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');
const web3helpers = require('../web3helpers');

const bgr = web3helpers.initTruffleContract(web3, 'BGR');

function test(bgrcontract) {
    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        // const file = fs.readFileSync(path.resolve(__dirname, "data.txt"));
        // const messages = web3.utils.fromAscii(file.toString());

        //the json in scripts/data.txt
        const message = "0x7b0a2020226f70656e223a207b0a20202020227072696365223a2039353931372c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333134323430302c0a2020202020202269736f223a2022323031362d31322d33315430303a30303a30302e3030305a220a202020207d0a20207d2c0a202022636c6f7365223a207b0a20202020227072696365223a2039363736302c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d2c0a2020226c6f6f6b7570223a207b0a20202020227072696365223a2039363736302c0a20202020226b223a20312c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d0a7d0a";

        const x = "0x"+"0fcbda1a3d3a1a1b75512b60999f62db367b2fdaf18a5b64a00507de8f387ab5489f19c90ce8fc87cfc46ce009bda5d4af8d538aadc5422bf5fc0a4be30de6eb53b463b1f2fe10efb0127efb68160e52540cbfef0d9b5b068914f881fc516ab7d49a87be63f466529f389f0b6580ec179d7dd4234139643e2de05eb779c450d017149a6dd57dfeb782ab3afb2415886087843d696e0c712819851f73327bbb0ab844305440d34d94775bd39c3f593a467982effdbd32d83bd2234ac064b37ccade4c17e45e872d4c5f1828f928a5c8fd6aca5ff9eade6b9c17aebaf92c59493747acc6f69a3e861c4339c34e8161f25ab8de1b0feca67bf92c73cdbb1dfeb95a";
        const h = "0x"+"04e723b1f055a4cf92dbf84a22fcceff0b646437fc1be688aec41688cc3fb6bb";

        const b = [
            false
        ];

        const r = [
            web3helpers.numToBytes16("133092795748730156840365002090010039470"),
        ];

        bgrcontract.deployed()
            .then((bgr) => {
                return bgr.verify.call(message, x, h, b, r, {
                    from: requester,
                    gas: 10000000000,
                    value: 0
                })
                    .then(function (result) {
                        console.log(result);
                        console.log("successful");
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
