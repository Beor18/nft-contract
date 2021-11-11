// SPDX-License_Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {
    string public id;
    string public name;
    string public description;
    
    address payable public author;
    string public state = 'Opened';
    uint public funds;
    uint public fundraisingGoal;

    
}