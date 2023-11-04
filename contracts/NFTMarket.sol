// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFTM.sol";
import "./dealmaker.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/utils/Counters.sol";

// contract NFTMarket is DealMaker {
contract NFTMarket {

    NFTM public nftm = new NFTM();

    using Counters for Counters.Counter;
    Counters.Counter public tokenIds;

    function createNFT(string memory tokenURI) external returns (uint256) {
        tokenIds.increment();
        uint256 newItemId = tokenIds.current();
        nftm.nftMint(msg.sender, newItemId);
        nftm.setTokenURI(newItemId, tokenURI);
        return newItemId;
    }    

    function showNFT(uint256 tokenId) external view returns (string memory) {
        require(nftm.exists(tokenId), "Token ID does not exist");
        return nftm.tokenURI(tokenId);
    }

    function getLastNFT() external view returns (uint256) {
        return tokenIds.current();
    }
}
