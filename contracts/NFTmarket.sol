// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./NFTM.sol";

contract NFTMarket is NFTM {

    struct Auction {
        address seller;
        uint256 tokenId;
        uint256 minimumPrice;
        uint256 endTime;
        address highestBidder;
        uint256 highestBid;
        bool ended;
    }

    mapping(uint256 => Auction) public auctions;

    constructor() NFTM() {}

    function sellByPrice(address seller, address buyer, uint256 tokenId, uint256 price) external {
        require(ownerOf(tokenId) == seller, "Not the owner of the NFT");
        require(getApproved(tokenId) == address(this), "Contract not approved to sell NFT");

        safeTransferFrom(seller, buyer, tokenId);
    }

    function createAuction(
        uint256 tokenId,
        uint256 minimumPrice,
        uint256 duration
    ) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner of the NFT");
        require(getApproved(tokenId) == address(this), "Contract not approved to sell NFT");

        uint256 endTime = block.timestamp + duration;
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

    function bid(uint256 tokenId) external payable {
        Auction storage auction = auctions[tokenId];
        require(block.timestamp < auction.endTime, "Auction already ended");
        require(msg.value > auction.highestBid, "Bid must be higher than current highest bid");

        if (auction.highestBid != 0) {
            // Refund the previous highest bidder
            payable(auction.highestBidder).transfer(auction.highestBid);
        }

        auction.highestBidder = msg.sender;
        auction.highestBid = msg.value;
    }

    function endAuction(uint256 tokenId) external {
        Auction storage auction = auctions[tokenId];
        require(block.timestamp >= auction.endTime, "Auction not yet ended");
        require(!auction.ended, "Auction already ended");

        auction.ended = true;
        if (auction.highestBid != 0) {
            // Transfer the NFT to the highest bidder
            safeTransferFrom(auction.seller, auction.highestBidder, tokenId);
        }
    }
}
