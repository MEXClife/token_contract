
var EMXCrowdsale = artifacts.require("./EMXCrowdsale.sol");

contract('EMXCrowdsale', (accoints) => {
  let symbol = 'EMX';
  let decimals = 18;

  it('should have EMX symbol');
  it('should have 18 decimals');
  it('should have a totalSupply of 1 trillion');
  it('should say pre-sale crowdsale');
  it('should give 3500 EMX for 1 Ether');
  it('should give weiRased of 1 Ether');
  it('should lapsed to the main crowdsale');
  it('should give 3000 EMX for 1 Ether');
  it('should give weiRased as 2 Ether');
  it('should be able to close the Crowdsale');
})
