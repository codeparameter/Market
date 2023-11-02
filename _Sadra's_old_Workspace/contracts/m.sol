// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Auction {
    event Start();
    event End(address highestBidder, uint highestBid);
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);

    address payable public seller;
    address public highestBidder;

    bool public started;
    bool public ended;

    uint public highestBid;
    uint public endAt;
    uint public auctionDuration;

    mapping(address => uint) public bids;

    constructor(uint _auctionDuration) {
        seller = payable(msg.sender);
        auctionDuration = _auctionDuration;
    }

    function start(uint startBid) external {
        require(msg.sender == seller, "You are not the seller!");
        require(!started, "Already started!");

        highestBid = startBid;
        endAt = block.timestamp + auctionDuration;
        started = true;
        emit Start();
    }

    function end() external {
        require(started, "need to start the auction first in order to end it!");
        require(
            block.timestamp >= endAt,
            "There is still time for the auction"
        );
        require(!ended, "Auction already ended!");

        ended = true;
        emit End(highestBidder, highestBid);
    }

    function bid() external payable {
        require(started, "Not started yet!");
        require(block.timestamp < endAt, "The auction has ended! Sorry :((");
        require(
            msg.value > highestBid,
            "Bid is not acceptable, cuz it's lower than the current bid!"
        );

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }
        highestBid = msg.value;
        highestBidder = msg.sender;
        emit Bid(highestBidder, highestBid);
    }

    function withdraw() external payable {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        (bool sent, bytes memory data) = payable(msg.sender).call{value: bal}(
            ""
        );
        require(sent, "Could not withdraw!");
        emit Withdraw(msg.sender, bal);
    }
}
