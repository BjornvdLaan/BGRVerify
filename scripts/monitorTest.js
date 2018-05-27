
const web3helpers = require('../web3helpers');

web3helpers.monitorContractForEvent('ChainBridge', 'Test(uint256)', action);

function action(web3, contract, values) {
    console.log(values);
}
