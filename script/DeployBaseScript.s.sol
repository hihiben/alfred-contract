// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

abstract contract DeployBaseScript is Script {
    address public constant UNDEPLOYED = address(0);

    error InvalidDelegateeAddress();

    modifier isDelegateeAddressZero(address delegatee) {
        if (delegatee == UNDEPLOYED) revert InvalidDelegateeAddress();
        _;
    }

    function run() external {
        vm.startBroadcast();
        _run();
        vm.stopBroadcast();
    }

    function _run() internal virtual {}
}
