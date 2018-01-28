/**
 *
 * MIT License
 *
 * Copyright (c) 2018, MEXC Program Developers & OpenZeppelin Project.
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


import 'zeppelin-solidity/contracts/token/MintableToken.sol';
import 'zeppelin-solidity/contracts/ownership/CanReclaimToken.sol';
import 'zeppelin-solidity/contracts/lifecycle/Destructible.sol';

contract MEXCToken is MintableToken, CanReclaimToken, Destructible  {

  string  public name = 'MEX Care Token';
  string  public symbol = 'MEXC';
  uint8   public decimals = 18;
  uint256 public maxSupply = 1200000000 ether;    // max allowable minting.
  bool    public transferDisabled = true;         // disable transfer init.

  event Confiscate(address indexed offender, uint256 value);

  // empty constructor
  function MEXCToken() public {}

  /*
   * the real reason for blackListed addresses are for those who are
   * mistakenly sent the EMX tokens to the wrong address. We can disable
   * the usage of the EMX tokens here.
   */
  mapping(address => bool) blackListed;           // blackListed addresses

  modifier canTransfer() {
    if (msg.sender == owner) {
      _;
    } else {
      require(!transferDisabled);
      require(blackListed[msg.sender] == false);  // default bool is false
      _;
    }
  }

  /*
   * Allow the transfer of token to happen once listed on exchangers
   */
  function allowTransfers() onlyOwner public returns (bool) {
    transferDisabled = false;
    return true;
  }

  function disallowTransfers() onlyOwner public returns (bool) {
    transferDisabled = true;
    return true;
  }

  function blackListAddress(address _offender) onlyOwner public returns (bool) {
    blackListed[_offender] = true;
    return true;
  }

  /**
   * This is confiscate the money that is sent to the wrong address accidentally.
   * the confiscated value can then be transferred to the righful owner. This is
   * especially important during ICO where some are *still* using Exchanger wallet
   * address, instead of their personal address.
   */
  function confiscate(address _offender) onlyOwner public returns (bool) {
    uint256 all = balances[_offender];
    require(all > 0);
    
    balances[_offender] = balances[_offender].sub(all);
    balances[msg.sender] = balances[msg.sender].add(all);
    Confiscate(_offender, all);
    return true;
  }

  /*
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    require(totalSupply <= maxSupply);
    return super.mint(_to, _amount);
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
    return super.transfer(_to, _value);
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
    return super.transferFrom(_from, _to, _value);
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) canTransfer public returns (bool) {
    return super.approve(_spender, _value);
  }
}
