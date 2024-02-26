// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract forLoopDos {
    uint256 public a;
    function runOutOfGas() public {
        for (uint i = 0; i < 1000000; i++) {
           a++;
        }
    }

}