
var EMXToken = artifacts.require("./EMXToken.sol");

contract('EMXCrowdsale', (accoints) => {
  let symbol = 'EMX';
  let decimals = 18;

  it('should have EMX symbol');
  it('should have 18 decimals');
  it('should have a totalSupply of 1 trillion');
  it('should disable transfers');
  it('should enable transfers');
  it('should blackList account[3]');
  it('should disable transfers for account[3]');
})
