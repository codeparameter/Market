// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFTM.sol";
import "./dealmaker.sol";

contract NFTMarket is DealMaker {

    NFTM public nftm = new NFTM();
    
    uint256 public tokenIds;

    function createNFT(string memory tokenURI) external{
        tokenIds++;
        nftm.nftMint(msg.sender, tokenIds);
        nftm.setTokenURI(tokenIds, tokenURI);
        nftm.approve(address(this), tokenIds);
    }    

    function showNFT(uint256 tokenId) external view returns (string memory) {
        require(nftm.exists(tokenId), "Token ID does not exist");
        return nftm.tokenURI(tokenId);
    }
}
