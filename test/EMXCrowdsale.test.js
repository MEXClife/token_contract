
import expectThrow from 'zeppelin-solidity/test/helpers/expectThrow';
import assertRevert from 'zeppelin-solidity/test/helpers/assertRevert';
import increaseTime from 'zeppelin-solidity/test/helpers/increaseTime';

var EMXToken = artifacts.require("./EMXToken.sol");
var EMXCrowdsale = artifacts.require("./EMXCrowdsale.sol");

contract('EMXCrowdsale', (accounts) => {

  let acc0 = accounts[0];
  let acc1 = accounts[1];
  let acc2 = accounts[2];

  let token;
  let crowdsale;

  beforeEach(async () => {
    crowdsale = await EMXCrowdsale.deployed();
    let addr = await crowdsale.token();
    token = EMXToken.at(addr);
  });

  it('should give weiRased of 1 Ether in Stage 1 Sale', async () => {
    await crowdsale.sendTransaction({ from: acc1, value: web3.toWei(1, 'ether') });

    // wei raised should be 1 ether
    let raised = await crowdsale.totalRaised({from: acc0});
    assert.equal(web3.toWei(1, 'ether'), raised.toString('10'), 'should be 1 ether raised');
  });

  it('should have 4000 EMX for 1 Ether in Private Sale', async () => {
    // get the balance
    let bal = await token.balanceOf(acc1);
    assert.equal(web3.toWei(4000, 'ether'), bal.toString('10'), 'Should be 4000 ether of EMX');
  });

  it('should give weiRased of 3 Ether in Stage 1 Sale', async () => {
    await crowdsale.sendTransaction({ from: acc1, value: web3.toWei(2, 'ether') });

    // wei raised should be 3 ether
    let raised = await crowdsale.totalRaised({from: acc0});
    assert.equal(web3.toWei(3, 'ether'), raised.toString('10'), 'should be 3 ether raised');
  });

  it('should have 12000 EMX for 3 Ether in Private Sale', async () => {
    // get the balance
    let bal = await token.balanceOf(acc1);
    assert.equal(web3.toWei(12000, 'ether'), bal.toString('10'), 'Should be 12000 ether of EMX');
  });

  it('should change the time to stage 2, change the rate to 3500', async () => {
    let now = web3.eth.getBlock(web3.eth.blockNumber).timestamp;
    await increaseTime(now + 15 * 86400);

    await crowdsale.sendTransaction({ from: acc2, value: web3.toWei(1, 'ether') });

    // wei raised should be 4 ether
    let raised = await crowdsale.totalRaised({from: acc0});
    assert.equal(web3.toWei(4, 'ether'), raised.toString('10'), 'should be 4 ether raised');

    let bal = await token.balanceOf(acc2);
    assert.equal(web3.toWei(3500, 'ether'), bal.toString('10'), 'Should be 3500 ether of EMX');
  });


});
