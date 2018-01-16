pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract EMXToken is MintableToken, Ownable {

  string public name = 'MX Token';
  string public symbol = 'MX';
  uint8  public decimals = 8;

}
