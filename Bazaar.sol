pragma solidity ^0.4.24;

import "./Mortal.sol";
import "./Auction.sol";

contract Bazaar is Mortal {
    
    bool public isOpen=false;
    address[] public items;
    mapping( address=>bool) bidders; // bidders[<address>]: true -> registered
    
    modifier IfOpen( bool op ) {
        require( isOpen == op );
        _;
    }
    
    //constructor() public {}
    
    function addItem() public onlyOwner  IfOpen(false) {
        Auction a = new Auction();
        items.push( address(a) );
    }
    
    function register() public IfOpen(false) returns (address[]) {
        bidders[msg.sender] = true;
        return items;
    }
    
    function open() public onlyOwner  IfOpen(false) {
        isOpen = true;
        // open all items
        for(uint i=0; i<items.length; i++) {
            Auction(items[i]).open();
        }
    }
    function close() public onlyOwner  IfOpen(true) {
        isOpen = false;
        for(uint i=0; i<items.length; i++) {
            Auction(items[i]).close(owner);
        }
    }
    
}
