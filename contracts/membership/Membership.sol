pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./libraries/TransferHelper.sol";

/// @author Hyungsuk Kang <hskang9@github.com>
/// @title Standard Membership registration and subscription
contract Membership is AccessControl {

    /// @dev registration fee per block
    uint256 public regFee;

    /// @dev subscription fee per block
    uint256 public subFee;

    /// @dev address of paying fee token
    address public feeToken;

    /// @dev mapping of member id to subscription status
    mapping(uint256 => uint256) public subscribedUntil;

    /// @dev setFees: Set fees for registration and subscription and token address
    /// @param feeToken_ The address of the token to pay the fee
    /// @param regFee_ The registration fee per block in one token
    /// @param subFee_ The subscription fee per block in one token
    function setFees(address feeToken_, uint256 regFee_, uint256 subFee_) public onlyRole(DEFAULT_ADMIN_ROLE) {
        feeToken = feeToken_;
        uint8 decimals = TransferHelper.decimals(fee);
        reg_fee = regFee_ * 10**decimals;
        sub_fee = subFee_ * 10**decimals;
    }

    /// @dev register: Register as a member
    function register() public {
        // check if the member already has the ABT, make sure one wallet, one ABT
        // Transfer required fund
        TransferHelper.safeTransferFrom(msg.sender, address(this), fee, reg_fee);
        // register as member
        ISABT(sabt).setRegistered(msg.sender, true);
        // issue membership from SABT and get id
        uint256 id = ISABT(sabt).mint(msg.sender);
        member[id] = msg.sender;
        isSubscribed[id] = 0;
    }   

    /// @dev subscribe: Subscribe to the membership until certain block height
    /// @param id_ The id of the ABT to subscribe with
    /// @param untilBh_ The block height to subscribe until
    function subscribe(uint256 id_, uint256 untilBh_) public {
        // check if the member has the ABT with input id
        require(balanceOf(msg.sender, id_) == 1, "not owned");
        // Transfer the tokens to this contract
        TransferHelper.safeTransferFrom(msg.sender, address(this), fee, sub_fee*(untilBh_- block.number));
        // subscribe for certain block
        subscribedUntil[id_] = untilBh_;
        // tell SABT that the member is subscribed
        ISABT(sabt).setSubscribed(id_, true);
    }

    /// @dev unsubscribe: Unsubscribe from the membership
    /// @param id_ The id of the ABT to unsubscribe with
    function unsubscribe(uint256 id_) public {
        // check if the member has the ABT with input id
        require(balanceOf(msg.sender, id_) == 1, "not owned");
        // refund the tokens to the member
        TransferHelper.safeTransfer(fee, msg.sender, sub_fee*(subscribedUntil[id_]- block.number));
        // unsubscribe
        subscribedUntil[id_] = 0;
        // tell SABT that the member is unsubscribed
        ISABT(sabt).setSubscribed(id_, false);
    }
}