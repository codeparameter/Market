// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";

contract ABCoin is ERC20{
    
    address public owner;

    constructor() ERC20("ABCoin", "ABC") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function mint(address account, uint256 value) internal  onlyOwner  {
        _mint(account, value);
    }

    function tokenTransferFrom(
            address sender, 
            address recipient, 
            uint256 amount) 
            public 
            onlyOwner
            returns (bool){
        
        if (balanceOf(sender) < amount){
            return false;
        }
        
        return transferFrom(sender, recipient, amount);
    }

    
}
