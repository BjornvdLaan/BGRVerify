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

        const x = "0x"+"274104063f20471b125b89cac9d40d5dc132d9088fb30d2bc5104cdc227769d80047c5160c0e208af785663e9b09314a7d57476ff498cd8b5c209693d062b71c439d997c9d7346bc0b1c6324a03aa98cc6d2cacb53c53dd8d2a9b8f969a058111a6918e3b41ad5a2d5fcde79e483b23caadff0fe053fee6c6c2f055b9e440de380a3bcfe995770d37b539497620b885d297468355d33c69bbed93b7a52cca3461d6dd6ec5a68a53902d8fca787f237d33fecf333df633d3745a0d3e6296c0743f12a798f63eb9428d921bb28e63515071c51533f6b677d8f578502875c9b0b915f0ab7bb27e5973d41c8bfd24181aaeac780d9f450cae9cd8e1b99ac616a82ce";
        const h = "0x"+"2a3755351b72a4aebacfe3a2d61e37f0d67d0b2e0b2d66408d4c1a00ce1035d0";

        //const mess = "0x7b0a2020226f70656e223a207b0a20202020227072696365223a2039353931372c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333134323430302c0a2020202020202269736f223a2022323031362d31322d33315430303a30303a30302e3030305a220a202020207d0a20207d2c0a202022636c6f7365223a207b0a20202020227072696365223a2039363736302c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d2c0a2020226c6f6f6b7570223a207b0a20202020227072696365223a2039363736302c0a20202020226b223a20312c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d0a7d0a";
        const file = fs.readFileSync(path.resolve(__dirname, "data.txt"));
        const message = file.toString();

        const b = [
            false, true, false
        ];

        const r = [
           web3helpers.numToBytes16("220590962434088044779953837348028961335"),
            web3helpers.numToBytes16("12536054357843948037626657192362949671"),
            web3helpers.numToBytes16("13872896002180505972619963923798272761")
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
