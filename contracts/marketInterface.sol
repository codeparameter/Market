// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


struct ExchangeRequest {
    address user;
    uint256 tokenAmount;
    uint256 weiAmount;
    uint256 rate; // wei per token
    bool allAtOnce;
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

// localhost:port
// landingpage links :
// token page
// nfts
// auctions

interface MarketInterface {
    
    // localhost:port/token
    function sellRequestList() external returns(ExchangeRequest[] memory);
    function buyRequestList() external returns(ExchangeRequest[] memory);

    // localhost:port/token/sell
    function submitSellRequest(uint256 tokenAmount, uint256 weiAmount, bool allAtOnce) external;
    // localhost:port/token/buy
    function submitBuyRequest(uint256 tokenAmount, uint256 weiAmount, bool allAtOnce) external payable;
    
    // localhost:port/nfts
    // list of all nfts by using for loop on showNFT
    function getLastNFT() external view returns (uint256);
    function showNFT(uint256 tokenId) external view returns (string memory);
    // localhost:port/nfts/create
    function createNFT(string memory tokenURI) external returns (uint256);

    // localhost:port/nfts/sell/eth
    function setETHSwapOrder(uint256 tokenId, uint256 price) external;
    // localhost:port/nfts/sell/token
    function setTokenSwapOrder(uint256 tokenId, uint256 price) external;
    // localhost:port/nfts/buy/eth
    function swapETH(uint256 tokenId) external payable;
    // localhost:port/nfts/buy/token
    function swapToken(uint256 tokenId) external;

    // localhost:port/auctions
    // list of all auctions by using for loop on showAuction
    function showAuction(uint256 tokenId) external view returns (Auction memory);
    // localhost:port/auctions/create
    function createAuction(uint256 tokenId, uint256 minimumPrice, uint256 duration) external;
    // localhost:port/auctions/bid/{tokenId}?price
    function bid(uint256 tokenId) external payable;
    // localhost:port/auctions/{tokenId}
    function endAuction(uint256 tokenId) external;
    // localhost:port/auctions/payback/{tokenId}
    function payBack(uint256 tokenId) external;

}
