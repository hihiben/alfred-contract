// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Pool {
    uint256 public counter;
    address public user;

    constructor(address user_) {
        counter = 0;
        user = user_;
    }

    function getUserAccountData(address account)
        external
        returns (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        )
    {
        if (user == account) {
            if (counter == 0) {
                ++counter;
                return (0, 0, 0, 0, 0, 1000000000000000000);
            } else if (counter == 1) {
                ++counter;
                return (0, 0, 0, 0, 0, 1500000000000000000);
            } else {
                ++counter;
                return (0, 0, 0, 0, 0, 0);
            }
        } else {
            ++counter;
            return (0, 0, 0, 0, 0, 0);
        }
    }
}
