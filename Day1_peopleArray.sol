pragma solidity 0.5.12;

contract HelloWorld{
// MNP ChaoticCoder
    // state variables //
    // create the struct for a person (index, name, age, height, senior)
    struct Person {
      uint id;
      string name;
      uint age;
      uint height;
      bool senior;
    }
    
    Person [] public people; // array of people
    
    // functions


    function createPerson(string memory name, uint age, uint height, bool senior) public {
   
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
        
        people.push(newPerson); // add new person to the arrray 
    }
}