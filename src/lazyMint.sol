// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import { Ownable } from "solady/src/auth/Ownable.sol";
import { ERC721 } from "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { IWitnessConsumer } from "src/interfaces/IWitnessConsumer.sol";
import { IWitness, Proof } from "src/interfaces/IWitness.sol";


// Constract for foundation of LazyMinting with Witness Verification
abstract contract LazyMintNFT is ERC721URIStorage, Ownable, IWitnessConsumer {
    IWitness private privWitness;
    // Threshold of gas prices for minting
    uint256 GAS_THRESHOLD = 1000;

    // Structs
    struct TokenData {
        string uri;
        bool minted;
    }

    // Used to track NFTs to be minted for a user
    mapping (address  => mapping(uint256 => TokenData)) pendingMints;
        // Mapping from token ID to data
    mapping(uint256 => TokenData) private _tokenData;

    constructor(IWitness _witness, uint256 _threshold) {
        ERC721("WitnessFungible", "WTNS");
        privWitness = _witness;
        GAS_THRESHOLD = _threshold;
    }

    /// @inheritdoc IWitnessConsumer
    function WITNESS() public view override returns (IWitness) {
        return privWitness;
    }

    function claimToken(uint256 tokenId, Proof calldata proof) public {
        require(_exists(tokenId), "Error - Token does not exist");
        require(!_tokenData[tokenId].minted, "Token already minted");
        // Verify Proof before minting
        require(WITNESS().safeVerifyProof(proof), "Invalid Proof");

        // TODO - Check to see if Gas Prices are lower than threshold
        // Include call to Chainlink Price Feed
        // Case: Avoided threshold
        _mint(msg.sender, tokenId);
        _tokenData[tokenId].minted = true;
        _setTokenURI(tokenId, _tokenData[tokenId]);
        _transfer(this, msg.sender, tokenId);

        // Case: Threshold exceeded 
        // Reserve token for user to mint at another time
        pendingMints[msg.sender][tokenId] = _tokenData[tokenId];
        return tokenId;
    }

}