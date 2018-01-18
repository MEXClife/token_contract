
var EMXCrowdsale = artifacts.require("./EMXCrowdsale.sol");
var EMXToken = artifacts.require("./EMXToken.sol");

module.exports = function(deployer, network, accounts) {

  const wallet = accounts[0];

  // deploy EMX Token first.
  deployer.deploy(EMXToken, {from: wallet});

  // EMXCrowdsale (uint256 _startTime, address _wallet)
  // 
  const start = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 10;
  deployer.deploy(EMXCrowdsale, start, wallet, {from: wallet});

};
