 // SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract MainToken is ERC20 {
  address public owner;

  constructor() ERC20('MainToken', 'MT') { 
    owner = msg.sender;
    _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
  }

  modifier onlyOwner() {
    require(msg.sender == owner, 'Only owner can call this function');
    _;
  }

  function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
  }
}
