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
            
        matchSellRequest(buyRequest);
    }

    function matchSellRequest(ExchangeRequest memory buyRequest) internal{

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
                abcoin.transfer(buyRequest.user, sellRequest.tokenAmount);
                
                buyRequest.weiAmount -= sellRequest.weiAmount;
                buyRequest.tokenAmount -= sellRequest.tokenAmount;

            }
            else{

                uint256 weiAmount = transferWei(buyRequest, sellRequest, buyRequest.tokenAmount);
                        
                if(buyRequest.tokenAmount < sellRequest.tokenAmount)
                    shrinkSellRequest(weiAmount, buyRequest.tokenAmount, i);
                else // ==
                    closeSellRequest(sellRequest, i);
                
                // transfer to buyer now (without lock)
                abcoin.transfer(buyRequest.user, buyRequest.tokenAmount);

                return ;
            }            
        }

        // lock weis to match later
        if(buyRequest.tokenAmount > 0){
            payable(address(this)).transfer(buyRequest.weiAmount);
            storeBuyRequest(buyRequest);
        }
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
        require(abcoin.balanceOf(msg.sender) > 0, "Insufficiant token amount");

        ExchangeRequest memory sellRequest = ExchangeRequest(
            msg.sender, 
            tokenAmount, 
            weiAmount, 
            weiAmount / tokenAmount, 
            allAtOnce
            );
            
        matchBuyRequest(sellRequest);
    }

    function matchBuyRequest(ExchangeRequest memory sellRequest) internal {
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
                abcoin.transferFrom(sellRequest.user, buyRequest.user, buyRequest.tokenAmount);
                closeBuyRequest(buyRequest, i);

                sellRequest.weiAmount -= weiAmount;
                sellRequest.tokenAmount -= buyRequest.tokenAmount;
                
            }
            else{

                uint256 weiAmount = transferWei(buyRequest, sellRequest, sellRequest.tokenAmount);        
                abcoin.transferFrom(sellRequest.user, buyRequest.user, sellRequest.tokenAmount);

                if(sellRequest.weiAmount < buyRequest.weiAmount)
                    shrinkBuyRequest(weiAmount, sellRequest.tokenAmount, i);
                else // ==
                    closeBuyRequest(buyRequest, i);
                
                closeSellRequest(sellRequest, i);
                
                return  ;
            }            
        }

        // lock tokens to match later
        if(sellRequest.weiAmount > 0){
            abcoin.transfer(address(this), sellRequest.tokenAmount);
            storeSellRequest(sellRequest);
        }
    }

}