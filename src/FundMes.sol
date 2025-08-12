// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

import {PriceConvertor} from  "./PriceConvertor.sol";

error NotOwner();

contract FundMe {
    using  PriceConvertor for uint256;
    uint256 public myValue = 1;
    address[] public funders;
    mapping(address => uint256) fundersToAmount;
    uint256 public constant MIN_USD = 5e18;
    // here 5e18 doesnot mean it is in eth it is just to convert into 18 decimals and comparing
    
    address public immutable owner;

    constructor (){
        owner = msg.sender;
    }

    modifier onlyOwner {
    if (msg.sender != owner){revert NotOwner();}
        _;
    }

    function fund() public payable returns(bool) {
        myValue = myValue + 2;
        require(
            msg.value.getConversionRate() >= MIN_USD,
            "didnt send enough eth"
        );
        funders.push(msg.sender);
        fundersToAmount[msg.sender] = fundersToAmount[msg.sender] = msg.value;
        bool success = true;
        return success;
        //here reverts if didnt send enough eth
        //also revert is that reset the state of the blockchain or contract to its inital state
    }
        
    function withdraw() public onlyOwner returns (bool) {

        // require(msg.sender == owner, "sender not the owner");

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex+=1){
            address funder  = funders[funderIndex];
            fundersToAmount[funder] = 0;
            funders = new address[](0);
            //payable(msg.sender).transfer(address(this).balance);
            //this throughs an error and reverts the transaction
            //bool success = payable(msg.sender).send(address(this).balance);
            //require(success = true, "send failed");
            // this will return just the boolean
            (bool callSuccess, ) = payable(msg.sender).call{value : address(this).balance}("");
            require(callSuccess, "call Failed");
        }
        return callSuccess;
        
    }

    //what if someone transfer eth but not through the fund function??
    //here comes the fall back and receive functions
    //receive -- this doesnot take data
    //fallback -- this does take data or function identifer
    // they should be  external payable

    receive() external payable{
        fund();
    }

    fallback() external payable{
        fund();

    }
    
}
