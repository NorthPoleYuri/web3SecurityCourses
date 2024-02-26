// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "forge-std/console.sol";
import {Utilities} from "../utils/Utilities.sol";
import {BaseTest} from "../BaseTest.sol";
import "../../unbounded_loop/forloop_dos.sol";
contract forLoopDosTest is BaseTest {
    forLoopDos public loopDos;

    function setUp() public override{
        loopDos = new forLoopDos();
    }

    function testRunOutOfGas() public {
        // gas limit
        uint256 gasLimit = 100000; 
        vm.expectRevert(); 
        loopDos.runOutOfGas{gas: gasLimit}();
    }
}