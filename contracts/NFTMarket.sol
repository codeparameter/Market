// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFTM.sol";
import "./dealmaker.sol";

contract NFTMarket {

    event NFTCreated(address owner, uint256 tokenId);

    NFTM public nftm;
    uint256 public tokenIds;

    constructor(address _nftm){
        nftm = NFTM(_nftm);
    }

    modifier validTokenId(uint256 tokenId){
        require(nftm.exists(tokenId), "Token ID does not exist");
        _;
    }

    function createNFT(string memory tokenURI) external{
        tokenIds++;
        nftm.nftMint(msg.sender, tokenIds);
        nftm.setTokenURI(tokenIds, tokenURI);
        nftm.approve(address(this), tokenIds);
        emit NFTCreated(msg.sender, tokenIds);
    }

    function showNFT(uint256 tokenId) external view validTokenId(tokenId) returns (string memory) {
        return nftm.tokenURI(tokenId);
    }
}
