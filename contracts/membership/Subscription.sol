// SPDX-License-Identifier: Apache-2.0

import "@openzeppelin/contracts/access/AccessControl.sol";
import "../libraries/TransferHelper.sol";

pragma solidity ^0.8.10;

// Subscription managed membership registration and subscription
contract Subscription is AccessControl {

    // registration fee
    uint256 reg_fee;

    // subscription fee
    uint256 sub_fee;

    // address of fee token
    address fee;

    mapping(address => bool) isSubscribed;


    function setFees(address feeToken, uint256 reg_fee, uint256 sub_fee, uint256 decimals) public onlyRole(DEFAULT_ADMIN_ROLE) {
        fee = feeToken;
        reg_fee = reg_fee * 10**decimals;
        sub_fee = sub_fee * 10**decimals;
    }

    function register() public {
        TransferHelper.safeTransferFrom(msg.sender, address(this), fee, reg_fee);
        // register as member
    }   

    function subscribe() public {
        TransferHelper.safeTransferFrom(msg.sender, address(this), fee, sub_fee);
        // subscribe for a year

        // for metadata, find Financial year of the metadata placed in
    }


    // Register a member with registration fee

    // exchange with NFT

    // claim shares with NFT in an era

    // fees
}