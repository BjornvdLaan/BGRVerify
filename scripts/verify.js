const Web3 = require('web3');
const bn = require('bn.js');
const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');
const web3helpers = require('../web3helpers');

const bgrcontract = web3helpers.initTruffleContract(web3, 'BGR');
const bgrsmall = web3helpers.initTruffleContract(web3, 'BGRSmall');

function sendRequest(bgrcontract) {
    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        console.log('Sending from ' + requester);

        bgrcontract.deployed()
            .then((bgr) => {
                const a_val = "6776352c8bcd1d6e6b7f5b825a2acebb7e77abbb7cc5ef55b1913d7ce0010f6ae20886db111d14c94bc045b5f145037481d8398998af7906086fb7dc25eab544bedac235f2a7fb6c540443495791eb3fd800719f075488c66c7f5028e5cbc21c974b2d365ff35f9ea1c7209de05b4465510cf03536ae6477fab203c86e50a4db";
                const b_val = "6e3b4d7e8980aba295c68e45e2f891d8e86a554185288c01f9008a86a7c96f05a7ef679958ac34d62744dd72af23212d10209cae7554c94fe5623c1b5d0af4e0d5af46cad9dc3860c2018acf16d9a7e14156cdccbf74ae93479e239292b7d04e343954b8519c61aeb4144a6d5f07c075602936a89980ae25f2d07938906d2849";
                const mod_val = "dc769afd130157452b8d1c8bc5f123b1d0d4aa830a511803f201150d4f92de0b4fdecf32b15869ac4e89bae55e46425a2041395ceaa9929fcac47836ba15e9c1ab5e8d95b3b870c18403159e2db34fc282ad9b997ee95d268f3c4725256fa09c6872a970a338c35d682894dabe0f80eac0526d5133015c4be5a0f27120da5093";

                const a_bn = new bn(a_val, 16);
                const b_bn = new bn(b_val, 16);
                const mod_bn = new bn(mod_val, 16);

                const a_neg = false;
                const b_neg = false;
                const mod_neg = false;

                const a_msb = a_bn.bitLength();
                const a_msb_enc = "0".repeat(64 - a_bn.bitLength().toString(16).length) + a_bn.bitLength().toString(16);

                const b_msb = b_bn.bitLength();
                const b_msb_enc = "0".repeat(64 - b_bn.bitLength().toString(16).length) + b_bn.bitLength().toString(16);

                const mod_msb = mod_bn.bitLength();
                const mod_msb_enc = "0".repeat(64 - mod_bn.bitLength().toString(16).length) + mod_bn.bitLength().toString(16);

                const a_val_enc = "0x" + a_val;
                const b_val_enc = "0x" + b_val;
                const mod_val_enc = "0x" + mod_val;

                const a_extra_enc = "0x" + "0".repeat(63) + ((a_neg === true) ? "1" : "0") + a_msb_enc;
                const b_extra_enc = "0x" + "0".repeat(63) + ((b_neg === true) ? "1" : "0") + b_msb_enc;
                const mod_extra_enc = "0x" + "0".repeat(63) + ((mod_neg === true) ? "1" : "0") + mod_msb_enc;

                return bgr.verify.call(a_val_enc, a_extra_enc, b_val_enc, b_extra_enc, mod_val_enc, mod_extra_enc, {
                    from: requester,
                    gas: 1000000,
                    value: 0
                })
                    .then(function (result) {
                        console.log(result);
                    })
                    .catch(e => {
                        console.log("Error");
                        console.log(e);
                    })
            })
            .catch(e => {
                console.log("BGR contract not deployed");
                console.log(e);
            });
    })
}

function test(bgrcontract) {
    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        console.log('Sending from ' + requester);

        bgrcontract.deployed()
            .then((bgr) => {
                return bgr.verify.call({
                    from: requester,
                    gas: 10000000000,
                    value: 0
                })
                    .then(function (result) {
                        console.log(result);
                        console.log(web3.utils.hexToBytes(result));
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

test(bgrsmall);
