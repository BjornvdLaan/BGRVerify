const BGR = artifacts.require("./BGR.sol");

const ECDSA = artifacts.require("./ECDSA.sol");

const BLS = artifacts.require("./BLS.sol");
const BGLS = artifacts.require("./BGLS.sol");
const BLSE = artifacts.require("./BLSE.sol");

const RSA = artifacts.require("./RSA.sol");
const SolRsaVerify = artifacts.require("./SolRsaVerify.sol");

const ECMath = artifacts.require("./imported/ECMath.sol");
const JsmnSolLib = artifacts.require("./imported/JsmnSolLib.sol");
const tlsnutils = artifacts.require("./imported/tlsnutils.sol");
const bytesutils = artifacts.require("./imported/bytesutils.sol");
const BTCPriceFeed = artifacts.require("./imported/BTCPriceFeed.sol");

module.exports = function(deployer) {
    //deployer.deploy(BLSE);

    deployer.deploy(ECDSA);


    /*  //MUSCLE-TP
      deployer.deploy(BGR);
      //RSA
      deployer.deploy(SolRsaVerify);
      deployer.link(SolRsaVerify, RSA);
      deployer.deploy(RSA);
      //MUSCLE-BP
      deployer.deploy(BGLS);


      //BLS
      deployer.deploy(BLS);
      //TLSN
      deployer.deploy(JsmnSolLib);
      deployer.deploy(ECMath);
      deployer.deploy(bytesutils);
      deployer.link(ECMath, tlsnutils);
      deployer.deploy(tlsnutils);
      deployer.link(JsmnSolLib, BTCPriceFeed);
      deployer.link(tlsnutils, BTCPriceFeed);
      deployer.deploy(BTCPriceFeed);
      */
};
