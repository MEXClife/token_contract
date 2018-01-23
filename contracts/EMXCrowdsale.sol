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
import 'zeppelin-solidity/contracts/ownership/Claimable.sol';
import 'zeppelin-solidity/contracts/ownership/CanReclaimToken.sol';
import 'zeppelin-solidity/contracts/lifecycle/Destructible.sol';

import './EMXToken.sol';

/**
 * The EMXCrowdsale contract.
 * The token is based on ERC20 Standard token, with ERC23 functionality to reclaim
 * other tokens accidentally sent to this contract, as well as to destroy
 * this contract once the ICO has ended.
 */
contract EMXCrowdsale is Claimable, CanReclaimToken, Destructible {
  using SafeMath for uint256;

  // The token being sold
  MintableToken public token;

  // start and end timestamps where investments are allowed (both inclusive)
  uint256 public startTimePriv;
  uint256 public endTimePriv;
  uint256 public startTimePre;
  uint256 public endTimePre;
  uint256 public startTimePub;
  uint256 public endTimePub;

  uint8 public daysPriv = 15;
  uint8 public daysPre = 30;
  uint8 public daysPub = 30;

  // early backer of EMX
  mapping(address => bool) earlyBacker;
  mapping(address => bool) preSaleBacker;

  // address where funds are collected
  address public wallet = 0x77733DEFb072D75aF02A4415f60212925E6BcF95;

  // how many token units a buyer gets per wei
  uint256 public ratePriv = 4000;
  uint256 public ratePre = 3500;
  uint256 public ratePub = 3000;

  // amount of raised money in wei
  uint256 public weiRaised;

  // cap for crowdsale
  uint256 public cap = 300000 ether;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  function EMXCrowdsale(uint256 _startTime, address _wallet) public {
    require(_startTime >= now);
    require(_wallet != address(0));

    token = createTokenContract();
    startTimePriv = _startTime;
    endTimePriv = startTimePriv + (daysPriv * 86400);
    startTimePre = endTimePriv + 1;
    endTimePre = endTimePriv + (daysPre * 86400);
    startTimePub = endTimePre + 1;
    endTimePub = endTimePre + (daysPub * 86400);
    wallet = _wallet;
  }

  // creates the token to be sold.
  // override this method to have crowdsale of a specific mintable token.
  function createTokenContract() internal returns (MintableToken) {
    return new EMXToken();
  }

  function isEarlyBacker(address _sender) public view returns (bool) {
    return earlyBacker[_sender];
  }

  function isPreSaleBacker(address _sender) public view returns (bool) {
    return preSaleBacker[_sender];
  }

  function totalRaised() public view returns (uint256) {
    return weiRaised;
  }

  /**
   * @dev for testing purposes.
   * Reset the time for Pre-Sale
   * @return rate for Pre-Sale
   */
  function setEndTimePriv(uint256 _endTime) onlyOwner public returns (uint256) {
    endTimePriv = _endTime;

    // also recalculate other stages
    startTimePre = endTimePriv + 1;
    endTimePre = endTimePriv + (daysPre * 86400);
    startTimePub = endTimePre + 1;
    endTimePub = endTimePre + (daysPub * 86400);

    return ratePre;
  }

  /**
   * @dev for testing purposes.
   * Reset the time for Public Sale
   * @return rate for Public Sale
   */
  function setEndTimePre(uint256 _endTime) onlyOwner public returns (uint256) {
    endTimePre = _endTime;

    // also recalculate other stages
    startTimePub = endTimePre + 1;
    endTimePub = endTimePre + (daysPub * 86400);

    return ratePub;
  }

  function endCrowdsale() onlyOwner public returns (bool) {
    endTimePub = now - 1;
    return true;
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

    // calculate token amount to be created
    uint256 rate = 0;
    if (now <= endTimePriv) {
      earlyBacker[beneficiary] == true;
      rate = ratePriv;
    } else if (now > endTimePriv && now <= endTimePre) {
      preSaleBacker[beneficiary] == true;
      rate = ratePre;
    } else {
      rate = ratePub;
    }
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
    bool withinPeriod = now >= startTimePriv && now <= endTimePub;
    bool nonZeroPurchase = msg.value != 0;
    bool withinCap = weiRaised.add(msg.value) <= cap;
    return withinPeriod && nonZeroPurchase && withinCap;
  }

  // @return true if crowdsale event has ended
  function hasEnded() public view returns (bool) {
    bool capReached = weiRaised >= cap;
    return now > endTimePub || capReached;
  }

}
