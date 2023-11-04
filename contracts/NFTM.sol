// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTM is ERC721URIStorage, Ownable{

    constructor() ERC721("NFTMarket", "NFTM") {
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

    function approve(address to, uint256 tokenId) public override  {
        _approve(to, tokenId);
    }
}
