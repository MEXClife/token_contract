
var EMXCrowdsale = artifacts.require("./EMXCrowdsale.sol");
var EMXToken = artifacts.require("./EMXToken.sol");

module.exports = function(deployer, network, accounts) {

  const acc0 = accounts[0];

  // deploy EMX Token first.
  deployer.deploy(EMXToken, {from: acc0});

  // EMXCrowdsale (uint256 _startTime, address _wallet)
  //
  const start = web3.eth.getBlock(web3.eth.blockNumber).timestamp;
  deployer.deploy(EMXCrowdsale, start, acc0, {from: acc0});

};
