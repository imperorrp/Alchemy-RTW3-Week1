// SPDX-License-Identifier: MIT
// Modified contract for Alchemy Uni RTW3's week 1 challenge: 
// Deployed to 0x6dc518d4d95787f1d4268e57851842f2e1b204b8 (Polygon Mumbai testnet)
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.7.3/utils/Counters.sol";

contract MyToken is ERC721, ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 MAX_SUPPLY = 10000;
    //Adding a mapping: eth addresses to number of mints from that address
    mapping(address => uint) public numMints; 

    constructor() ERC721("Alchemy", "ALCH") {}

    //Added additional 'require' to ensure calling address' previous mints<=5 
    //  and increment numMints by 1 
    function safeMint(address to, string memory uri) public {
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId<=MAX_SUPPLY, "Sorry, all NFTs of this collection have been minted!");
        require(numMints[msg.sender]<=5, "Sorry, only 5 NFTs of this collection can be minted per address!");
        numMints[to]+=1;
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
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