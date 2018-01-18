
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
  const startPriv = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 10;
  const endPriv = startPriv + (15 * 86400);
  const startPre = endPriv + 1;
  const endPre = endPriv + (30 * 86400);
  const startPub = endPre + 1;
  const endPub = endPre + (30 * 86400);
  const ratePriv = 4000;
  const ratePre = 3500;
  const ratePub = 3000;
  const wallet = accounts[0];

  deployer.deploy(EMXCrowdsale,
                  startPriv, endPriv,
                  startPre, endPre,
                  startPub, endPub, 
                  ratePriv, ratePre, ratePub, 
                  wallet, 
                  {});

};
