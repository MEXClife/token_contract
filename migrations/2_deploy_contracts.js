
var MEXCrowdsale = artifacts.require("./MEXCrowdsale.sol");
var MEXCToken = artifacts.require("./MEXCToken.sol");

module.exports = function(deployer, network, accounts) {

  const acc0 = 0xE1A7793620145E45c856fa49277DBdc19a2CEcf4;

  // deploy EMX Token first.
  deployer.deploy(MEXCToken, {from: acc0});

  // EMXCrowdsale (uint256 _startTime, address _wallet)
  //
  const start = web3.eth.getBlock(web3.eth.blockNumber).timestamp;
  deployer.deploy(MEXCrowdsale, start, acc0, {from: acc0});

};
