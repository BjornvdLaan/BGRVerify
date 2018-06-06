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

        const x = "0x"+"1e1c7b9bc6bcec8b618ebe144dedba7ad7de6dcea0491c90023d6b7f2dce58cc3c5b37a935ee5605db228772f224d3cb432ce9a92d1147b7a3917c94ba5634d2a0a54045650e71a552480c78265c8857920709c8093d626ca509cdb8a0c8c9b825a5b25e1a73a87f90cce80ec6cbed8948837d0da46968978f1f35741a694e54f378911c16d9a228cd6f0556df245924f9ed9b5f81011cefe1331ffa977c595734a0c31417a6dd0e9f54b310cfbe4348e00465be8f4d48576e03350a25f9b943993269c37936bcd5a1b0a21699ee3b198c905d323522388aa61c8c6e1d0d1b2e92d54d2ee68e97068a5f9228354508087baca06963952e274ea4b85f093c848f";
        const h = "0x"+"446aa0456833d61ead99a7d1998d9bf03b181c0405047509ec14eb4e3d68ade6";

        const file = fs.readFileSync(path.resolve(__dirname, "data.txt"));
        const messages = web3.utils.fromAscii(file.toString());

        const b = [
            false
        ];

        const r = [
           web3helpers.numToBytes16("335793088587930081617415486119028002169"),
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
