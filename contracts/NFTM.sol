// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/utils/Counters.sol";

contract NFTM is ERC721URIStorage{

    address public owner;

    constructor() ERC721("NFTMarket", "NFTM") {
        owner = msg.sender;
    }   

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function nftMint(address account, uint256 nextId) external onlyOwner {
        _mint(account, nextId);
    } 

    function setTokenURI(uint256 newItemId, string memory _tokenURI) external onlyOwner {
        _setTokenURI(newItemId, _tokenURI);
    }

    function exists(uint256 tokenId) external view returns (bool){
        return _exists(tokenId);
    }
}
