pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';
import 'zeppelin-solidity/contracts/ownership/CanReclaimToken.sol';
import 'zeppelin-solidity/contracts/ownership/Claimable.sol';

contract EMXToken is MintableToken, CanReclaimToken, Claimable  {

  string  public name = 'EMX Token';
  string  public symbol = 'EMX';
  uint8   public decimals = 18;
  uint256 public totalSupply = 1000000000 ether;  // 1b EMX tokens

  bool    public transferDisabled = true;         // disable transfer init.

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

  function blackListAddress(address _offender) onlyOwner public returns (bool) {
    blackListed[_offender] = true;
    return true;
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
