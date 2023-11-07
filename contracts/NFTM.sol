// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTM is ERC721URIStorage, Ownable{

    event NFTCreated(address owner, uint256 tokenId);

    uint256 public tokenIds;

    constructor() ERC721("NFTMarket", "NFTM") {
    }   

    function nftMint(address nftOwner, string memory tokenURI) external onlyOwner {
        tokenIds++;
        _mint(nftOwner, tokenIds);
        _setTokenURI(tokenIds, tokenURI);
        // approve(msg.sender, tokenIds);
        emit NFTCreated(msg.sender, tokenIds);
    }

    function exists(uint256 tokenId) external view returns (bool){
        return tokenId > 0 && tokenId <= tokenIds;
    }
}
