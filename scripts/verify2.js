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

        const x = "0x"+"59f65609aeac118ed7a91b184cd8711153e6d51578503f15e73334d405282608bddfad37d9ec7c6c5c5d5a3f8fc3d649beac7dc71cce0fc6b1329327292fe3a4c4323aaed143e27dd4ff8e51d9fc0e04deb1f34f5d1ff21c1e8addb1c26a58695bfe885667b1f9da1553c864897949c33ab6b3cfdc0041351096070e5c0afd823bec63ed85cb82a961d083b462b96a6d178d652973eeb1542ffd3134310c2cc6491ed27cad55da1717292417f5fd6e24984deff5c3083afb809451a9c78179f7baf44b0a7b68b6d7cd15b8bfd593dd84083070e499fc1ccab05c5f6df7fd6d24f3490f59d9141db1cc2964fe620bceb1d63c3520b56caceee98b243cfa970b17";
        const h = "0x"+"7b2a7d809bedd3e6c3a1cffdd5925ffd38cabf53d42ba8b3abfaf735dcc34b11";

        const file = fs.readFileSync(path.resolve(__dirname, "data.txt"));
        const messages = web3.utils.fromAscii(file.toString());

        const b = [
            true, false
        ];

        const r = [
           web3helpers.numToBytes16("268948008018910961630238012180590377751"),
            web3helpers.numToBytes16("317847985574777981571057484699486990870"),
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
