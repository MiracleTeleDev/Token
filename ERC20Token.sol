pragma solidity ^0.4.16;

contract ERC20Token {

    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 18;

    uint256 public totalSupply;

    // This creates an array with all balances
    mapping (address => uint256) public balances;

	// Mapping for allowance
    mapping (address => mapping (address => uint256)) public allowed;

    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);

    // This generates a public event on the blockchain that will notify clients
    event Approval(address indexed sender, address indexed spender, uint256 value);

	function ERC20Token(uint256 _supply, string _name, string _symbol)
		public
	{
		//initial mint
        totalSupply = _supply * 10**uint256(decimals);
        balances[msg.sender] = totalSupply;

		//set variables
		name=_name;
		symbol=_symbol;

    	//trigger event
        emit Transfer(0x0, msg.sender, totalSupply);
	}

	/**
	 * Returns current tokens total supply
	 */
    function totalSupply()
    	public
    	constant
    	returns (uint256)
    {
		return totalSupply;
    }

	/**
     * Get the token balance for account `tokenOwner`
     */
    function balanceOf(address _owner)
    	public
    	constant
    	returns (uint256 balance)
    {
        return balances[_owner];
    }

	/**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint256 _value)
    	public
    	returns (bool success)
    {
		// To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender,0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
		require((_value == 0) || (allowed[msg.sender][_spender] == 0));

      	//set allowance
      	allowed[msg.sender][_spender] = _value;

		//trigger event
      	emit Approval(msg.sender, _spender, _value);

		return true;
    }

    /**
     * Show allowance
     */
    function allowance(address _owner, address _spender)
    	public
    	constant
    	returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }

	/**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint256 _value)
    	internal
    	returns (bool success)
    {
		// Do not allow transfer to 0x0 or the token contract itself or from address to itself
		require((_to != address(0)) && (_to != address(this)) && (_to != _from));

        // Check if the sender has enough
        require((_value > 0) && (balances[_from] >= _value));

        // Check for overflows
        require(balances[_to] + _value > balances[_to]);

        // Subtract from the sender
        balances[_from] -= _value;

        // Add the same to the recipient
        balances[_to] += _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

	/**
      * Transfer tokens
      *
      * Send `_value` tokens to `_to` from your account
      *
      * @param _to The address of the recipient
      * @param _value the amount to send
      */
    function transfer(address _to, uint256 _value)
    	public
    	returns (bool success)
    {
    	return _transfer(msg.sender, _to, _value);
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
    function transferFrom(address _from, address _to, uint256 _value)
    	public
    	returns (bool success)
    {
		// Check allowance
    	require(_value <= allowed[_from][msg.sender]);

		//decrement allowance
		allowed[_from][msg.sender] -= _value;

    	//transfer tokens
        return _transfer(_from, _to, _value);
    }
}