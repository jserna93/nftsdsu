// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NFT {
    // Mapping to store ownership of NFTs
    mapping(uint256 => address) private _owners;

    // Event to emit when an NFT is minted
    event Mint(address indexed owner, uint256 indexed tokenId);

    // Function to mint a new NFT
    function mint() public {
        uint256 tokenId = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));
        _owners[tokenId] = msg.sender;
        emit Mint(msg.sender, tokenId);
    }

    // Function to get the owner of an NFT
    function ownerOf(uint256 tokenId) public view returns (address) {
        return _owners[tokenId];
    }

    // Function to buy an NFT
    function buy(uint256 tokenId) public payable {
        address owner = ownerOf(tokenId);
        require(owner != address(0), "NFT does not exist");
        require(owner != msg.sender, "You already own this NFT");
        require(msg.value >= 1 ether, "Insufficient funds");

        payable(owner).transfer(msg.value);
        _owners[tokenId] = msg.sender;
    }

    // Function to sell an NFT
    function sell(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(owner == msg.sender, "You do not own this NFT");

        _owners[tokenId] = address(0);
        payable(msg.sender).transfer(1 ether);
    }
}
