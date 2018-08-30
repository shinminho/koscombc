pragma solidity ^0.4.24;

import "./Mortal.sol";
//import "./Bazaar.sol";

interface Bazaar {
    function register() external returns (address[]);
}

interface Auction {
    function bid() external;
    function withdraw( address ) external;
    function winner() external view returns (address); 
}

contract Bidder is Mortal {
    
    address public bazaar;
    address[] public items;
    address[] public winners;
    
    constructor(address bazaar_) public {
       bazaar = bazaar_;
       //register
       items = Bazaar(bazaar).register();
        //address[] storage items = bazaar.call("register");
    } 
    
    function bid(uint index, uint amount) public {
       //Auction(items[index]).bid();
       if(!items[index].call.value(amount)("bid()"))
           revert("calling bid() of Auction failed");
    }

    function result() public {
        for( uint i=0; i<items.length; i++ ) {
            winners.push(Auction(items[i]).winner());
        }
    }
    
    function withdraw() public {
        for( uint i=0; i<items.length; i++ ) {
            Auction(items[i]).withdraw(owner);
        }
    }
}
