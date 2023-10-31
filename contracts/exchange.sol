// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./lottery.sol";

contract Exchange is Lottery {

    event BuyRequestStored(
        address indexed buyer, 
        uint256 indexed weiAmount, 
        uint256 indexed tokenAmunt);

    event BuyRequestShrinked(
        address indexed buyer, 
        uint256 indexed newWeiAmount, 
        uint256 indexed newTokenAmunt);

    event BuyRequestMatched(
        address indexed buyer, 
        uint256 indexed lastWeiAmount, 
        uint256 indexed lastTokenAmunt);

    event SellRequestStored(
        address indexed seller, 
        uint256 indexed weiAmount, 
        uint256 indexed tokenAmunt);

    event SellRequestShrinked(
        address indexed seller, 
        uint256 indexed newWeiAmount, 
        uint256 indexed newTokenAmunt);

    event SellRequestMatched(
        address indexed seller, 
        uint256 indexed lastWeiAmount, 
        uint256 indexed lastTokenAmunt);

    

    struct ExchangeRequest {
        address user;
        uint256 tokenAmount;
        uint256 weiAmount;
        uint256 rate; // wei per token
        bool allAtOnce;
    }

    ExchangeRequest[] public buyRequests;
    ExchangeRequest[] public sellRequests;

    constructor(address _token) Lottery(_token) {
    }


    // 
    // 
    // 
    //  Emiting Buy Events
    // 
    // 
    // 

    function storeBuyRequest(ExchangeRequest memory buyRequest) internal returns (uint256) {
        buyRequests.push(buyRequest);
        ExchangeRequest memory temp;
        uint256 i = buyRequests.length - 2;
        for (; i >= 0; i--){
            temp = buyRequests[i];
            // if buyRequest rate not high enogh, swap with temp; OR
            // if buyRequest rate is the same as temp, 
            //swap only if buyRequest wei amount is less than temp
            if(temp.rate > buyRequest.rate ||
            (temp.rate == buyRequest.rate && temp.weiAmount > buyRequest.weiAmount)){
                buyRequests[i + 1] = temp;
                buyRequests[i] = buyRequest;
            }
            else 
                break ;
        }
        emit BuyRequestStored(buyRequest.user, buyRequest.weiAmount, buyRequest.tokenAmount);
        return i + 1;
    }

    function shrinkBuyRequest(
        ExchangeRequest memory buyRequest,
        uint256 shrinkWeiAmount,
        uint256 shrinkTokenAmount,
        uint256 index) internal returns (ExchangeRequest memory) {

        buyRequest.weiAmount -= shrinkWeiAmount;
        buyRequest.tokenAmount -= shrinkTokenAmount;

        buyRequests[index] = buyRequest;

        emit BuyRequestShrinked(
            buyRequest.user, 
            buyRequest.weiAmount, 
            buyRequest.tokenAmount);
        
        return buyRequest;
    }

    function closeBuyRequest(
        ExchangeRequest memory buyRequest, 
        uint256 closedIndex) internal {

        for(uint256 i = closedIndex; i < buyRequests.length - 1; i++)
            buyRequests[i] = buyRequests[i-1];
        buyRequests.pop();
        
        emit BuyRequestMatched(
            buyRequest.user, 
            buyRequest.weiAmount, 
            buyRequest.tokenAmount);
    }

    // 
    // 
    // 
    //  Emiting Sell Events
    // 
    // 
    // 

    function storeSellRequest(ExchangeRequest memory sellRequest) internal returns (uint256) {
        sellRequests.push(sellRequest);
        ExchangeRequest memory temp;
        uint256 i = sellRequests.length - 2;
        for (; i >= 0; i--){
            temp = sellRequests[i];
            // if sellRequest rate not low enogh, swap with temp; OR
            // if sellRequest rate is the same as temp, 
            //swap only if sellRequest token amount is less than temp
            if(temp.rate < sellRequest.rate ||
            (temp.rate == sellRequest.rate && temp.tokenAmount > sellRequest.tokenAmount)){
                sellRequests[i + 1] = temp;
                sellRequests[i] = sellRequest;
            }
            else 
                break ;
        }
        emit SellRequestStored(sellRequest.user, sellRequest.weiAmount, sellRequest.tokenAmount);
        return i + 1;
    }

    function shrinkSellRequest(
        ExchangeRequest memory sellRequest,
        uint256 shrinkWeiAmount,
        uint256 shrinkTokenAmount,
        uint256 index) internal returns (ExchangeRequest memory) {

        sellRequest.weiAmount -= shrinkWeiAmount;
        sellRequest.tokenAmount -= shrinkTokenAmount;

        sellRequests[index] = sellRequest;

        emit SellRequestShrinked(
            sellRequest.user, 
            sellRequest.weiAmount, 
            sellRequest.tokenAmount);

        return  sellRequest;
    }

    function closeSellRequest(
        ExchangeRequest memory sellRequest, 
        uint256 closedIndex) internal {

        for(uint256 i = closedIndex; i < sellRequests.length - 1; i++)
            sellRequests[i] = sellRequests[i-1];
        sellRequests.pop();

        emit SellRequestMatched(
            sellRequest.user, 
            sellRequest.weiAmount, 
            sellRequest.tokenAmount);
    }

    

    // 
    // 
    // 
    //  Payment Section
    // 
    // 
    // 


    function transferWei(
        ExchangeRequest memory fromBuyer,
        ExchangeRequest memory toSeller,
        uint256 tokenAmount) 
        internal returns (uint256) {

        uint256 buyerWei = fromBuyer.rate *  tokenAmount;
        uint256 sellerWei = toSeller.rate *  tokenAmount;

        payable (toSeller.user).transfer(sellerWei);
        
        uint256 profit = buyerWei - sellerWei;
        if(profit > 0)
            payable(owner).transfer(profit);

        return buyerWei;
    }


}