pragma solidity ^0.8.10;


/// @author Hyungsuk Kang <hskang9@github.com>
/// @title Standard Membership Treasury to exchange membership points with rewards
contract Treasury {

    address private investor;
    address private dev;

    /// @dev For subscribers, exchange point to reward
    function exchange(address token, uint256 nthMonth, uint256 amount) public isSubscribed {
        // exchange membership point with reward
        IAccountant(accountant).getMP(msg.sender, nthMonth, amount);
        // exchange reward with token
        IERC20Minimal(token).transfer(msg.sender, amount);
        // subtract membership point in accountant
        IAccountant(accountant).subtractMP(msg.sender, nthMonth, amount);
        // 
    }

    /// @dev for investors, claim the reward with allocated revenue percentage
    function claim(address token, uint256 nthMonth) public isSubscribed {
        // get reward from accountant
        uint256 reward = IAccountant(accountant).getReward(msg.sender, nthMonth);
        // exchange reward with token
        IERC20Minimal(token).transfer(msg.sender, reward);
    }

    /// @dev for dev, settle the revenue with allocated revenue percentage
    function settle(address token, uint256 nthMonth) public isSubscribed {
        // get reward from accountant
        uint256 reward = IAccountant(accountant).getReward(msg.sender, nthMonth);
        // exchange reward with token
        IERC20Minimal(token).transfer(msg.sender, reward);
    }

}