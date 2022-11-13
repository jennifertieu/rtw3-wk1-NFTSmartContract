// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.8.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.8.0/utils/Counters.sol";

contract MyToken is ERC721, ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant USER_MAX = 5;

    mapping(address => uint256) public mintWallets;

    constructor() ERC721("Alchemy", "ALCH") {}


    function safeMint(address to, string memory uri) public {
        // get the current token ID
        uint256 tokenId = _tokenIdCounter.current();
        // check if token ID is the max supply
        require(_tokenIdCounter.current() <= MAX_SUPPLY, "I'm sorry, we reached the cap");
        // check if the wallet address hasn't minted the max user amount
        require(mintWallets[msg.sender] <= USER_MAX, "I'm sorry, you reached the max amount for this wallet.");
        // increment the amount of token minted for the address
        mintWallets[msg.sender]++;
        // increment token counter
        _tokenIdCounter.increment();
        // mint token to the wallet address
        _safeMint(to, tokenId);
        // set token URI
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
