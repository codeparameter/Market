// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "./NFTMarket.sol";

struct Swap{
    address seller;
    uint256 tokenId;
    uint256 price;
    bool incomplete;
}

struct Auction {
    address seller;
    uint256 tokenId;
    uint256 minimumPrice;
    uint256 endTime;
    address highestBidder;
    uint256 highestBid;
    bool incomplete;
}

contract AuctionContract is NFTMarket{

    event AuctionCreated(
                        address seller,
                        uint256 tokenId,
                        uint256 minimumPrice,
                        uint256 endTime
                        );

    event AuctionEnded(
                        address seller,
                        uint256 tokenId,
                        uint256 minimumPrice,
                        uint256 endTime,
                        address highestBidder,
                        uint256 highestBid  
                        );

    event AuctionBid(
                        address seller,
                        uint256 tokenId,
                        address highestBidder,
                        uint256 highestBid  
                        );

    event PayBack(
                        address seller,
                        address bidder,
                        uint256 tokenId,
                        uint256 amount
                        );

    mapping(uint256 => Swap) public ethSwaps;
    mapping(uint256 => Swap) public tokenSwaps;
    mapping(uint256 => Auction) public auctions;
    mapping(uint256 => mapping(address => uint256)) public bidding;

    constructor(address _nftm) NFTMarket(_nftm) {}

    modifier checkSell(uint256 tokenId){
        require(nftm.ownerOf(tokenId) == msg.sender, "Not the owner of the NFT");
        _;
    }

    function createAuction(
        uint256 tokenId,
        uint256 minimumPrice,
        uint256 duration
    ) external validTokenId(tokenId) checkSell(tokenId) {
        
        require(ethSwaps[tokenId].seller == address(0), "Already for sell by ETH");
        require(tokenSwaps[tokenId].seller == address(0), "Already for sell by ABCoin");
        require(minimumPrice > 0, "Must set a solid minimum price");

        uint256 endTime = block.timestamp + duration * 1 minutes;

        auctions[tokenId] = Auction({
            seller: msg.sender,
            tokenId: tokenId,
            minimumPrice: minimumPrice,
            endTime: endTime,
            highestBidder: address(0),
            highestBid: 0,
            incomplete: true
        });

        emit AuctionCreated({
            seller: msg.sender,
            tokenId: tokenId,
            minimumPrice: minimumPrice,
            endTime: endTime
        });
    }

    function getAuction(uint256 tokenId) internal view returns (Auction storage){
        Auction storage auction = auctions[tokenId];
        require(auction.incomplete, "Auction not found or already done!");
        return auction;
    }

    function bid(uint256 tokenId) external payable {
        Auction storage auction = getAuction(tokenId);
        require(block.timestamp < auction.endTime, "Auction already ended");

        uint256 bidAmount = bidding[tokenId][msg.sender] + msg.value;
        require(bidAmount >= auction.minimumPrice, "Bid must be higher than minimum price");
        require(bidAmount > auction.highestBid, "Bid must be higher than current highest bid");

        auction.highestBidder = msg.sender;
        auction.highestBid = bidAmount;
        bidding[tokenId][msg.sender] = bidAmount;

        emit AuctionBid(auction.seller, tokenId, msg.sender, bidAmount);
    }

    function endAuction(uint256 tokenId) external {
        Auction storage auction = getAuction(tokenId);
        require(block.timestamp >= auction.endTime, "Auction not yet ended");
        require(auction.incomplete, "Auction already ended");

        auction.incomplete = false;
        if (auction.highestBid != 0) {
            // Transfer the NFT to the highest bidder
            nftm.safeTransferFrom(auction.seller, auction.highestBidder, tokenId);
            payable(auction.seller).transfer(auction.highestBid);
        }

        emit AuctionEnded(
                        auction.seller, 
                        auction.tokenId, 
                        auction.minimumPrice, 
                        auction.endTime, 
                        auction.highestBidder, 
                        auction.highestBid
                        );
    }

    function payBack(uint256 tokenId) external{
        Auction storage auction = getAuction(tokenId);
        require(auction.highestBidder != msg.sender, 
            "You can't cancel your bid unless someone bid higher than you");
            
        // customized err msg:
        require(bidding[tokenId][msg.sender] > 0, "You did'nt bid at all");
        payable(msg.sender).transfer(bidding[tokenId][msg.sender]);

        emit PayBack(auction.seller, msg.sender, tokenId, bidding[tokenId][msg.sender]);

        bidding[tokenId][msg.sender] = 0;
    }
}