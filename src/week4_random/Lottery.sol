// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "openzeppelin-contracts/utils/Address.sol";

contract Lottery {
    uint256 public constant ENTRANCE_FEE = 0.01 ether;
    address[] public participants;
    uint256 public lastLotteryTime;

    address payable public feeAddress;
    uint256 public feePercent = 10; // 10% fee

    event EnteredLottery(address participant);
    event WinnerSelected(address winner, uint256 prize);

    constructor(address payable _feeAddress) payable {
        feeAddress = _feeAddress;
        lastLotteryTime = block.timestamp;
    }

    function enterLottery() public payable {
        require(msg.value == ENTRANCE_FEE, "Incorrect entrance fee");
        participants.push(msg.sender);
        emit EnteredLottery(msg.sender);
    }

    //select winner
    function selectWinner() public {
        require(participants.length > 0, "No participants");
        uint256 winnerIndex = uint256(
            keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
        ) % participants.length;
        address payable winner = payable(participants[winnerIndex]);

        // calculate fee and prize
        uint256 prize = (address(this).balance * (100 - feePercent)) / 100;
        uint256 fee = address(this).balance - prize;

        // distribute fee and prize
        winner.transfer(prize);
        feeAddress.transfer(fee);

        emit WinnerSelected(winner, prize);

        // delete participants
        delete participants;
        lastLotteryTime = block.timestamp;
    }

    // get contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    // get participants
    function getParticipantsLength() public view returns (uint256) {
        return participants.length;
    }
}