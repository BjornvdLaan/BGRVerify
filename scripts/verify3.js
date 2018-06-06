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

        const x = "0x"+"088cf203a408e3f4bcd7f05e38975286df6353727b6f5190fe5dc8838e32aa4909cb83f558fdab00b5e11d52d647e627189289a6197d63a0f8131f792b138e840ba5fb6a8e86067a76e70e09ba065ae81333e5a1fcd7f5af74f0466161633262e931f3c570f124c9fac86f7b1e548f699c4f3ad85a8cb05d81b9d76bf41166ed82e36211596b600c83b7fabb1706d32aefa677c2f5c691dd4fd4fcffa444c0bf79aec86b7be0a1ca5e9099d0c633a161baf57c514965d4cdce59a6f6e2d7ecc4361509f5a96d474feef1f6c73bbe3474a38f03b4874b8d456f6f520a3e97c53ab190297d78d95fd4d9f2e14cc84cbe261036a2dbd11b11238781736f274945c2";
        const h = "0x"+"18bbd80a078fa27598e23bb482ed8629214c16e1a09e63e5370c9803dd734027";

        const mess = "0x7b0a2020226f70656e223a207b0a20202020227072696365223a2039353931372c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333134323430302c0a2020202020202269736f223a2022323031362d31322d33315430303a30303a30302e3030305a220a202020207d0a20207d2c0a202022636c6f7365223a207b0a20202020227072696365223a2039363736302c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d2c0a2020226c6f6f6b7570223a207b0a20202020227072696365223a2039363736302c0a20202020226b223a20312c0a202020202274696d65223a207b0a20202020202022756e6978223a20313438333232383830302c0a2020202020202269736f223a2022323031372d30312d30315430303a30303a30302e3030305a220a202020207d0a20207d0a7d0a";
        //const file = fs.readFileSync(path.resolve(__dirname, "data.txt"));
        //const message = file.toString();

        const b = [
            false, true, false
        ];

        const r = [
           web3helpers.numToBytes16("333391106171597874365070154118950595603"),
            web3helpers.numToBytes16("137932939750162939875361196259164812064"),
            web3helpers.numToBytes16("136681385470202375642938843133624204485")
        ];

        bgrcontract.deployed()
            .then((bgr) => {
                return bgr.verify.call(mess, x, h, b, r, {
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
