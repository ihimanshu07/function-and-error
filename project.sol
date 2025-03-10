// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Token1 {
    string public name = "Luffy";
    string public symbol = "RUBBER";
    uint256 public totalSupply = 0;
    address public owner;

    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed from, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    error LowBalance(uint256 balance, uint256 withdraw);

    mapping(address => uint256) public balances;

    modifier onlyOwner {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function mint(address _to, uint256 _value) public onlyOwner {
        totalSupply += _value;
        balances[_to] += _value;
        emit Mint(_to, _value);
    }

    function burn(address _from, uint256 _value) public onlyOwner {
        if (balances[_from] < _value) {
            revert LowBalance({balance: balances[_from], withdraw: _value});
        } else {
            totalSupply -= _value;
            balances[_from] -= _value;
            emit Burn(_from, _value);
        }
    }

    function transfer(address _receiver, uint256 _value) public {
        require(balances[msg.sender] >= _value, "Account balance must be greater than the transferred value");
        balances[msg.sender] -= _value;
        balances[_receiver] += _value;
        emit Transfer(msg.sender, _receiver, _value);
    }
}

