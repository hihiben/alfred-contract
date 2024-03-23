// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console2} from "forge-std/console2.sol";
import {Delegatee} from "src/Delegatee.sol";
import {DeployBaseScript} from "./DeployBaseScript.s.sol";

abstract contract DeployDelegatee is DeployBaseScript {
    struct DelegateeConfig {
        address deployedAddress;
        // constructor params
        address router;
        address aavev3Pool;
    }

    DelegateeConfig internal delegateeConfig;

    function _deployDelegatee() internal returns (address deployedAddress) {
        DelegateeConfig memory cfg = delegateeConfig;
        deployedAddress = cfg.deployedAddress;
        if (deployedAddress == UNDEPLOYED) {
            Delegatee delegatee = new Delegatee(cfg.router, cfg.aavev3Pool);
            deployedAddress = address(delegatee);
            console2.log("Delegatee Deployed:", deployedAddress);
        } else {
            console2.log("Delegatee Exists. Skip deployment of Delegatee:", deployedAddress);
        }
    }
}
