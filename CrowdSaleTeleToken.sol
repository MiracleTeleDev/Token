pragma solidity ^0.4.18;

import "browser/MiracleTeleToken.sol";
import "browser/ERC20Token.sol";
import "browser/Owned.sol";
import "browser/SafeMath.sol";

contract CrowdSaleTeleToken is Owned {

    using SafeMath for uint256;

    uint256 public price;

    ERC20Token public crowdSaleToken;

    /**
     * Constructor function
     *
     * Setup the owner
     */
    constructor(uint256 _price, address _tokenAddress)
    	public
    {
        //set initial token price
        price = _price;

        //set crowdsale token
        crowdSaleToken = ERC20Token(_tokenAddress);
    }

    /**
     * Fallback function
     *
     * The function without name is the default function that is called whenever anyone sends funds to a contract
     */
    function ()
    	payableты
    	public
    {
        //calc buy amount
		uint256 amount = msg.value / price;

		//check amount, it cannot be zero
		require(amount != 0);

        //transfer required amount
		crowdSaleToken.transfer(msg.sender, amount.mul(10**uint256(crowdSaleToken.decimals)));
    }

    /**
     * Withdraw the funds
     */
    function withdrawal(uint256 _amount)
    	public
    	onlyOwner
    {
        //send requested amount to owner
    	msg.sender.transfer(_amount);
    }

	/**
	 * Set token price
	 */
    function setPrice(uint256 _price)
    	public
    	onlyOwner
    {
		//check new price, it cannot be zero
		assert(_price != 0);

		//set new crowdsale token price
		price = _price;
    }
}
