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

        const x = "0x"+"1963eb228b29aa638b7467ee1ef7f99b9dcf57376f7ffd4ba2ac89bce6aa4b9897d15a38ee50593da21df8bc8da1dd896f1d884d9c525a625e023f8db6971c4e93610b69789b1d4dd8bb76357893c23125c13aab0c2ea9dd918dae2221558a2c6a82d940d73ed94cbff499ec011693632bb83d4f8d3c021ecb3bf689f12632549e7cf8a7b5852689842725cfca8e8872b4b431cdc6a09d586cec74b45f568976675c651e1af2417c7dd8a5ddae76e5d4d1ba55f3c3906800ac31b716e4a88c2ec0bb7530945c33307c8a8e09d66833e4d5e91662b9fca86f7a646ce17b903819afa9de312f7bddb4ba4b7abca2d30aa788783c33962aa6913b652347781013d4";
        const h = "0x"+"d569d03f0d1e22ed1a05fc89fa3535d612a22e953d46a49260cc9e4ec26dc7c3";

        const file = fs.readFileSync(path.resolve(__dirname, "data.txt"));
        const messages = web3.utils.fromAscii(file.toString());

        const b = [
            false, false, false
        ];

        const r = [
           web3helpers.numToBytes16("220098966613042795477468838214699186817"),
            web3helpers.numToBytes16("7690777420360954098326429067039436508"),
            web3helpers.numToBytes16("82904766392072051094742894493816922822")
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
