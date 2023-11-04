// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable{

    address public owner;

    constructor (){
        owner = msg.sender;
    }

    function isOwner() public view returns(bool) {
        return msg.sender == owner;
    }

    modifier onlyOwner() {
        require(isOwner(), "Only the owner can call this function");
        _;
    }

}
