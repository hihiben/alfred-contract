// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DeployDelegatee} from "./DeployDelegatee.s.sol";

contract DeployPolygon is DeployDelegatee {
    address public constant ROUTER = 0xDec80E988F4baF43be69c13711453013c212feA8;
    address public constant AAVEV3_POOL = 0x794a61358D6845594F94dc1DB02A252b5b4814aD;

    /// @notice Set up deploy parameters and deploy contracts whose `deployedAddress` equals `UNDEPLOYED`.
    function setUp() external {
        delegateeConfig = DelegateeConfig({deployedAddress: UNDEPLOYED, router: ROUTER, aavev3Pool: AAVEV3_POOL});
    }

    function _run() internal override {
        // delegatee
        _deployDelegatee();
    }
}
