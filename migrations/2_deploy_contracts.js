
var EMXCrowdsale = artifacts.require("./EMXCrowdsale.sol");
var EMXToken = artifacts.require("./EMXToken.sol");

module.exports = function(deployer, network, accounts) {

  const preSaleStartTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 10;
  const preSaleDays = 15;
  const mainSaleDays = 45;
  const wallet = accounts[0];

  deployer.deploy(EMXToken, {});

  deployer.deploy(EMXCrowdsale,                             // the contract
    preSaleStartTime, preSaleDays, mainSaleDays, wallet,    // the args
    {});  // extra args

};
