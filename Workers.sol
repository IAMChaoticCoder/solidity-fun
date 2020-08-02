pragma solidity ^0.6.4;
// MNP ChaoticCoder

import "./People.sol";

/*
//interface
contract  People {
    function createPerson(string memory name, uint age, uint height) public;
    
}

*/


// derived contract
contract Workers is People{
    //https://ropsten.etherscan.io/address/0xfe691d76652aaf1b982b63a8eddb996d7101d83f#events
    People instance = People(0xfe691d76652aaf1b982b63a8eddb996d7101d83f);
    
    mapping (address => uint ) internal salary;    //set the salary for the Worker
        
    function createWorker(string memory name,uint age, uint height) internal rightAge(age){
       /* section to create salary
        uint base = 40000; //base
        uint sal;
        sal = base + (age*720);          
        */
        createPerson(name,  age,  height);


    }



}





