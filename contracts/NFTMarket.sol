// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFTM.sol";
import "./dealmaker.sol";

contract NFTMarket is DealMaker {

    NFTM public nftm = new NFTM();

    using Counters for Counters.Counter;
    Counters.Counter public tokenIds;
    mapping(address => uint256[]) public userNFTs;

    function createNFT(string memory tokenURI) external returns (uint256) {
        tokenIds.increment();
        uint256 newItemId = tokenIds.current();
        nftm.nftMint(msg.sender, newItemId);
        nftm.setTokenURI(newItemId, tokenURI);
        
        userNFTs[msg.sender].push(newItemId);
        return newItemId;
    }    

    function showNFT(uint256 tokenId) external view returns (string memory) {
        require(nftm.exists(tokenId), "Token ID does not exist");
        return nftm.tokenURI(tokenId);
    }

    function getLastNFT() external view returns (uint256) {
        return tokenIds.current();
    }

    function getNFTsOfUser(address user) external view returns (uint256[] memory) {
        return userNFTs[user];
    }
}
