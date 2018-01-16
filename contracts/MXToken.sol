pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';
import 'zeppelin-solidity/contracts/token/CanReclaimToken.sol';
import 'zeppelin-solidity/contracts/ownership/Claimable.sol';

contract EMXToken is MintableToken, CanReclaimToken, Claimable  {

  string public name = 'MX Token';
  string public symbol = 'MX';
  uint8  public decimals = 8;

}
