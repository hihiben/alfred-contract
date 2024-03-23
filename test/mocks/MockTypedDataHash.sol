// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataType} from "src/libraries/DataType.sol";
import {TypedDataHash} from "src/libraries/TypedDataHash.sol";

contract MockTypedDataHash {
    using TypedDataHash for DataType.Task;

    function hash(DataType.Task calldata task) external pure returns (bytes32) {
        return task.hash();
    }
}
