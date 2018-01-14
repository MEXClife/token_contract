pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract EMXToken is MintableToken {

  string public name = 'EMX Token';
  string public symbol = 'EMX';
  uint8  public decimals = 8;

}
