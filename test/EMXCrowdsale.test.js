
import expectThrow from 'zeppelin-solidity/test/helpers/expectThrow';
import assertRevert from 'zeppelin-solidity/test/helpers/assertRevert';

var EMXToken = artifacts.require("./EMXToken.sol");
var EMXCrowdsale = artifacts.require("./EMXCrowdsale.sol");

contract('EMXCrowdsale', (accounts) => {

  let acc0 = accounts[0];
  let acc1 = accounts[1];

  let token;
  let crowdsale;

  beforeEach(async () => {
    crowdsale = await EMXCrowdsale.deployed();
    let addr = await crowdsale.token();
    token = EMXToken.at(addr);
  });

  it('should give weiRased of 1 Ether in Private Sale', async () => {
    await crowdsale.sendTransaction({ from: acc1, value: web3.toWei(1, 'ether') });

    // wei raised should be 1 ether
    let raised = await crowdsale.totalRaised({from: acc0});
    assert.equal(web3.toWei(1, 'ether'), raised.toString('10'), 'should be 1 ether raised');

    let ok = await crowdsale.isEarlyBacker(acc1);
    assert.equal(true, ok, 'Acc1 should be true in Private Sale');
  });

  it('should have 4000 EMX for 1 Ether in Private Sale', async () => {
    // get the balance
    let bal = await token.balanceOf(acc1);
    assert.equal(web3.toWei(4000, 'ether'), bal.toString('10'), 'Should be 4000 ether of EMX');
  });

  it('should give weiRased of 2 Ether in Pre-Sale', async () => {
    let now = web3.eth.getBlock(web3.eth.blockNumber).timestamp;
    await crowdsale.setEndTimePriv(now - 1, {from: acc0});

    await crowdsale.sendTransaction({ from: acc1, value: web3.toWei(1, 'ether') });

    // wei raised should be 1 ether
    let raised = await crowdsale.totalRaised({from: acc0});
    assert.equal(web3.toWei(2, 'ether'), raised.toString('10'), 'should be 1 ether raised');

    let ok = await crowdsale.isPreSaleBacker(acc1);
    assert.equal(true, ok, 'Acc1 should be true in Pre-Sale');

  });

  it('should have 7500 EMX for 1 Ether in Private Sale', async () => {
    // get the balance
    let bal = await token.balanceOf(acc1);
    assert.equal(web3.toWei(7500, 'ether'), bal.toString('10'), 'Should be 7500 ether of EMX');
  });

  it('should give weiRased of 3 Ether in Public Sale', async () => {
    let now = web3.eth.getBlock(web3.eth.blockNumber).timestamp;
    await crowdsale.setEndTimePre(now - 1, {from: acc0});

    await crowdsale.sendTransaction({ from: acc1, value: web3.toWei(1, 'ether') });

    // wei raised should be 1 ether
    let raised = await crowdsale.totalRaised({from: acc0});
    assert.equal(web3.toWei(3, 'ether'), raised.toString('10'), 'should be 1 ether raised');
  });

  it('should have 10,500 EMX for 3 Ether in total Sale', async () => {
    // get the balance
    let bal = await token.balanceOf(acc1);
    assert.equal(web3.toWei(10500, 'ether'), bal.toString('10'), 'Should be 10500 ether of EMX');
  });

  it('should be able to close the Crowdsale', async () => {
    await crowdsale.endCrowdsale({from: acc0});
    let stat = await crowdsale.hasEnded();

    assert.equal(true, stat, 'Crowdsale has ended');
  });

});
