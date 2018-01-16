/**
 *
 * MIT License
 *
 * Copyright (c) 2018, EMX Program Developers.
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
pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/token/MintableToken.sol';
import 'zeppelin-solidity/contracts/ownership/CanReclaimToken.sol';
import 'zeppelin-solidity/contracts/ownership/Claimable.sol';
import 'zeppelin-solidity/contracts/lifecycle/Destructible.sol';

import './EMXToken.sol';

/**
 * The EMXICO ICO Contract.
 * It is based on ERC20 Standard token, with ERC23 functionality to reclaim
 * other tokens accidentally sent to this contract, as well as to destroy
 * this contract once the ICO has ended.
 */
contract EMXCrowdsale is CanReclaimToken, Claimable, Destructible  {

  using SafeMath for uint256;

  // The token being sold
  MintableToken public token;

  // days of the ICO
  uint8 preSaleDays = 15;
  uint8 mainSaleDays = 45;

  // start and end timestamps where investments are allowed (both inclusive)
  uint256 public preSaleStartTime = 1518048001;   // 2018-02-08T00:00:01+00:00
  uint256 public preSaleEndTime = 1519516799;     // 2018-02-24T23:59:59+00:00
  uint256 public mainSaleStartTime = 1519516800;  // 2018-02-25T00:00:00+00:00
  uint256 public mainSaleEndTime = 1523577599;    // 2018-04-12T23:59:59+00:00

  // address where funds are collected
  address public wallet = 0x77733DEFb072D75aF02A4415f60212925E6BcF95;

  // total wei raised
  uint256 weiRaised = 0;
  uint256 maxRaised = 200000 ether;               // target raised

  // how many token units a buyer gets per wei
  uint256 public preSaleRate = 3500;
  uint256 public mainSaleRate = 3000;


  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary,
      uint256 value, uint256 amount);


  function EMXCrowdsale (uint256 _preSaleStartTime, uint8 _preSaleDays,
      uint8 _mainSaleDays, address _wallet) public {

    require(_preSaleStartTime >= now);
    require(_preSaleDays > 0);
    require(_mainSaleDays > 0);
    require(_wallet != address(0));

    token = createTokenContract();

    preSaleDays = _preSaleDays;
    mainSaleDays = _mainSaleDays;

    preSaleStartTime = _preSaleStartTime;
    preSaleEndTime = _preSaleStartTime + (_preSaleDays * 86400);
    mainSaleStartTime = preSaleEndTime + 1;
    mainSaleEndTime = preSaleEndTime + (_mainSaleDays * 86400);

    wallet = _wallet;
  }

  /**
   * List of setter functions for the Crowdsale related variables
   * These are provided as convenient functions.
   */
  function updatePreSaleDays(uint8 _days) onlyOwner public returns (bool) {
    preSaleDays = _days;
    preSaleEndTime = preSaleStartTime + (preSaleDays * 86400);
    mainSaleStartTime = preSaleEndTime + 1;
    mainSaleEndTime = preSaleEndTime + (mainSaleDays * 86400);
    return true;
  }

  function updateMainSaleDays(uint8 _days) onlyOwner public returns (bool) {
    mainSaleDays = _days;
    mainSaleEndTime = preSaleEndTime + (mainSaleDays * 86400);
    return true;
  }

  function updateCrowdsaleTime(uint256 _time) onlyOwner public returns (bool) {
    preSaleStartTime = _time;
    preSaleEndTime = preSaleStartTime + (preSaleDays * 86400);
    mainSaleStartTime = preSaleEndTime + 1;
    mainSaleEndTime = preSaleEndTime + (mainSaleDays * 86400);
    return true;
  }

  function updateWallet(address _wallet) onlyOwner public returns (bool) {
    wallet = _wallet;
    return true;
  }

  function updatePreSaleRate(uint256 _rate) onlyOwner public returns (bool) {
    preSaleRate = _rate;
    return true;
  }

  function updateMainSaleRate(uint256 _rate) onlyOwner public returns (bool) {
    mainSaleRate = _rate;
    return true;
  }

  function createTokenContract() internal returns (MintableToken) {
    return new EMXToken();
  }

  // fallback function can be used to buy tokens
  function () external payable {
    buyTokens(msg.sender);
  }

  // low level token purchase function
  function buyTokens(address beneficiary) public payable {
    require(beneficiary != address(0));
    require(validPurchase());

    uint256 weiAmount = msg.value;

    // check for rates
    uint256 rate = 0;
    if (now <= mainSaleStartTime) {
      rate = preSaleRate;
    } else {
      rate = mainSaleRate;
    }

    // calculate token amount to be created
    uint256 tokens = weiAmount.mul(rate);

    // update state
    weiRaised = weiRaised.add(weiAmount);

    token.mint(beneficiary, tokens);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    forwardFunds();
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  // @return true if the transaction can buy tokens
  function validPurchase() internal view returns (bool) {
    bool withinPeriod = now >= preSaleStartTime && now <= mainSaleEndTime;
    bool nonZeroPurchase = msg.value != 0;
    bool withinMax = maxRaised <= weiRaised;
    return withinPeriod && nonZeroPurchase && withinMax;
  }

  // @return true if crowdsale event has ended
  function hasEnded() public view returns (bool) {
    return now > mainSaleEndTime;
  }

}
