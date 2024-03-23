// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DataType} from "src/libraries/DataType.sol";
import {MockTypedDataHash} from "../mocks/MockTypedDataHash.sol";

contract TypedDataSignature is Test {
    MockTypedDataHash mockTypedDataHash;

    constructor() {
        initialize();
    }

    // For createSelectFork
    function initialize() internal {
        mockTypedDataHash = new MockTypedDataHash();
    }

    function getHashedTypedData(DataType.Task memory task, bytes32 domainSeparator) internal view returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", domainSeparator, mockTypedDataHash.hash(task)));
    }

    function getTypedDataSignature(DataType.Task memory task, bytes32 domainSeparator, uint256 privateKey)
        internal
        view
        returns (bytes memory)
    {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, getHashedTypedData(task, domainSeparator));
        return bytes.concat(r, s, bytes1(v));
    }
}
