
var EMXCrowdsale = artifacts.require("./EMXCrowdsale.sol");

module.exports = function(deployer, network, accounts) {

  const preSaleStartTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp;
  const preSaleDays = 15;
  const mainSaleDays = 45;
  const preSaleRate = new web3.BigNumber(3500);
  const mainSaleRate = new web3.BigNumber(3000);
  const wallet = accounts[0];

  deployer.deploy(EMXCrowdsale,           // the contract
    preSaleStartTime, preSaleDays, mainSaleDays,
    preSaleRate, mainSaleRate, wallet);

};
