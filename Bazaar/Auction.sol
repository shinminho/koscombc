pragma solidity ^0.4.24;

import "./Mortal.sol";

// This contract is used for BazaarAuction application
// Slight changes are made to AuctionV2 contract
contract Auction is Mortal {

	uint public highestBid = 0;
	address public highestBidder;
	bool isOpen = true;
    
    mapping (address=>uint) moneyback;
    
	modifier ifOpen { require( isOpen ); _; }

	function bid() public payable ifOpen {
	    require( msg.value > highestBid );
		if( highestBid != 0 ) 
		    // highestBidder.transfer( highestBid ); // Dangerous for DoS
		    moneyback[highestBidder] += highestBid;
		highestBid = msg.value;
		highestBidder = msg.sender; 
	}

    function withdraw(address beneficiary) public payable {
        //check
        require( moneyback[msg.sender] > 0 );
        
        //effect
        uint amount = moneyback[msg.sender];
        moneyback[msg.sender] = 0;
        
        //interact
        beneficiary.transfer( amount );
    }	
    
    function open() public onlyOwner {
        isOpen = true;
    }
    
	function close(address beneficiary) public payable onlyOwner ifOpen { 
	    isOpen=false; 
	    beneficiary.transfer( highestBid );
	}
	
	function winner() public view returns (address) { 
	    return highestBidder; 
	}
}
