pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/StandardToken.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract EMXToken is StandardToken, Ownable {

  string public name = 'EMX Token';
  string public symbol = 'EMX';
  uint8  public decimals = 18;
  uint256 public totalSupply = 1000000000 ether;  // 1b Ether

  function EMXToken () public {
    balances[msg.sender] = totalSupply;
  }
    
}
