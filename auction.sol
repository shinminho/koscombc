pragma solidity ^0.4.24;

contract AuctionV2 {

	address seller;
	uint public highestBid = 0;
	address public highestBidder;
	bool open = true;

    mapping (address=>uint) moneyback;
    
	modifier ifOpen { require( open ); _; }
	modifier onlySeller { require( msg.sender == seller ); _; }

	constructor() public { seller = msg.sender; }

	function bid() public payable ifOpen {
	    require( msg.value > highestBid );
		if( highestBid != 0 ) 
		    // highestBidder.transfer( highestBid ); // Dangerous for DoS
		    moneyback[highestBidder] += highestBid;
		highestBid = msg.value;
		highestBidder = msg.sender; 
	}

    function withdrawUnsafe() public {
        if( moneyback[msg.sender] > 0 ) {
            msg.sender.transfer( moneyback[msg.sender] );
            moneyback[msg.sender] = 0;
        }
    }	
    
    function withdrawSafe() public payable {
        //check
        require( moneyback[msg.sender] > 0 );
        
        //effect
        uint amount = moneyback[msg.sender];
        moneyback[msg.sender] = 0;
        
        //interact
        msg.sender.transfer( amount );
        //msg.sender.call.gas(10000000).value( amount );
    }	
    
	function close() public payable onlySeller ifOpen { 
	    open=false; 
	    msg.sender.transfer( highestBid );
	}
}
