// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.4;
// MNP ChaoticCoder

// import "./Safemath.sol";


// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
contract SafeMath {
    function safeAdd(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}


contract Ownable{
    address public owner;

    modifier onlyOwner(){
        require(msg.sender == owner);
        _; //Continue execution
    }

    constructor() public{
        owner = msg.sender;
    }
}

contract ERC20 is Ownable , SafeMath {
    
    
    mapping (address => uint256) private _balances; // track balances of accounts

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }


    function name() public view returns (string memory) {
       return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address _account) public view returns (uint256) {
        return _balances[_account];
        
    }

    function mint(address _account, uint256 _amount) public onlyOwner {
        _balances[_account] = safeAdd(_balances[_account], _amount); 
        _totalSupply = safeAdd(_totalSupply,_amount);
        
        
    }

    function transfer(address _recipient, uint256 _amount) public returns (bool) {
        //check for required amount to transfer
        require(_balances[msg.sender] >= _amount, "Sorry, the sender does not have enough funds.");
        
        // remove from sender
        _balances[msg.sender] = safeSub(_balances[msg.sender], _amount);
        
        //add to _recipient
        _balances[_recipient] = safeAdd(_balances[_recipient], _amount);
        
        

    }
}
