
const web3helpers = require('../web3helpers');

web3helpers.monitorContractForEvent('Requester', 'Delivered()', action);

function action(web3, contract, values) {
    console.log(values);
}
