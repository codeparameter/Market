// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTM is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(address => uint256[]) public userNFTs;
    mapping(uint256 => address) public nftOwners;

    constructor() ERC721("NFTMarket", "NFTM") {}

    function createNFT(address owner, string memory tokenURI) external returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(owner, newItemId);
        _setTokenURI(newItemId, tokenURI);
        
        userNFTs[owner].push(newItemId);
        nftOwners[newItemId] = owner;

        return newItemId;
    }

    function getAllNFTs() external view returns (uint256[] memory) {
        return _getAllTokenIds();
    }

    function getNFTsOfUser(address user) external view returns (uint256[] memory) {
        return userNFTs[user];
    }

    function _getAllTokenIds() internal view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](_tokenIds.current());
        for (uint256 i = 0; i < _tokenIds.current(); i++) {
            result[i] = i + 1;
        }
        return result;
    }
}
