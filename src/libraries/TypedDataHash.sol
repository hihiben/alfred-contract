// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataType} from "../libraries/DataType.sol";

/// @title Library for EIP-712 encode
/// @notice Contains typehash constants and hash functions for structs
library TypedDataHash {
    bytes32 internal constant TASK_TYPEHASH =
        keccak256("Task(uint256 targetRatio,uint256 floorRatio,uint256 ceilingRatio,uint256 deadline)");

    function hash(DataType.Task calldata task) internal pure returns (bytes32) {
        return keccak256(abi.encode(TASK_TYPEHASH, task));
    }
}
