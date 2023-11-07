// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./auction.sol";
import "./abCoin.sol";

struct Swap{
    address seller;
    uint256 tokenId;
    uint256 price;
    bool incomplete;
}

contract Market is AuctionContract{

    event ETHSwapOrderSet(address seller, uint256 tokenId, uint256 price);
    event ETHSwapOrderDone(address seller, address buyer, uint256 tokenId, uint256 price);

    event TokenSwapOrderSet(address seller, uint256 tokenId, uint256 price);
    event TokenSwapOrderDone(address seller, address buyer, uint256 tokenId, uint256 price);

    ABCoin public abcoin;
    mapping(uint256 => Swap) public ethSwaps;
    mapping(uint256 => Swap) public tokenSwaps;

    constructor (address abc){
        abcoin = ABCoin(abc);
    }

    //
    // NFT <-> ETH
    //

    function setETHSwapOrder(uint256 tokenId, uint256 price) 
        external validTokenId(tokenId) checkSell(tokenId, Status.ethSwap) {
        require(price > 0, "Must set a solid price");

        ethSwaps[tokenId] = Swap(
            msg.sender,
            tokenId,
            price,
            true
        );

        emit ETHSwapOrderSet(msg.sender, tokenId, price);
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
        Statuses[tokenId] = Status.owned;

        emit ETHSwapOrderDone(swap.seller, msg.sender, tokenId, swap.price);
    }

    //
    // NFT <-> ABCoin
    //

    function setTokenSwapOrder(uint256 tokenId, uint256 price) 
        external validTokenId(tokenId) checkSell(tokenId, Status.abcSwap) {
            
        require(price > 0, "Must set a solid price");

        tokenSwaps[tokenId] = Swap(
            msg.sender,
            tokenId,
            price,
            true
        );

        emit TokenSwapOrderSet(msg.sender, tokenId, price);
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
        Statuses[tokenId] = Status.owned;

        emit TokenSwapOrderDone(swap.seller, msg.sender, tokenId, swap.price);
    }
}
