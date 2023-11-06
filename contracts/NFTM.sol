// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTM is ERC721URIStorage, Ownable{

    event NFTCreated(address owner, uint256 tokenId);

    uint256 public tokenIds;

    constructor() ERC721("NFTMarket", "NFTM") {
    }   

    function nftMint(string memory tokenURI) external onlyOwner {
        tokenIds++;
        _mint(msg.sender, tokenIds);
        _setTokenURI(tokenIds, tokenURI);
        approve(address(this), tokenIds);
        emit NFTCreated(msg.sender, tokenIds);
    } 

    function setTokenURI(uint256 newItemId, string memory _tokenURI) external onlyOwner {
        _setTokenURI(newItemId, _tokenURI);
    }

    function exists(uint256 tokenId) external view returns (bool){
        return tokenId > 0 && tokenId <= tokenIds;
    }
}
