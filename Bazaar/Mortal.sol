pragma solidity ^0.4.24;

import "./Owned.sol";

contract Mortal is Owned { 
	function destroy() public onlyOwner { selfdestruct(owner); } 
}
