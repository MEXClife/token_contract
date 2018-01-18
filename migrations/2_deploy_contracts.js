
var EMXCrowdsale = artifacts.require("./EMXCrowdsale.sol");
var EMXToken = artifacts.require("./EMXToken.sol");

module.exports = function(deployer, network, accounts) {

  // deploy EMX Token first.
  deployer.deploy(EMXToken, {});

  // function signature.
  // EMXCrowdsale (uint256 _preSaleStartTime, uint8 _preSaleDays,
  //  uint8 _mainSaleDays, address _wallet)
  // const preSaleStartTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 10;
  // const preSaleDays = 30;
  // const mainSaleDays = 45;
  // const wallet = accounts[0];

  // deployer.deploy(EMXCrowdsale,                             // the contract
  //   preSaleStartTime, preSaleDays, mainSaleDays, wallet,    // the args
  //   {});  // extra args

  // EMXCrowdsale (uint256 _startTime, uint256 _endTime, 
  //                          uint256 _rate, address _wallet,
  //                          uint256 _cap) 
  const start = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 10;
  const wallet = accounts[0];

  deployer.deploy(EMXCrowdsale, start, wallet, {});

};
