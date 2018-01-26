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
pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/token/MintableToken.sol';
import 'zeppelin-solidity/contracts/ownership/Claimable.sol';
import 'zeppelin-solidity/contracts/ownership/CanReclaimToken.sol';
import 'zeppelin-solidity/contracts/lifecycle/Destructible.sol';

import './MEXCToken.sol';

/**
 * The EMXCrowdsale contract.
 * The token is based on ERC20 Standard token, with ERC23 functionality to reclaim
 * other tokens accidentally sent to this contract, as well as to destroy
 * this contract once the ICO has ended.
 */
contract MEXCrowdsale is Claimable, CanReclaimToken, Destructible {
  using SafeMath for uint256;

  // The token being sold
  MintableToken public token;

  // start and end timestamps where investments are allowed (both inclusive)
  uint256 public startTime = 0;
  uint256 public endTime = 0;

  // address where funds are collected
  address public wallet = address(0);

  // amount of raised money in wei
  uint256 public weiRaised = 0;

  // cap for crowdsale
  uint256 public cap = 300000 ether;

  // whitelist backers
  mapping(address => bool) whiteList;

  // addmin list
  mapping(address => bool) adminList;

  // mappig of our days, and rates.
  mapping(uint8 => uint256) daysRates;

  modifier onlyAdmin() { 
    require(adminList[msg.sender] == true || msg.sender == owner);
    _; 
  }
  
  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, 
                      uint256 value, uint256 amount);

  function MEXCrowdsale(uint256 _startTime, address _wallet) public {
    require(_startTime >= now);
    require(_wallet != address(0));

    token = createTokenContract();
    wallet = _wallet;
    startTime = _startTime;
    endTime = startTime + 80 days;

    // set the days lapsed, and rates for the priod since startTime.
    daysRates[15] = 4000;
    daysRates[45] = 3500;
    daysRates[65] = 3250;
    daysRates[75] = 3125;
    daysRates[80] = 3000;
  }

  // creates the token to be sold.
  // override this method to have crowdsale of a specific mintable token.
  function createTokenContract() internal returns (MintableToken) {
    return new MEXCToken();
  }

  function addWhiteList (address _backer) onlyAdmin public returns(bool res) {
    whiteList[_backer] = true;
    return true;
  }
  
  function totalRaised() public view returns (uint256) {
    return weiRaised;
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
    uint256 tokens = weiAmount.mul(getRate());

    // update state
    weiRaised = weiRaised.add(weiAmount);

    if (tokens > 0) {
      token.mint(beneficiary, tokens);
      TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);      
    }

    forwardFunds();
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  // @return true if the transaction can buy tokens
  function validPurchase() internal view returns (bool) {
    // 80 days of sale.
    bool withinPeriod = now >= startTime && now <= endTime;
    bool nonZeroPurchase = msg.value != 0;
    bool withinCap = weiRaised.add(msg.value) <= cap;
    return withinPeriod && nonZeroPurchase && withinCap;
  }

  function getRate() internal view returns (uint256 rate) {
    uint256 diff = (now - startTime);

    if (diff <= 15 days) {
      require(whiteList[msg.sender] == true);
      return daysRates[15];
    } else if (diff > 15 && diff <= 45 days) {
      return daysRates[45];
    } else if (diff > 45 && diff <= 65 days) {
      return daysRates[65];
    } else if (diff > 65 && diff <= 75 days) {
      return daysRates[75];
    } else if (diff <= 80 days) {
      return daysRates[80];
    } 
    return 0;
  }

  // @return true if crowdsale event has ended
  function hasEnded() public view returns (bool) {
    bool capReached = weiRaised >= cap;
    return now > endTime || capReached;
  }

}
