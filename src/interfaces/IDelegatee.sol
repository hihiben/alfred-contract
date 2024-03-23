// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {DataType as ProtocolinkDataType} from "@protocolink/libraries/DataType.sol";
import {DataType} from "../libraries/DataType.sol";

interface IDelegatee {
    error SignatureExpired(uint256 deadline);

    error InvalidSignature();

    error InvalidStartHealthRatio(uint256 healthRatio);

    error InvalidAfterHealthRatio(uint256 healthRatio);

    function router() external view returns (address);

    function executeTask(address user, DataType.Task calldata task, bytes calldata taskSignature, bytes calldata data)
        external
        payable;

    // function executeTaskWithAllow(
    //     DataType.Task calldata task,
    //     bytes calldata signature,
    //     bytes calldata data,
    //     ProtocolinkDataType.DelegationDetails calldata details,
    //     bytes calldata delegateSignature
    // ) external;
}
