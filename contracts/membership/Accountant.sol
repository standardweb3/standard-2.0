
pragma solidity ^0.8.10;

/// @author Hyungsuk Kang <hskang9@github.com>
/// @title Standard Membership Accountant to report membership points
contract Accountant {

    /// @dev fb: Financial block (the block height that started financing the DAO). Block is used because time can be manipulated by miners
    uint256 fb;
    /// @dev pointOf: The mapping of the month to the mapping of the member to the point
    mapping(uint256 => mapping(address => uint256)) public pointOf;

    uint256 immutable public day;
    uint256 immutable public month;
    uint256 immutable public year;
    
    /// @param bfs_ The block finalization second that started financing the DAO
    constructor(uint256 bfs_) {
        fb=block.number;
        day = 1 days / bfs_;
        month = 30 days / bfs_;
        year = 365 days / bfs_;
    }

    /// @dev report: Report the membership point of the member
    /// @param member The member address
    /// @param amount The amount of the membership point
    /// @param bh The block height of the report
    function reportAdd(address member, uint256 amount, uint256 bh) public {
        // check if the member is subscribed as a member
        // require(ISubscription().subscribed(member), "Unsubscribed");
        // Suppose 1 year == 360 days
        // get nth month for block height
        uint256 nthMonth = (bh - fb) / month;
        pointOf[nthMonth][member] += amount;
    }

     /// @dev report: Revert the membership point of the member
    /// @param member The member address
    /// @param amount The amount of the membership point
    /// @param bh The block height of the report
    function reportSubtract(address member, uint256 amount, uint256 bh) public {
        // check if the member is subscribed as a member
        // require(ISubscription().subscribed(member), "Unsubscribed");
        // Suppose 1 year == 360 days
        // get nth month for block height
        uint256 nthMonth = (bh - fb) / month;
        pointOf[nthMonth][member] -= amount;
    }
}