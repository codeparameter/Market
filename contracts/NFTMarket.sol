// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFTM.sol";
import "./dealmaker.sol";

contract NFTMarket {

    NFTM public nftm;
    uint256 public tokenIds;

    constructor(address _nftm){
        nftm = NFTM(_nftm);
    }

    modifier validTokenId(uint256 tokenId){
        require(tokenId > 0 && tokenId <= tokenIds, "Token ID does not exist");
        _;
    }

    function createNFT(string memory tokenURI) external{
        tokenIds++;
        nftm.nftMint(msg.sender, tokenIds);
        nftm.setTokenURI(tokenIds, tokenURI);
        nftm.approve(address(this), tokenIds);
    }

    function showNFT(uint256 tokenId) external view validTokenId(tokenId) returns (string memory) {
        return nftm.tokenURI(tokenId);
    }
}
