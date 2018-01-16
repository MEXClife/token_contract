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
contract EMXICO is CanReclaimToken, Claimable, Destructible  {
  using SafeMath for uint256;

  // The token being sold
  MintableToken public token;

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
  uint256 public preSaleRate = 0;
  uint256 public mainSaleRate = 0;

  bool public isFinalized = false;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


  function EMXICO (uint256 _preSaleStartTime, uint256 _preSaleEndTime,
                   uint256 _mainSaleStartTime, uint256 _mainSaleEndTime,
                   uint256 _preSaleRate, uint256 _mainSaleRate,
                   address _wallet) public {
    require(_preSaleStartTime >= now);
    require(_mainSaleStartTime >= _preSaleEndTime);
    require(_preSaleEndTime >= _preSaleStartTime);
    require(_mainSaleEndTime >= _mainSaleStartTime);
    require(_preSaleRate > 0);
    require(_mainSaleRate > 0);
    require(_wallet != address(0));

    token = createTokenContract();
    preSaleStartTime = _preSaleStartTime;
    preSaleEndTime = _preSaleEndTime;
    mainSaleStartTime = _mainSaleStartTime;
    mainSaleEndTime = _mainSaleEndTime;
    preSaleRate = _preSaleRate;
    mainSaleRate = _mainSaleRate;
    wallet = _wallet;
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
