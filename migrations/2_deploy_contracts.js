const BGRBig = artifacts.require("./BGRBig.sol");
const BGR3 = artifacts.require("./BGR3.sol");
const BGR2 = artifacts.require("./BGR2.sol");


module.exports = function(deployer) {
    deployer.deploy(BGR2);
    deployer.deploy(BGRBig);
    deployer.deploy(BGR3);
};
