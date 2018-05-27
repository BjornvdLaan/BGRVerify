const Web3 = require('web3');
const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");
// connect to ethereum node
web3.eth.abi ? console.log('Web3 successful') : console.log('Web3 not connected error');

console.log(web3.eth.abi.encodeEventSignature('RequestEvent(uint256,bytes32[])'));
