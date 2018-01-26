/**
 *
 * MIT License
 *
 * Copyright (c) 2018, MEXC Program Developers.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */
import expectThrow from 'zeppelin-solidity/test/helpers/expectThrow';
import assertRevert from 'zeppelin-solidity/test/helpers/assertRevert';
import increaseTime from 'zeppelin-solidity/test/helpers/increaseTime';

var MEXCToken = artifacts.require("./MEXCToken.sol");
var MEXCrowdsale = artifacts.require("./MEXCrowdsale.sol");

contract('MEXCrowdsale', (accounts) => {

  let acc0 = accounts[0];
  let acc1 = accounts[1];
  let acc2 = accounts[2];

  let token;
  let crowdsale;

  beforeEach(async () => {
    crowdsale = await MEXCrowdsale.deployed();
    let addr = await crowdsale.token();
    token = MEXCToken.at(addr);
  });

  it('should failed acc1 on the private list', async () => {
    await expectThrow(crowdsale.sendTransaction({ from: acc1, value: web3.toWei(1, 'ether') }));
  });

  it('should give weiRased of 1 Ether in Stage 1 Sale', async () => {
    await crowdsale.addWhiteList(acc1);
    await crowdsale.sendTransaction({ from: acc1, value: web3.toWei(1, 'ether') });

    // wei raised should be 1 ether
    let raised = await crowdsale.totalRaised({from: acc0});
    assert.equal(web3.toWei(1, 'ether'), raised.toString('10'), 'should be 1 ether raised');
  });

  it('should have 4000 MEXC for 1 Ether in Private Sale', async () => {
    // get the balance
    let bal = await token.balanceOf(acc1);
    assert.equal(web3.toWei(4000, 'ether'), bal.toString('10'), 'Should be 4000 ether of MEXC');
  });

  it('should give weiRased of 3 Ether in Stage 1 Sale', async () => {
    await crowdsale.sendTransaction({ from: acc1, value: web3.toWei(2, 'ether') });

    // wei raised should be 3 ether
    let raised = await crowdsale.totalRaised({from: acc0});
    assert.equal(web3.toWei(3, 'ether'), raised.toString('10'), 'should be 3 ether raised');
  });

  it('should have 12000 MEXC for 3 Ether in Private Sale', async () => {
    // get the balance
    let bal = await token.balanceOf(acc1);
    assert.equal(web3.toWei(12000, 'ether'), bal.toString('10'), 'Should be 12000 ether of MEXC');
  });


  it('should change the time to stage 2, changed the rate to 3500', async () => {
    await increaseTime(15 * 86400);
    await crowdsale.sendTransaction({ from: acc2, value: web3.toWei(1, 'ether') });

    // wei raised should be 4 ether
    let raised = await crowdsale.totalRaised({from: acc0});
    assert.equal(web3.toWei(4, 'ether'), raised.toString('10'), 'should be 4 ether raised');

    let bal = await token.balanceOf(acc2);
    assert.equal(web3.toWei(3500, 'ether'), bal.toString('10'), 'Should be 3500 ether of MEXC');
  });

  it('should change the time to stage 3, changed the rate to 3250', async () => {
    await increaseTime(30 * 86400);

    await crowdsale.sendTransaction({ from: acc2, value: web3.toWei(1, 'ether') });

    // wei raised should be 5 ether
    let raised = await crowdsale.totalRaised({from: acc0});
    assert.equal(web3.toWei(5, 'ether'), raised.toString('10'), 'should be 5 ether raised');

    let bal = await token.balanceOf(acc2);
    assert.equal(web3.toWei(6750, 'ether'), bal.toString('10'), 'Should be 6750 ether of MEXC');
  });

  it('should change the time to stage 4, changed the rate to 3125', async () => {
    await increaseTime(20 * 86400);

    await crowdsale.sendTransaction({ from: acc2, value: web3.toWei(1, 'ether') });

    // wei raised should be 6 ether
    let raised = await crowdsale.totalRaised({from: acc0});
    assert.equal(web3.toWei(6, 'ether'), raised.toString('10'), 'should be 6 ether raised');

    let bal = await token.balanceOf(acc2);
    assert.equal(web3.toWei(9875, 'ether'), bal.toString('10'), 'Should be 9875 ether of MEXC');
  });

  it('should change the time to stage 5, changed the rate to 3000', async () => {
    await increaseTime(10 * 86400);
    await crowdsale.sendTransaction({ from: acc2, value: web3.toWei(1, 'ether') });

    // wei raised should be 7 ether
    let raised = await crowdsale.totalRaised({from: acc0});
    assert.equal(web3.toWei(7, 'ether'), raised.toString('10'), 'should be 7 ether raised');

    let bal = await token.balanceOf(acc2);
    assert.equal(web3.toWei(12875, 'ether'), bal.toString('10'), 'Should be 12875 ether of MEXC');
  });

  it('should give errors when sending as time has ended', async () => {
    await increaseTime(5 * 86400);
    await expectThrow(crowdsale.sendTransaction({ from: acc2, value: web3.toWei(1, 'ether') }));
  });
});
