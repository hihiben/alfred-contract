// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {DataType as ProtocolinkDataType} from "@protocolink/libraries/DataType.sol";
import {IRouter} from "@protocolink/interfaces/IRouter.sol";
import {ECDSA} from "@openzeppelin/utils/cryptography/ECDSA.sol";
import {EIP712} from "@openzeppelin/utils/cryptography/EIP712.sol";
import {SignatureChecker} from "@openzeppelin/utils/cryptography/SignatureChecker.sol";
import {IDelegatee} from "./interfaces/IDelegatee.sol";
import {DataType} from "./libraries/DataType.sol";
import {TypedDataHash} from "./libraries/TypedDataHash.sol";

import {console} from "forge-std/Console.sol";

interface IPool {
    function getUserAccountData(address user)
        external
        returns (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        );
}

contract Delegatee is IDelegatee, EIP712 {
    using ECDSA for address;
    using TypedDataHash for DataType.Task;
    using SignatureChecker for address;

    address public immutable router;
    address public immutable aavev3Pool;

    uint256 public constant OFFSET = 1e14;

    constructor(address router_, address aavev3Pool_) EIP712("Alfred", "1") {
        router = router_;
        aavev3Pool = aavev3Pool_;
    }

    function executeTask(address user, DataType.Task calldata task, bytes calldata taskSignature, bytes calldata data)
        external
    {
        // Check task signature
        _validateTask(task, user, taskSignature);
        // Check before state
        _validateBeforeState(task, user);
        (
            bytes[] memory permit2Datas,
            ProtocolinkDataType.LogicBatch memory logicBatch,
            address signer,
            bytes memory signature,
            address[] memory tokensReturn
        ) = abi.decode(data[4:], (bytes[], ProtocolinkDataType.LogicBatch, address, bytes, address[]));
        IRouter(router).executeForWithSignerFee(user, permit2Datas, logicBatch, signer, signature, tokensReturn);
        // Check after state
        _validateAfterState(task, user);
    }

    // function executeTaskWithAllow(
    //     DataType.Task calldata task,
    //     bytes calldata signature,
    //     bytes calldata data,
    //     ProtocolinkDataType.DelegationDetails calldata details,
    //     bytes calldata delegateSignature
    // ) external {}

    function _validateTask(DataType.Task calldata task, address signer, bytes calldata signature) internal view {
        uint256 deadline = task.deadline;
        if (block.timestamp > deadline) revert SignatureExpired(deadline);
        if (!signer.isValidSignatureNow(_hashTypedDataV4(task.hash()), signature)) revert InvalidSignature();
    }

    function _validateBeforeState(DataType.Task calldata task, address user) internal {
        uint256 healthFactor = _getHealthFactor(user);
        if (healthFactor > task.floorRatio && healthFactor < task.ceilingRatio) {
            revert InvalidStartHealthRatio(healthFactor);
        }
    }

    function _validateAfterState(DataType.Task calldata task, address user) internal {
        uint256 ceiling = task.targetRatio * 101 / 100;
        uint256 floor = task.targetRatio * 99 / 100;
        uint256 healthFactor = _getHealthFactor(user);
        if (healthFactor > ceiling || healthFactor < floor) revert InvalidAfterHealthRatio(healthFactor);
    }

    function _getHealthFactor(address user) internal returns (uint256 healthFactor) {
        (,,,,, healthFactor) = IPool(aavev3Pool).getUserAccountData(user);
        healthFactor = healthFactor / OFFSET;
    }
}
