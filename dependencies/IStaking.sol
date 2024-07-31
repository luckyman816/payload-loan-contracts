// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

interface IStaking { 
  function balanceOf(address _address) external view returns (uint);
}
 