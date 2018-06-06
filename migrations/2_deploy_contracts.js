const BGR = artifacts.require("./BGR.sol");
const BGR1 = artifacts.require("./BGR1.sol");
const BGR2 = artifacts.require("./BGR2.sol");
const BGR3 = artifacts.require("./BGR3.sol");
const RSA = artifacts.require("./RSA.sol");
const SolRsaVerify = artifacts.require("./SolRsaVerify.sol");

/*
const ECMath = artifacts.require("./imported/ECMath.sol");
const JsmnSolLib = artifacts.require("./imported/JsmnSolLib.sol");
const tlsnutils = artifacts.require("./imported/tlsnutils.sol");
const bytesutils = artifacts.require("./imported/bytesutils.sol");
const BTCPriceFeed = artifacts.require("./imported/BTCPriceFeed.sol");*/

module.exports = function(deployer) {
    deployer.deploy(BGR);
    deployer.deploy(BGR1);
    deployer.deploy(BGR2);
    deployer.deploy(BGR3);

    deployer.deploy(SolRsaVerify);
    deployer.link(SolRsaVerify, RSA);
    deployer.deploy(RSA);

   /* deployer.deploy(JsmnSolLib);
    deployer.deploy(ECMath);
    deployer.deploy(bytesutils);
    deployer.link(ECMath, tlsnutils);
    deployer.deploy(tlsnutils);
    deployer.link(JsmnSolLib, BTCPriceFeed);
    deployer.link(tlsnutils, BTCPriceFeed);
    deployer.deploy(BTCPriceFeed);*/
};
