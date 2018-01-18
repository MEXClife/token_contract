

import expectThrow from 'zeppelin-solidity/test/helpers/expectThrow';
import assertRevert from 'zeppelin-solidity/test/helpers/assertRevert';

var EMXToken = artifacts.require("./EMXToken.sol");

contract('EMXTokenTest', (accounts) => {
  let symbol = 'EMX';
  let decimals = 18;

  // accounts
  let owner = accounts[0];
  let acc1 = accounts[1];
  let acc2 = accounts[2];
  let acc3 = accounts[3];

  let token;

  beforeEach(async () => {
    token = await EMXToken.deployed();
  });  

  it('should have EMX symbol', async () => {
    let symbol = await token.symbol();
    assert.equal('EMX', symbol, 'Symbol should be EMX');
  });

  it('should have 18 decimals', async () => {
    let dec = await token.decimals();
    assert.equal(18, dec, 'Decimals should be 18');
  });

  // it('should have a totalSupply of 1 trillion', () => {
  //   return EMXToken.deployed().then(instance => {
  //     return instance.totalSupply.call();
  //   }).then(supply => {
  //     let total = web3.fromWei(supply, 'wei').toNumber();
  //     assert.equal(web3.toWei(1000000000, 'ether'), total, 'Supply should be 1t ether');
  //   });
  // });

  it('should be able to mint 3500 for acc1', async () => {
    let res = await token.mint(acc1, web3.toWei(3500, 'ether'));
    let bal = await token.balanceOf(acc1);
    let supply = await token.totalSupply.call();

    let balance = bal.toString('10');
    assert.equal(web3.toWei(3500, 'ether').toString('10'), balance, 'Balance should be 3500 ether');        

    let s = supply.toString('10');
    let expected = web3.toWei(3500, 'ether').toString('10');
    assert.equal(s, expected, 'Total supply should be 3500 ether');
  });

  it('should disable transfers to acc2', async () => {
    await expectThrow(token.transferFrom(acc1, acc2, web3.toWei(1, 'ether')));
    let bal = await token.balanceOf(acc2);
    assert.equal('0', bal.toString('10'), 'Balance should be 0');
  });

  it('should enable transfer', async () => {
    let r = await token.allowTransfers();
    let status = await token.transferDisabled();
    assert.equal(false, status, 'Transfer should be enabled');
  });

  it('should enable transfer to acc2', async () => {
    let res = await token.mint(acc1, web3.toWei(20, 'ether'));
    await token.transfer(acc2, web3.toWei(1, 'ether'), {from: acc1});
    let bal = await token.balanceOf(acc2);
    assert.equal(web3.toWei(1, 'ether'), bal.toString('10'), 'Balance should be 1 ether');
  });

  it('should blackList acc3', async() => {
    let res = await token.mint(acc3, web3.toWei(2, 'ether'));
    await token.blackListAddress(acc3);

    // acc3 transfer to acc2
    await expectThrow(token.transfer(acc2, web3.toWei(1, 'ether'), {from: acc3}));
    let bal = await token.balanceOf(acc3);
    assert.equal(web3.toWei(2, 'ether'), bal.toString('10'), 'Balance should still be 2 ether');
  });

  it('should be able to confiscate acc3 balance', async () => {
    let ownBal = await token.balanceOf(owner);
    let res = await token.mint(acc3, web3.toWei(2, 'ether'));
    let acc3Bal = await token.balanceOf(acc3);

    // confiscate
    await token.confiscate(acc3);
    let acc3BalNow = await token.balanceOf(acc3);
    assert.equal(web3.toWei(0, 'ether'), acc3BalNow.toString('10'), 'Balance should be 0 ether');
  });

})
