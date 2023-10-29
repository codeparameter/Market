// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";

contract ABCoin is ERC20{
    
    address public owner;
    uint256 public startDate;
    uint256 public expireDate;

    constructor(string memory _name, 
                string memory _alias,
                uint256 _startDate,
                uint256 _expireDate) ERC20(_name, _alias) {

        owner = msg.sender;
        startDate = _startDate;
        expireDate = _expireDate;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function mint(address account, uint256 value) public onlyOwner  {
        _mint(account, value);
    }

    function transferFrom(
            address sender, 
            address recipient, 
            uint256 amount) 
            public virtual override 
            onlyOwner
            returns (bool){
        
        if (balanceOf(sender) < amount){
            return false;
        }

        if(block.timestamp >= expireDate){
            _burn(sender, balanceOf(sender));
            return false;
        }
        
        return super.transferFrom(sender, recipient, amount);
    }

    
}
