
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
  });

  it('should throw due to whitelist', async () => {
    await expectThrow(crowdsale.sendTransaction({ from: acc1, value: web3.toWei(1, 'ether')}));
  });

  it('should give 4000 EMX for 1 Ether', async () => {
    await crowdsale.addEarlyBacker(acc1, { from: acc0 });
    // await crowdsale.sendTransaction({ from: acc1, value: web3.toWei(1, 'ether') });
    // // get the balance
    let bal = await token.balanceOf(acc1);
    // assert.equal(web3.toWei(4000, 'ether'), bal.toString('10'), 'Should be 4000 ether of EMX');
  });

  it('should give weiRased of 1 Ether');
  it('should lapsed to the main crowdsale');
  it('should give 3000 EMX for 1 Ether');
  it('should give weiRased as 2 Ether');
  it('should be able to close the Crowdsale');
});
