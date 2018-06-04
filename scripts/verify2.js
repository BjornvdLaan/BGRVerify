const Web3 = require('web3');
const BN = require('bn.js');
const fs = require('fs');
const path = require("path");

const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');
const web3helpers = require('../web3helpers');

const bgr = web3helpers.initTruffleContract(web3, 'BGR2');

function test(bgrcontract) {
    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        const x = "0x"+"36210f1eaa58c9135c3e93b264268b4032ad2ac5aadb1672e77b166025a901a55e8cd1cf5fa69c9ae09554bad983ef97e97a85a374df19e6959e684fe1d67a9c9193225f90c59022363ca9c1a9cbbab1eccb3f1c35f4bf7390f2c955de9c0c832ac5c8c3f75066d18dae2deba2d943b22d35fff01c021b77f05973cbe0b1368bb10bc86f81574cb6e27951a149baa1c9d24d63046e65351b183bb33bad4e44d54d020238d506f4df0857a114a88e2161c4282f6b596aa4b9a1aaa21205f2197b55ab2f6c5894d36308baa1438b8f58b3cada1aeee01e55ca83e072f3595f4bee0a77ee75d338722c9287c59d6b7dce3ef3c41a2d51e070997536bb3185495114";
        const h = "0x"+"69159ca66eb1013e224a028330df01af1853e578aea5cf2229b9fee5318d4eb4";

        const file = fs.readFileSync(path.resolve(__dirname, "data.txt"));
        const messages = web3.utils.fromAscii(file.toString());

        const b = [
            false, true
        ];

        const r = [
           web3helpers.numToBytes16("295861542596530581502292159834468553591"),
            web3helpers.numToBytes16("154686797698250898610729967226869016357"),
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
