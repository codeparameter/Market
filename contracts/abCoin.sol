// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ABCoin is ERC20, Ownable{

    constructor() ERC20("ABCoin", "ABC") {
    }

    function mint(address account, uint256 value) external  onlyOwner  {
        _mint(account, value);
    }

}
