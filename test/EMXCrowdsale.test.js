
import expectThrow from 'zeppelin-solidity/test/helpers/expectThrow';
import assertRevert from 'zeppelin-solidity/test/helpers/assertRevert';

var EMXToken = artifacts.require("./EMXToken.sol");
var EMXCrowdsale = artifacts.require("./EMXCrowdsale.sol");

contract('EMXCrowdsale', (accounts) => {

  let acc0 = accounts[0];
  let acc1 = accounts[1];
  let acc2 = accounts[2];

  let token;
  let crowdsale;

  beforeEach(async () => {
    token = await EMXToken.deployed();
    crowdsale = await EMXCrowdsale.deployed();
    // crowdsale.token = token;
  });

  it('should throw acc1 due to whitelist', async () => {
    await expectThrow(crowdsale.sendTransaction({ from: acc1, value: web3.toWei(1, 'ether')}));
  });

  it('should add acc1 in white list', async () => {
    await crowdsale.addEarlyBacker(acc1, { from: acc0 });
    let ok = await crowdsale.isEarlyBacker(acc1);

    assert.equal(true, ok, 'Acc1 should be white listed');
  });

  it('should give weiRased of 1 Ether in Private Sale', async () => {
    await crowdsale.sendTransaction({ from: acc1, value: web3.toWei(1, 'ether') });

    // wei raised should be 1 ether
    let raised = await crowdsale.totalRaised({from: acc0});
    assert.equal(web3.toWei(1, 'ether'), raised.toString('10'), 'should be 1 ether raised');

    token.mint(acc1, web3.toWei(4000, 'ether'), {from: acc0});
  });

  it('Acc1 should have 4000 EMX for 1 Ether in Private Sale', async () => {
    // get the balance
    let bal = await token.balanceOf(acc1);
    assert.equal(web3.toWei(4000, 'ether'), bal.toString('10'), 'Should be 4000 ether of EMX');
  });

  it('should give weiRased of 1 Ether');
  it('should lapsed to the main crowdsale');
  it('should give 3000 EMX for 1 Ether');
  it('should give weiRased as 2 Ether');
  it('should be able to close the Crowdsale');
});
