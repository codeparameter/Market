// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./exchange.sol";

contract DealMaker is Exchange{

    
    // 
    // 
    // 
    //  Handling Buy Requests
    // 
    // 
    // 

    function submitBuyRequest(uint256 tokenAmount, uint256 weiAmount, bool allAtOnce) payable external {
        require(tokenAmount > 0, "Invalid token amount");
        require(weiAmount > 0, "Invalid Wei amount");
        require(msg.value > 0, "Insufficiant Wei amount");

        ExchangeRequest memory buyRequest = ExchangeRequest(
            msg.sender, 
            tokenAmount, 
            weiAmount, 
            weiAmount / tokenAmount, 
            allAtOnce
            );

        uint256 buyRI = storeBuyRequest(buyRequest);
        matchSellRequest(buyRequest, buyRI);
    }

    function matchSellRequest(ExchangeRequest memory buyRequest, uint256 buyRI) internal {
        ExchangeRequest memory sellRequest;
        for (uint256 i = sellRequests.length - 1; i >= 0; i--){
            sellRequest = sellRequests[i];

            if(buyRequest.rate < sellRequest.rate)
                break ;
            if(sellRequest.allAtOnce && sellRequest.weiAmount > buyRequest.weiAmount)
                continue ;
            if(buyRequest.allAtOnce && buyRequest.tokenAmount > sellRequest.tokenAmount)
                continue ;
                
            if(buyRequest.tokenAmount > sellRequest.tokenAmount){

                transferWei(buyRequest, sellRequest, sellRequest.tokenAmount);
                closeSellRequest(sellRequest, i);

                // transfer to buyer now (without lock)
                transfer(buyRequest.user, sellRequest.tokenAmount);
                buyRequest = shrinkBuyRequest(
                    buyRequest, sellRequest.weiAmount, sellRequest.tokenAmount, buyRI);

                if(buyRequest.tokenAmount == 0){
                    closeBuyRequest(buyRequest, buyRI);
                    return ;
                }
            }
            else{

                uint256 weiAmount = transferWei(buyRequest, sellRequest, buyRequest.tokenAmount);
                        
                if(buyRequest.tokenAmount < sellRequest.tokenAmount)
                    shrinkSellRequest(sellRequest, weiAmount, buyRequest.tokenAmount, i);
                else // ==
                    closeSellRequest(sellRequest, i);
                
                // transfer to buyer now (without lock)
                transfer(buyRequest.user, buyRequest.tokenAmount);
                closeBuyRequest(buyRequest, buyRI);

                return ;
            }            
        }

        // lock weis to match later
        if(buyRequest.tokenAmount > 0)
            payable(address(this)).transfer(buyRequest.weiAmount);
    }

    // 
    // 
    // 
    //  Handling Sell Requests
    // 
    // 
    // 

    function submitSellRequest(uint256 tokenAmount, uint256 weiAmount, bool allAtOnce) external {
        require(tokenAmount > 0, "Invalid token amount");
        require(weiAmount > 0, "Invalid ETH amount");
        require(balanceOf(msg.sender) > 0, "Insufficiant token amount");

        ExchangeRequest memory sellRequest = ExchangeRequest(
            msg.sender, 
            tokenAmount, 
            weiAmount, 
            weiAmount / tokenAmount, 
            allAtOnce
            );

        uint256 sellRI = storeSellRequest(sellRequest);
        matchBuyRequest(sellRequest, sellRI);
    }

    function matchBuyRequest(ExchangeRequest memory sellRequest, uint256 sellRI) internal {
        ExchangeRequest memory buyRequest;
        for (uint256 i = buyRequests.length - 1; i >= 0; i--){
            buyRequest = buyRequests[i];

            if(buyRequest.rate < sellRequest.rate)
                break ;
            if(buyRequest.allAtOnce && buyRequest.tokenAmount > sellRequest.tokenAmount)
                continue ;
            if(sellRequest.allAtOnce && sellRequest.weiAmount > buyRequest.weiAmount)
                continue ;
                
            if(sellRequest.weiAmount > buyRequest.weiAmount){
                
                uint256 weiAmount= transferWei(buyRequest, sellRequest, buyRequest.tokenAmount);
                transferFrom(sellRequest.user, buyRequest.user, buyRequest.tokenAmount);
                closeBuyRequest(buyRequest, i);
                
                sellRequest = shrinkSellRequest(
                    sellRequest, weiAmount, buyRequest.tokenAmount, sellRI);

                if(sellRequest.weiAmount == 0){
                    closeSellRequest(sellRequest, sellRI);
                    return ;
                }
            }
            else{

                uint256 weiAmount = transferWei(buyRequest, sellRequest, sellRequest.tokenAmount);        
                transferFrom(sellRequest.user, buyRequest.user, sellRequest.tokenAmount);

                if(sellRequest.weiAmount < buyRequest.weiAmount)
                    shrinkBuyRequest(buyRequest, weiAmount, sellRequest.tokenAmount, i);
                else // ==
                    closeBuyRequest(buyRequest, i);
                
                closeSellRequest(sellRequest, i);
                
                return  ;
            }            
        }

        // lock tokens to match later
        if(sellRequest.weiAmount > 0)
            transfer(address(this), sellRequest.tokenAmount);
    }

}