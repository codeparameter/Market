// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./auction.sol";
import "./dealmaker.sol";
import "hardhat/console.sol";

struct Swap{
    address seller;
    address buyer;
    uint256 tokenId;
    uint256 price;
    bool incomplete;
}

contract Market is AuctionContract{

    event ETHSwapOrderSet(address seller, uint256 tokenId, uint256 price);
    event ETHSwapOrdered(address seller, address buyer, uint256 tokenId);
    event ETHSwapOrderDone(address seller, address buyer, uint256 tokenId, uint256 price);

    event TokenSwapOrderSet(address seller, uint256 tokenId, uint256 price);
    event TokenSwapOrdered(address seller, address buyer, uint256 tokenId);
    event TokenSwapOrderDone(address seller, address buyer, uint256 tokenId, uint256 price);

    DealMaker public abcoin;
    mapping(uint256 => Swap) public ethSwaps;
    mapping(uint256 => Swap) public tokenSwaps;

    constructor (address abc){
        abcoin = DealMaker(abc);
    }

    //
    // NFT <-> ETH
    //

    function setETHSwapOrder(uint256 tokenId, uint256 price) 
        external validTokenId(tokenId) checkSell(tokenId, Status.ethSwap) {
        require(price > 0, "Must set a solid price");

        ethSwaps[tokenId] = Swap(
            msg.sender,
            address(0),
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
        require(swap.buyer == address(0), "swap already done!");

        require(msg.value >= swap.price, "Insufficient payment for the NFT");

        swap.buyer = msg.sender;

        emit ETHSwapOrdered(swap.seller, swap.buyer, tokenId);
    }

    function closeETHOrder(uint256 tokenId) external {
        require(msg.sender == ownerOf(tokenId), "Only seller can end the order");
        Swap storage swap = getETHSwap(tokenId);
        require(swap.incomplete, "swap already done!");

        payable(swap.seller).transfer(swap.price);
        safeTransferFrom(swap.seller, swap.buyer, tokenId);

        swap.incomplete = false;
        Statuses[tokenId] = Status.owned;

        emit ETHSwapOrderDone(swap.seller, swap.buyer, tokenId, swap.price);
    }

    //
    // NFT <-> ABCoin
    //

    function setTokenSwapOrder(uint256 tokenId, uint256 price) 
        external validTokenId(tokenId) checkSell(tokenId, Status.abcSwap) {
            
        require(price > 0, "Must set a solid price");

        tokenSwaps[tokenId] = Swap(
            msg.sender,
            address(0),
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
        require(swap.buyer == address(0), "swap already done!");

        require(abcoin.balanceOf(msg.sender) >= swap.price, "Insufficient payment for the NFT");


        abcoin.transferFrom(msg.sender, address(this), swap.price);
        swap.buyer = msg.sender;

        emit TokenSwapOrdered(swap.seller, swap.buyer, tokenId);
    }

    function closeTokenOrder(uint256 tokenId) external{
        require(msg.sender == ownerOf(tokenId), "Only seller can end the order");
        Swap storage swap = getTokenSwap(tokenId);
        require(swap.incomplete, "swap already done!");

        abcoin.transfer(swap.seller, swap.price);
        safeTransferFrom(swap.seller, msg.sender, tokenId);
        
        swap.incomplete = false;
        Statuses[tokenId] = Status.owned;

        emit TokenSwapOrderDone(swap.seller, swap.buyer, tokenId, swap.price);
    }
}
