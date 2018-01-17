
var EMXToken = artifacts.require("./EMXToken.sol");

contract('EMXCrowdsale', (network, accounts) => {
  let symbol = 'EMX';
  let decimals = 18;

  it('should have EMX symbol', () => {
    return EMXToken.deployed().then(instance => {
      return instance.symbol.call();
    }).then(sym => {
      assert.equal('EMX', sym, 'Symbol should be EMX');
    });
  });

  it('should have 18 decimals', () => {
    return EMXToken.deployed().then(instance => {
      return instance.decimals.call();
    }).then(dec => {
      assert.equal(18, dec, 'Decimals should be 18');
    });
  });

  it('should have a totalSupply of 1 trillion', () => {
    return EMXToken.deployed().then(instance => {
      return instance.totalSupply.call();
    }).then(supply => {
      let total = web3.fromWei(supply, 'wei').toNumber();
      assert.equal(web3.toWei(1000000000, 'ether'), total, 'Supply should be 1t ether');
    });
  });

  it('should disable transfers');
  it('should enable transfers');
  it('should blackList account[3]');
  it('should disable transfers for account[3]');
})
