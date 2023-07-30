// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {DropProfile} from "../src/DropProfile.sol";

contract CounterTest is Test {
    DropProfile public dropProfile;

    function setUp() public {
        dropProfile = new DropProfile;
    }

    function name() public {
        assertEq(dropProfile.name(), "DropProfile");
    }

}
