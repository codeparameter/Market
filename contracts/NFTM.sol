// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTM is ERC721URIStorage{

    event NFTCreated(address owner, uint256 tokenId);

    uint256 public tokenIds;

    constructor() ERC721("NFTMarket", "NFTM") {
    }   

    function nftMint(string memory tokenURI) external {
        tokenIds++;
        _mint(msg.sender, tokenIds);
        _setTokenURI(tokenIds, tokenURI);
        // approve(address(this), tokenIds);
        emit NFTCreated(msg.sender, tokenIds);
    }

    function exists(uint256 tokenId) public view returns (bool){
        return tokenId > 0 && tokenId <= tokenIds;
    }    

    modifier validTokenId(uint256 tokenId){
        require(exists(tokenId), "Token ID does not exist");
        _;
    }
}
