pragma solidity ^0.4.16;

import "browser/ERC20Token.sol";
import "browser/SafeMath.sol";
import "browser/Owned.sol";

contract MiracleTeleToken is ERC20Token, Owned {

    using SafeMath for uint256;

    // Mapping for allowance
    mapping (address => uint8) public delegations;

	mapping (address => uint256) public contributions;

    // This generates a public event on the blockchain that will notify clients
    event Delegate(address indexed from, address indexed to);
    event UnDelegate(address indexed from, address indexed to);

    // This generates a public event on the blockchain that will notify clients
    event Contribute(address indexed from, uint256 indexed value);
    event Reward(address indexed from, uint256 indexed value);

    /**
	 * Initializes contract with initial supply tokens to the creator of the contract
	 */
    constructor(uint256 _supply) ERC20Token(_supply, "MiracleTele", "TELE") public {}

	/**
	 * Mint new tokens
	 *
	 * @param _value the amount of new tokens
	 */
    function mint(uint256 _value)
        public
        onlyOwner
    {
    	// Prevent mine 0 tokens
        require(_value > 0);

    	// Check overflow
    	balances[owner] = balances[owner].add(_value);
        totalSupply = totalSupply.add(_value);

        emit Transfer(address(0), owner, _value);
    }

    function delegate(uint8 _v, bytes32 _r, bytes32 _s)
        public
        onlySigner
    {
		address allowes = ecrecover(getPrefixedHash(signer), _v, _r, _s);

        delegations[allowes]=1;

        emit Delegate(allowes, signer);
    }

	function unDelegate(uint8 _v, bytes32 _r, bytes32 _s)
        public
        onlySigner
    {
    	address allowes = ecrecover(getPrefixedHash(signer), _v, _r, _s);

        delegations[allowes]=0;

        emit UnDelegate(allowes, signer);
    }

	/**
     * Show delegation
     */
    function delegation(address _owner)
    	public
    	constant
    	returns (uint8 status)
    {
        return delegations[_owner];
    }

    /**
     * @notice Hash a hash with `"\x19Ethereum Signed Message:\n32"`
     * @param _message Data to ign
     * @return signHash Hash to be signed.
     */
    function getPrefixedHash(address _message)
        pure
        public
        returns(bytes32 signHash)
    {
        signHash = keccak256(abi.encodeWithSignature("\x19Ethereum Signed Message:\n20", _message));
    }

    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` on behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferDelegated(address _from, address _to, uint256 _value)
        public
        onlySigner
        returns (bool success)
    {
        // Check delegate
    	require(delegations[_from]==1);

    	//transfer tokens
        return _transfer(_from, _to, _value);
    }

	/**
      * Contribute tokens from delegated address
      *
      * Contribute `_value` tokens `_from` address
      *
      * @param _from The address of the sender
	  * @param _value the amount to send
      */
    function contributeDelegated(address _from, uint256 _value)
        public
        onlySigner
    {
        // Check delegate
    	require(delegations[_from]==1);

        // Check if the sender has enough
        require((_value > 0) && (balances[_from] >= _value));

        // Subtract from the sender
        balances[_from] = balances[_from].sub(_value);

        contributions[_from] = contributions[_from].add(_value);

        emit Contribute(_from, _value);
    }

	/**
      * Reward tokens from delegated address
      *
      * Reward `_value` tokens to `_from` address
      *
      * @param _from The address of the sender
	  * @param _value the amount to send
      */
    function reward(address _from, uint256 _value)
        public
        onlySigner
    {
        require(contributions[_from]>=_value);

        contributions[_from] = contributions[_from].sub(_value);

        balances[_from] = balances[_from].add(_value);

        emit Reward(_from, _value);
    }

    /**
     * Don't accept ETH, it is utility token
     */
	function ()
	    public
	    payable
	{
		revert();
	}
}