pragma solidity ^0.4.24;

interface token {
    function transfer(address, uint) external;
}

contract Crowdfunding {
    address public beneficiary;
    uint public fundingGoal;
    uint public amountRaised = 0;
    uint public deadline;
    uint public price;
    token public tokenReward;
    mapping(address => uint) public balanceOf;
    bool fundingGoalReached = false;
    bool crowdsaleClosed = false;

constructor(
        address beneficiary_,
        uint fundingGoal_,
        uint durationInMinutes_,
        uint etherCostOfEachToken_,
        address addressOfToken_
    ) public {
        beneficiary = beneficiary_;
        fundingGoal = fundingGoal_ * 1 ether;
        deadline = now + durationInMinutes_ * 1 minutes;
        price = etherCostOfEachToken_ * 1 ether;
        tokenReward = token(addressOfToken_);
    }
    
    modifier afterDeadline() { require(now >= deadline); _; }

    event fundRaised( address, uint );

    function () payable public {
	    require(!crowdsaleClosed);
        uint amount = msg.value;
        balanceOf[msg.sender] += amount;
        amountRaised += amount;
        
        tokenReward.transfer(msg.sender, amount / price);
        
        emit fundRaised(msg.sender, amount);
    }

    event goalReached( address, uint );
    function checkGoalReached() public afterDeadline {
        if (amountRaised >= fundingGoal){
            fundingGoalReached = true;
            emit goalReached(beneficiary, amountRaised);
        }
        crowdsaleClosed = true;
    }
    
    event fundTranferred( address, uint );
    
    function completeFundraising() public afterDeadline {
    	require( beneficiary == msg.sender );
    	require( fundingGoalReached );
    	uint amount = amountRaised;
    	amountRaised = 0;
    	if ( beneficiary.send(amount) ) 
            emit fundTranferred(beneficiary, amountRaised);
        else 
    	    amountRaised = amount;
    }
    
    event donationRefunded( address, uint );
    
    function getRefund() public afterDeadline {
    	require( ! fundingGoalReached );
    	require( balanceOf[msg.sender] > 0 );
    	uint amount = balanceOf[msg.sender];
            balanceOf[msg.sender] = 0;
    	if (msg.sender.send(amount)) {
            emit donationRefunded(msg.sender, amount);
    	} else {
            balanceOf[msg.sender] = amount;
        }
    }
}
