// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

interface IJobBoard {  
  function getApplicationCount(
    address _address
  ) external view returns (uint256);
  function getApplicationsQuality(
    address _address
  ) external view returns (uint256);
}
