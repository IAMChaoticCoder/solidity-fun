pragma solidity 0.5.12;
// MNP ChaoticCoder
contract HelloWorld{
    // state variables
    string public message = "Hello Filip";
    uint public number = 123;
    bool public isHappy = true;
    address public contractCreator = 0xCA35b6789dfe4626f2fe9;
    
    uint[] public numbers = [1,3,5,6];
    string[] public messages = [hello","hi"]
    
    
    // functions
    function getMessage() public view returns(string memory){
        return message;
    }
    
    function setMessage(string memory newMessage) public{
        message = newMessage;
    }
    
    function getNumber(uint index) public view returns(uint){
        return numbers[index];
        
    }
    
    function setNumber(uint newNumber, uint index) public {
        number[index] = newNumber;
        
    }
    
}