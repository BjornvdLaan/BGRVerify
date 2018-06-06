const Web3 = require('web3');

const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');
const web3helpers = require('../web3helpers');

const rsa = web3helpers.initTruffleContract(web3, 'RSA');

function test(contract) {
    web3.eth.getAccounts().then((accounts) => {
        const requester = accounts[1];

        const e = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001";
        const Msg = "4d455353414745";
        const S = "2eddfd1e51c014719d226f739fcde9724e246cf12c09ef9f9ff742b77bf8d4e6b2163aa2a42249e22b6d8660a552b2d39eef771be327210d1531ef6706e95866771530f0c37dcb703e5e6dc5dee0190c1c170419bdd1494427c784cf27b7c889bb2dbe45b4845bc296fbdaac9c09a8d0e9322e7bc1f241ba89231b58a96e4c0e1f1589b66fe69bba401fe4d849abfa2092aefe5f6501f050606691eb6195dce694837bc016eb30fe719f8a8f2bb7ea095cdaee754a209fc4464155b7654fde9fead1cf27a1105935680eb89b24ee7490a248abada100ab63df86593d04dd583a2ed79bce865e11bd62785fa75943f542467ef8e52b8cbb0cfad2d81309b1e641";
        const N = "981738fcbbb695c3d97599593c39f153a386ff630b59bc566a34e86ca414db193976ccbe5680e063c1409278caa9ded202f2570f1f72f17f86338515c548de8473b024d25df8ed6270f3b949da6216b87e8b782677855275419470d258ba4f33646c3c09c790561deff7f0a340134d110c492a0389eef545f8a07bca8ded97e1691f591f172889ced1ffc5932d913debc28dd884ebc80f94b0b8b3fc50c76beb5558917b8758ebf05c9fcf8b09a8d68e30430bf0a9c4c19b09ae387bb32816a9fec1c7faa5c6a4958959cbc909f0113601fc36cf419d89af67ba42b3aefaec07ab0a2583c78c4243ae060d9236eee94395c37d608a6587fe419f38215b5488ed";

        contract.deployed()
            .then((c) => {
                return c.verify.call("0x" + Msg, "0x" + S, "0x" + e, "0x" + N, {
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
                console.log("BTCPriceFeed contract not deployed");
                console.log(e);
            });

    })
}

test(rsa);
