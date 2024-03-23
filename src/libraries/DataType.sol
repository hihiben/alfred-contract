// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library DataType {
    // @notice The task parameter
    struct Task {
        uint256 targetRatio;
        uint256 floorRatio;
        uint256 ceilingRatio;
        uint256 deadline;
    }
}
