// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFTM.sol";
import "./dealmaker.sol";

contract NFTMarket is DealMaker {

    NFTM public nftm = new NFTM();
    
    uint256 public tokenIds;

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
