// Get funds
// withdraw funds

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {

    using PriceConverter for uint;

    uint public constant minimumUSD = 50 *1e18;

    address[] public funders;
    mapping(address => uint) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // msg.value.getConversionRate():
        // what is reverting?
        // undo any action and return all gas
        // Want to be able to fund minimum USD;
        // send ETH to contract
        // msg.value => transaction value
        // msg.sender => the address that send the transaction
        require(msg.value.getConversionRate() > minimumUSD,"Didn't send enough ether");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;

    }

    modifier onlyOwner {
        // require(msg.sender == i_owner);
        if(msg.sender == i_owner) { revert NotOwner(); }
        _;
    }
    

    function withdraw() public payable onlyOwner {
        
        // for loop
        for(
            uint index = 0;
            index < funders.length;
            index++
        ) {
            address funder = funders[index];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
        // new array with 0 objects or nothing in array.

        // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"Send Failed!!!");
        // call
        (bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
        require(callSuccess,"Send Failed!!!");
        revert();
    }
    receive() external payable {
        fund();
    }
    fallback() external payable {
        fund();
    }

    // what if someone sends eth without fund function'
    // recieve()
    // fallback()

    
}