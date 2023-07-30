// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract DropProfile is ERC721("DropProfile", "DROP") {
    //state variables

    address public owner;

    uint256 tokenId = 1;

    /// @dev Mapping from token ID to profile CID.
    mapping(uint256 => string) public profileCID;

    /// @dev Mapping from artist address to token ID.
    mapping(address => uint256) public artistTokenId;

    //modifiers

    modifier onlyOwner(uint256 _tokenId) {
        require(
            ownerOf(_tokenId) == msg.sender,
            "Only the owner can update their profile"
        );
        _;
    }

    modifier profileCheck() {
        require(artistTokenId[msg.sender] == 0, "You already have a profile");
        _;
    }

    //constructor

    constructor() {
        owner = msg.sender;
    }

    //external functions

    function mintProfile(string memory _profileCID) external profileCheck {
        artistTokenId[msg.sender] = tokenId;
        _safeMint(msg.sender, tokenId);
        profileCID[tokenId] = _profileCID;
        tokenId++;
    }

    function updateProfileCID(
        string memory _profileCID,
        uint256 _tokenId
    ) external onlyOwner(_tokenId) {
        profileCID[_tokenId] = _profileCID;
    }

    ///public

    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        _requireMinted(_tokenId);

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, profileCID[_tokenId]))
                : "";
    }

    ///internal

    function _baseURI() internal view virtual override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/";
    }

    function getArtistTokenId(address _artist) public view returns (uint256) {
        return artistTokenId[_artist];
    }

    function _beforeTokenTransfer(
        address,
        address,
        uint256 _tokenId,
        uint256
    ) internal view override {
        if (_ownerOf(_tokenId) != address(0)) {
            revert("Token transfer not allowed");
        }
    }
}