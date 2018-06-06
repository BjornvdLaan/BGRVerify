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

        const x = "0x"+"0db96f18e5aba34c51e896781c72a386df32f8e181ced4dc4ed032d285a6c06f4104726ad5d169b03506b968d64f3fd5f237e2f38ed519dfbc90bfd7456163ce709ba210b16aeed72c24396245ea0816153667d2bdc66d9f7e5b4fbb83a53a413893683da7dcce99c7e5750d39f2efca76b01ff742b6ec5d4d1dd666f866470a8e7e8e2add243d7cb64edbc612df3b4eefb965c6650ff0598b633317edbf252aa56f8ed74e590186390422000f1acb030c048758fb855b246d95b9ddee5f0a6cbd2f7f2c6afa29a9358bf293b8967a46d640c3c723755d4bcf3991723796ea3d6c5b5ada594a61764858bfd7a5664e12418486a08620da0b98234e9daa2301b3";
        const h = "0x"+"cc7fb272bd2044b45eec38feb347388124f2f07346a9d1ae980de19dd5e786e5";

        //const mess = "0x7b0a2020226f70656e223a207b0a20202020227072696365223a2039353931372c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333134323430302c0a2020202020202269736f223a2022323031362d31322d33315430303a30303a30302e3030305a220a202020207d0a20207d2c0a202022636c6f7365223a207b0a20202020227072696365223a2039363736302c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d2c0a2020226c6f6f6b7570223a207b0a20202020227072696365223a2039363736302c0a20202020226b223a20312c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d0a7d0a";
        const file = fs.readFileSync(path.resolve(__dirname, "data.txt"));
        const message = file.toString();

        const b = [
            false, false, true
        ];

        const r = [
           web3helpers.numToBytes16("148188578693127824421321938929073000890"),
            web3helpers.numToBytes16("143289089384635942834491644280063968009"),
            web3helpers.numToBytes16("196668985635432548435435474890493737120")
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
