// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFTMarket.sol";

struct Swap{
    address seller;
    uint256 tokenId;
    uint256 price;
}

struct Auction {
    address seller;
    uint256 tokenId;
    uint256 minimumPrice;
    uint256 endTime;
    address highestBidder;
    uint256 highestBid;
    bool ended;
}

contract Market is NFTMarket{

    mapping(uint256 => Swap) public ethSwaps;
    mapping(uint256 => Swap) public tokenSwaps;
    mapping(uint256 => Auction) public auctions;
    mapping(uint256 => mapping(address => uint256)) public bidding;

    modifier checkSell(uint256 tokenId){
        require(nftm.ownerOf(tokenId) == msg.sender, "Not the owner of the NFT");
        _;
    }

    function setETHSwapOrder(uint256 tokenId, uint256 price) external checkSell(tokenId) {
        require(tokenSwaps[tokenId].seller == address(0), "Already for sell by ABCoin");
        require(auctions[tokenId].seller == address(0), "Already for sell in auction");
        require(price > 0, "Must set a solid price");

        ethSwaps[tokenId] = Swap(
            msg.sender,
            tokenId,
            price
        );
    }

    function swapETH(uint256 tokenId) external payable {
        Swap storage swap = ethSwaps[tokenId];
        uint256 price = swap.price;
        require(msg.value >= price, "Insufficient payment for the NFT");

        payable(swap.seller).transfer(swap.price);
        nftm.safeTransferFrom(swap.seller, msg.sender, tokenId);
    }

    function setTokenSwapOrder(uint256 tokenId, uint256 price) external checkSell(tokenId) {
        require(ethSwaps[tokenId].seller == address(0), "Already for sell by ETH");
        require(auctions[tokenId].seller == address(0), "Already for sell in auction");
        require(price > 0, "Must set a solid price");

        tokenSwaps[tokenId] = Swap(
            msg.sender,
            tokenId,
            price
        );
    }

    function swapToken(uint256 tokenId) external{
        Swap storage swap = ethSwaps[tokenId];

        // uint256 price = swap.price;
        // require(abcoin.balanceOf(msg.sender) >= price, "Insufficient payment for the NFT");

        // abcoin.transferFrom(msg.sender, swap.seller, swap.price);
        nftm.safeTransferFrom(swap.seller, msg.sender, tokenId);
    }

    function createAuction(
        uint256 tokenId,
        uint256 minimumPrice,
        uint256 duration
    ) external checkSell(tokenId) {
        
        require(ethSwaps[tokenId].seller == address(0), "Already for sell by ETH");
        require(tokenSwaps[tokenId].seller == address(0), "Already for sell by ABCoin");
        require(minimumPrice > 0, "Must set a solid minimum price");

        uint256 endTime = block.timestamp + duration * 1 days;

        auctions[tokenId] = Auction({
            seller: msg.sender,
            tokenId: tokenId,
            minimumPrice: minimumPrice,
            endTime: endTime,
            highestBidder: address(0),
            highestBid: 0,
            ended: false
        });
    }

    function showAuction(uint256 tokenId) external view returns (Auction memory){
        return auctions[tokenId];
    }

    function bid(uint256 tokenId) external payable {
        Auction storage auction = auctions[tokenId];
        require(block.timestamp < auction.endTime, "Auction already ended");
        require(msg.sender != auction.seller, "You are the seller!");
        require(msg.value > auction.minimumPrice, "Bid must be higher than minimum price");
        require(msg.value > auction.highestBid, "Bid must be higher than current highest bid");

        auction.highestBidder = msg.sender;
        auction.highestBid = msg.value;
        payable(address(this)).transfer(msg.value);
        bidding[tokenId][msg.sender] = auction.highestBid;
    }

    function endAuction(uint256 tokenId) external {
        Auction storage auction = auctions[tokenId];
        require(block.timestamp >= auction.endTime, "Auction not yet ended");
        require(!auction.ended, "Auction already ended");

        auction.ended = true;
        if (auction.highestBid != 0) {
            // Transfer the NFT to the highest bidder
            nftm.safeTransferFrom(auction.seller, auction.highestBidder, tokenId);
            payable(auction.seller).transfer(auction.highestBid);
        }
    }

    function payBack(uint256 tokenId) external{
        Auction storage auction = auctions[tokenId];
        require(auction.ended, "Auction not yet ended");
        payable(msg.sender).transfer(bidding[tokenId][msg.sender]);
    }
}
