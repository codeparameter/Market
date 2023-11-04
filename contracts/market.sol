// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./auction.sol";
import "./abCoin.sol";

contract Market is AuctionContract{

    ABCoin public abcoin;

    constructor (address abc, address _nftm) AuctionContract(_nftm){
        abcoin = ABCoin(abc);
    }

    //
    // NFT <-> ETH
    //

    function setETHSwapOrder(uint256 tokenId, uint256 price) 
        external validTokenId(tokenId) checkSell(tokenId) {

        require(tokenSwaps[tokenId].seller == address(0), "Already for sell by ABCoin");
        require(auctions[tokenId].seller == address(0), "Already for sell in auction");
        require(price > 0, "Must set a solid price");

        ethSwaps[tokenId] = Swap(
            msg.sender,
            tokenId,
            price,
            true
        );
    }

    function getETHSwap(uint256 tokenId) internal view returns (Swap storage){
        Swap storage swap = ethSwaps[tokenId];
        require(swap.incomplete, "Order not found or already done!");
        return swap;
    }

    function swapETH(uint256 tokenId) external payable {
        Swap storage swap = getETHSwap(tokenId);
        uint256 price = swap.price;
        require(msg.value >= price, "Insufficient payment for the NFT");

        payable(swap.seller).transfer(swap.price);
        nftm.safeTransferFrom(swap.seller, msg.sender, tokenId);
        swap.incomplete = false;
    }

    //
    // NFT <-> ABCoin
    //

    function setTokenSwapOrder(uint256 tokenId, uint256 price) 
        external validTokenId(tokenId) checkSell(tokenId) {
            
        require(ethSwaps[tokenId].seller == address(0), "Already for sell by ETH");
        require(auctions[tokenId].seller == address(0), "Already for sell in auction");
        require(price > 0, "Must set a solid price");

        tokenSwaps[tokenId] = Swap(
            msg.sender,
            tokenId,
            price,
            true
        );
    }

    function getTokenSwap(uint256 tokenId) internal view returns (Swap storage){
        Swap storage swap = tokenSwaps[tokenId];
        require(swap.incomplete, "Order not found or already done!");
        return swap;
    }

    function swapToken(uint256 tokenId) external{
        Swap storage swap = getTokenSwap(tokenId);

        uint256 price = swap.price;
        require(abcoin.balanceOf(msg.sender) >= price, "Insufficient payment for the NFT");

        abcoin.transferFrom(msg.sender, swap.seller, swap.price);
        nftm.safeTransferFrom(swap.seller, msg.sender, tokenId);
        swap.incomplete = false;
    }
}
