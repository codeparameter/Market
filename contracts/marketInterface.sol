// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface MarketInterface {
    function submitBuyRequest(uint256 tokenAmount, uint256 weiAmount, bool allAtOnce) payable external;
}
