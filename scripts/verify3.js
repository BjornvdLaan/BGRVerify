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

        const x = "0x"+"3b21a9dda31ffb94d1012c0e0a393a067cfff932243c6a64f9c9106e06d1a796335c4b9de0b65f205e7ddcf6d6b56671b8e4ecafa4fa62c3bb04015333837207e64ccf470b50c8128c4b753249c1db1bcdf6a17ec4c1e41f7068b379c06d6553748a062267b52a5c6e4940e0ff5370b879846a04aed471cdc02d75c151b5de602f205ca393926879e5d0a65870032f984122f5be906cbf2106c975b5bd1378bf68eb5d6611cabbe4491800a26f1a50decd4a9dc9230856e5288c257f0deb9231318b4fd66b6a4b5bdeda2dbc62e5db71d2babe6ec259ce3e688a53da5a613880a7116ef09de2118380d4b8868fdcb139ceb3c913ba7951c442fb0d5976ee15d2";
        const h = "0x"+"ca127b12ec3189d147cfde6e51c65ae33b2d10d12c7a807f54065b2302add67e";

        const file = fs.readFileSync(path.resolve(__dirname, "data.txt"));
        const messages = web3.utils.fromAscii(file.toString());

        const b = [
            false, true, true
        ];

        const r = [
           web3helpers.numToBytes16("44011108141733147288794966526338953606"),
            web3helpers.numToBytes16("28711110550438854586699967625114548538"),
            web3helpers.numToBytes16("19753315383334950541749376854845408665")
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
