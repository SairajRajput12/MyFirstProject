// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Lottery{
    address public manager; 
    address payable[] public participants; // dynamic array.it will store the transaction of all sender transaction. 
    
    constructor()
    {
        manager=msg.sender; // contract compile kartana particular account cha address manager madhe store hoil and manager will be the owner. 
        // it is global variable. // manager is: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    }

    receive() external payable // ether transfer hoil. 
    {
        // required statement. 
        require(msg.value == 0.02 ether); // jar he statement true asel tar line 19 execute houl nahi tar nahi honar. 
        participants.push(payable(msg.sender)); 
    }

    function getBalance() public view returns(uint)
    {
        require(msg.sender == manager); // address of calling account must be equal to manager's address.for checking the balance which means only manager has the access to the data. 
        return address(this).balance; 
    }

    function random() public view returns(uint)
    {
        // it was difficulty: prevrandao.but i do this due to version of compiler. 
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,participants.length))); // it is hashing algorithm. 
    }

    function selectWinner() public // returned the winner. 
    {
        require(msg.sender==manager); 
        require(participants.length >= 3); // ye wala function kaam karega. 
        uint r = random();
        address payable winner; 
        uint index = r%(participants.length); 
        // index hi participants.length peksha kamich yeil. 
        winner = participants[index]; 
        winner.transfer(getBalance()); 
        // resetting 
        participants = new address payable[](0); 
    }


}