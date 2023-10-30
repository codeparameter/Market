// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ParsaTokenInterface{
    // Parsa uses The ERC-20 token as parent of its token
    function mint(address account, uint256 value) external ;
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}