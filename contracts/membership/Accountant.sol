// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.10;

contract Accountant {

    // Financial time (time that started financing the DAO)
    uint256 ft;
    mapping(uint256 => mapping(address => uint256)) public pointOf;
    
    constructor(uint256 ft_) {
        ft=ft_;
    }

    function report(address member, uint256 amount, uint256 timestamp) public {
        // check if the member is subscribed as a member
        //require(ISubscription().subscribed(member), "Unsubscribed");
        // Suppose 1 year == 360 days
        uint256 quarter = timestamp - ft / 90 days + 1;
        pointOf[quarter][member] += amount;
    }
}