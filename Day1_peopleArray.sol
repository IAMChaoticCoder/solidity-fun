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
      address Creator;
    }
    
    Person [] public people; // array of people
    
    // functions

    function getPerson(uint index) public view returns (string memory name, uint age, uint height, bool senior, address Creator)  {
        //- Create a public get function where we can input an people and retrieve the Person object with that people in the array.
        return (people[index].name, people[index].age, people[index].height, people[index].senior, people[index].Creator); // pull info for supplied index
    }

// Modify the Person struct and  add an address property Creator. Make sure to edit the createPerson function so that it sets this property to the msg.sender.
    function createPerson(string memory name, uint age, uint height) public {
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        // determine senior status
        if(age >= 65){
           newPerson.senior = true;
        }
        else{
           newPerson.senior = false;
        }
        newPerson.Creator = msg.sender;
           
        //When someone creates a new person, add the Person object to the people array instead of the mapping.
        people.push(newPerson); // add new person to the arrray 
    }
}