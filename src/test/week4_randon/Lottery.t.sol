// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "../../week4_random/Lottery.sol";
import {Utilities} from "../utils/Utilities.sol";
import {BaseTest} from "../BaseTest.sol";
import "forge-std/console.sol";
import {stdError} from "forge-std/Test.sol";

contract lotteryTest is BaseTest  {
    address payable attacker;
    address payable someUser;
    address public predictedWinner;
    Lottery public lottery;
    constructor() {
        string[] memory labels = new string[](2);
        labels[0] = "Attacker";
        labels[1] = "Some User";

        preSetup(2, labels);
    }
    function setUp() public override {
        super.setUp();
        // Deploy the lottery contract with some initial funding
        lottery = new Lottery{value: 10 ether}(payable(address(this)));
        attacker = users[0];
        someUser = users[1];
    }

     function testPlayJoinLottery() public payable {
        // player A join lottery
        lottery.enterLottery{value: 0.01 ether}();
        assertEq(lottery.getParticipantsLength(), 1, "Number of players should be 1");
        lottery.lastLotteryTime();
    }
     function test_Exploit() public {
        runTest();
    }
    function exploit() internal override {
        /** CODE YOUR EXPLOIT HERE */
    }
    function success() internal override {
        /** SUCCESS CONDITIONS */
        console.log("Predicted Winner:", predictedWinner);
        assertEq(address(attacker), predictedWinner, "Attacker should be the predicted winner");
    }

}
