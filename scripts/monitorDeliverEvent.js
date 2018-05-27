
const web3helpers = require('../web3helpers');

web3helpers.monitorContractForEvent('ChainBridge', 'DeliveryEvent(uint256,bytes32[])', action);

function action(web3, contract, values) {
    console.log(values);
}
