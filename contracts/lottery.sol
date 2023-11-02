// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ParsaTokenInterface.sol";

contract Lottery{

    address public owner;
    ParsaTokenInterface public token; 

    constructor(address _token) {
        owner = msg.sender;
        token = ParsaTokenInterface(_token);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function airDrop(address user, uint256 amount) external onlyOwner {
        // later we can create a random mechanism
        token.mint(user, amount);
    }

}