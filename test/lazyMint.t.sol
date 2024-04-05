// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.18;
// Testing Imports
import { PRBTest } from "@prb/test/src/PRBTest.sol";
import { StdUtils } from "forge-std/src/StdUtils.sol";
import { LibBit } from "solady/src/utils/LibBit.sol";
import { console } from "forge-std/src/console.sol";
 
import { Proof } from "src/interfaces/IWitness.sol";
import { Witness } from "src/Witness.sol";
import { getRoot, hashToParent, decomposeNonZeroInterval } from "src/WitnessUtils.sol";
import { LazyMintNFT } from "src/lazyMint.sol";

contract MintTest is PRBTest, StdUtils {
    LazyMintNFT public nft;

    function setup() public {
        nft = new LazyMintNFT();
    }

    function basicTest() public {
        console.log(nft.WITNESS);
    }
}