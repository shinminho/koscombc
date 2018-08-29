pragma solidity ^0.4.24;

contract Owned {
    address internal owner;
    constructor() public { owner = msg.sender; }
    modifier onlyOwner { require(msg.sender == owner); _; }
}
