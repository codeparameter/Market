// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFTM.sol";
import "./dealmaker.sol";

contract NFTMarket {

    NFTM public nftm = new NFTM();

    modifier validTokenId(uint256 tokenId){
        require(nftm.exists(tokenId), "Token ID does not exist");
        _;
    }

    function createNFT(string memory tokenURI) external{
        nftm.nftMint(tokenURI);
    }

    function getLastNFT() external view returns (uint256){
        return nftm.tokenIds();
    }

    function showNFT(uint256 tokenId) external view validTokenId(tokenId) returns (string memory) {
        return nftm.tokenURI(tokenId);
    }
}
