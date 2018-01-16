var EMXICO = artifacts.require("./EMXICO.sol");

module.exports = function(deployer, network, accounts) {
  const preSaleStartTime = 1516089495;
  const preSaleEndTime = preSaleStartTime + 15*24*60*60*1000;
  const mainSaleStartTime = preSaleEndTime + 1;
  const mainSaleEndTime = mainSaleStartTime + 45*24*60*60*1000;
  const preSaleRate = 3500;
  const mainSaleRate = 3000;
  const wallet = accounts[0];

  deployer.deploy(EMXICO, preSaleStartTime, preSaleEndTime,
    mainSaleStartTime, mainSaleEndTime,
    preSaleRate, mainSaleRate, wallet);
};
