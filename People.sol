pragma solidity ^0.6.4;
// MNP ChaoticCoder


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
    

contract People is Ownable{

    struct Person {
      uint id;
      string name;
      uint age;
      uint height;
      bool senior;
    }

    event personCreated(string name, bool senior);
    event personDeleted(string name, bool senior, address deletedBy);

    uint public balance;

    modifier costs(uint cost){
        require(msg.value >= cost);
        _;
    }


    modifier rightAge(uint _age){
        require((_age <= 75 && _age >=20), "Age needs to be between 20 and 75 years.");
        _;
    }

    mapping (address => Person) private people;
    address[] private creators;


  // functions
  
    //function createPerson(string memory name, uint age, uint height) public payable costs(100 wei){
    function createPerson(string memory name, uint age, uint height) internal rightAge(age) {
      
      //require(msg.value >= 100 wei);
      balance += msg.value;

        //This creates a person
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;

        if(age >= 65){
           newPerson.senior = true;
       }
       else{
           newPerson.senior = false;
       }

        insertPerson(newPerson);
        creators.push(msg.sender);


        assert(keccak256( abi.encodePacked( people[msg.sender].name, people[msg.sender].age, people[msg.sender].height, people[msg.sender].senior)) == keccak256(abi.encodePacked(newPerson.name, newPerson.age, newPerson.height, newPerson.senior)));
        emit personCreated(newPerson.name, newPerson.senior);
    
    }
    
    
    function insertPerson(Person memory newPerson) private {
        address creator = msg.sender;
        people[creator] = newPerson;
    }
    
    function getPerson() public view returns(string memory name, uint age, uint height, bool senior){
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].senior);
    }
 
 
    function fire(address creator) public onlyOwner {
      string memory name = people[creator].name;
      bool senior = people[creator].senior;

       delete people[creator];
       assert(people[creator].age == 0);
       emit personDeleted(name, senior, owner);
   }
   
   
   function getCreator(uint index) public view onlyOwner returns(address){
       return creators[index];
   }
   
   function withdrawAll() public onlyOwner returns(uint) {
       uint toTransfer = balance;
       balance = 0;
       msg.sender.transfer(balance);
       return toTransfer;
   }
}