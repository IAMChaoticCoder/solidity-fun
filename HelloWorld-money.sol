pragma solidity 0.5.12;

contract HelloWorld{
// MNP ChaoticCoder
    // state variables //
    // create the struct for a person (people, name, age, height, senior)
    struct Person {
      uint id;
      string name;
      uint age;
      uint height;
      bool senior;
    }

    event personCreated(string name, bool senior);
    event personDeleted(string name, bool senior, address deletedBy);
    event personUpdated(string preName, string name, uint prevAge, uint age, uint prevHeight, uint height, bool prevSenior, bool senior); // new event to display changed elements

    address public owner;
    uint public balance; // tracking contract balance
    // functions

    modifier onlyOwner(){
        require(msg.sender == owner);
        _; //continue execution
    }

    constructor() public{
        owner = msg.sender;
    }

    mapping (address => Person) private people;
    address[] private creators;

    function createPerson(string memory name, uint age, uint height) public payable costs(1 ether) {
        require(age < 150, "Age needs to be below 150");
        // require(msg.value >= 1 ether); // minimum of 1 ETH to buy in (added to the function instead)
        balance += (msg.value); // add to contact balance
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
        /*
        how to cast an address as payable if needed
        address payable test = address(uint160(creator));
        */
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
   
    function updatePerson( string memory name, uint age, uint, uint height) public  onlyOwner {
        address creator = msg.sender;
        string memory prevName = people[msg.sender].name;  // keep prev name
        uint prevAge = people[creator].age;  // keep prev age
        uint prevHeight = people[creator].height;    // keep prev height
        bool prevSenior = people[creator].senior;    // keep prev height
        people[creator].name = name;
        people[creator].age = age;
        people[creator].height = height;
        bool senior;
        if(age >= 65){
            people[creator].senior = true;
        }
        else{
            people[creator].senior = false;
        }
        senior = people[creator].senior;
        assert(keccak256( abi.encodePacked( people[msg.sender].name, people[msg.sender].age, people[msg.sender].height, people[msg.sender].senior)) == keccak256(abi.encodePacked(people[creator].name, people[creator].age, people[creator].height, people[creator].senior)));
        emit personUpdated(prevName, name, prevAge, age, prevHeight, height, prevSenior, senior);
    }

    function withdrawAll() public onlyOwner returns(uint){
        uint toTransfer = balance;
        balance = 0; 
        msg.sender.transfer(toTransfer);
        
        /* // always do change to state before transfer - security issue reentrance
        if (msg.sender.send(toTransfer)){
            return toTransfer;    
        } else {
            balance = toTransfer;
            return 0;
        }
        */
    }
        
        

    
}