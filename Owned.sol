pragma solidity ^0.4.16;

contract Owned {
    
    address public owner;
    address public signer;

    constructor() public {
	owner = msg.sender;
	signer = msg.sender;
    }

    modifier onlyOwner {
    	require(msg.sender == owner);
        _;
    }

    modifier onlySigner {
	require(msg.sender == signer);
	_;
    }

    function transferOwnership(address newOwner) public onlyOwner {
	owner = newOwner;
    }

    function transferSignership(address newSigner) public onlyOwner {
        signer = newSigner;
    }
}