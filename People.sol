pragma solidity 0.5.12;

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
 
 
    function deletePerson(address creator) public onlyOwner {
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



contract Workers is People{
    
     
    function fire(address _address) public onlyOwner {
      deletePerson(_address);
      salary[_address] = 0;

   }
   
    mapping (address => uint ) internal salary;    //set the salary for the Worker
        
    function createWorker(string memory name,uint age, uint height) public rightAge(age){
       /* section to create salary
        uint base = 40000; //base
        uint sal;
        sal = base + (age*720);          
        */
        createPerson(name,  age,  height);


    }



}

/*
For clarity, start by renaming your contract from HelloWorld to People. 

Then, create a file with new contract called Workers, which should inherit from People. Then implement the functionality listed below. When you are done. Hand in a link to your code to Google Classroom for the Inheritance Assignment.

The Workers-contract should have the following functions and properties:

- Should inherit from the People Contract. 
- Should extend the People contract by adding another mapping called salary which maps an address to an integer. 
- Have a createWorker function which is a wrapper function for the createPerson function. Make sure to figure out the correct visibility level for the createPerson function (it should no longer be public).
- Apart from calling the createPerson function, the createWorker function should also set the salary for the Worker in the new mapping.
- When creating a worker, the persons age should not be allowed to be over 75. 
- Implement a fire function, which removes the worker from the contract.
*/
