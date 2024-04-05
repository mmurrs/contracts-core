// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import { Ownable } from "solady/src/auth/Ownable.sol";
import { ERC721 } from "openzepplin/src/token/ERC721/extensions/ERC721URIStorage.sol";
import { IWitnessConsumer } from "src/interfaces/IWitnessConsumer.sol";
import { IWitness, Proof } from "src/interfaces/IWitness.sol";

abstract contract LazyMintNFT is ERC721URIStorage, Ownable, IWitnessConsumer {
    IWitness private privWitness;

    // Structs
    struct TokenData {
        string uri;
        bool minted;
    }

    // Mapping from token ID to data
    mapping(uint256 => TokenData) private _tokenData;
    
    constructor(IWitness _witness) ERC721("WitnessFungible", "WTNS") {
        privWitness = _witness;
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

        // Check to see if Gas Prices are lower than threshold

    }

    // Checks to see if Gas is under a certain limits
    // If so - mint
    // Else - wait to mint, requires redeem call
    function mint(address to, uint256 tokenId, Proof calldata proof) public onlyOwner {
        _mint(to, tokenId, proof);
    }
    // Private Mint function to handle logic
    function _mint(address to, uint tokenId, Proof calldata proof) private {

    }

    function burn() public {

    }


    // Function to mint NFT
    // Function to get pricefeed of GAS

}