// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/utils/Counters.sol";

import "./marketInterface.sol";

contract NFTM is ERC721URIStorage{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256[] public NFTs;
    mapping(address => uint256[]) public userNFTs;

    constructor() ERC721("NFTMarket", "NFTM") {}

    function createNFT(string memory tokenURI) external returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        
        userNFTs[msg.sender].push(newItemId);
        return newItemId;
    }

    function showNFT(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId), "Token ID does not exist");
        return tokenURI(tokenId);
    }

    function getLastNFT() external view returns (uint256) {
        return _tokenIds.current();
    }

    function getNFTsOfUser(address user) external view returns (uint256[] memory) {
        return userNFTs[user];
    }
}
