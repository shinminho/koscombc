pragma solidity ^0.4.24;

contract LotteryV1 {
    address[] public betters;
    address owner;
    address public winneraddr;
    uint public winnerindex;
    uint public prize;
    
    function mybalance() public view returns (uint) {
        return this.balance;
    }
    constructor() public {
        owner = msg.sender;
    }
    function enter() public payable {
        betters.push(msg.sender);    
    }
    function determineWinner() public payable {
        require( msg.sender == owner );
        winnerindex = random(betters.length);
        winneraddr = betters[winnerindex];
        prize = betters.length * (1 ether);
        winneraddr.transfer(prize);
    }
    function random(uint n) private view returns (uint) {
        // randomly pick a number in 0, ..., n-1
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))
                   ) % n;
        
    }
}
