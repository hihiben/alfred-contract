// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {SignatureChecker} from "@openzeppelin/utils/cryptography/SignatureChecker.sol";
import {DataType} from "src/libraries/DataType.sol";
import {TypedDataSignature} from "./utils/TypedDataSignature.sol";

contract LogicTypehash is Test, TypedDataSignature {
    using SignatureChecker for address;

    uint256 public constant PRIVATE_KEY = 0xed268e9bfff64d8c80c0d1f6791e6ae44ecf67170df01d039427bc2b4f2ffcf3;
    address public constant SIGNER = 0x25b956f4117A103c2E1c65CBf0a178777AC0A9a2;

    uint256 public chainId;
    address public verifyingContract;

    function setUp() public {
        verifyingContract = 0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC;
        chainId = 1;
    }

    function _buildDomainSeparator() internal view returns (bytes32) {
        bytes32 typeHash =
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
        bytes32 nameHash = keccak256("Alfred");
        bytes32 versionHash = keccak256("1");
        return keccak256(abi.encode(typeHash, nameHash, versionHash, chainId, verifyingContract));
    }

    function testTaskTypehash() external view {
        // Signed a task using metamask to obtain an external sig
        // https://stackblitz.com/edit/github-n5du9g-vs99sw?file=index.tsx
        bytes32 r = 0xa3ac9086f25785a63c1a61336f55d29ab6526d966276222555121a8143a9ef65;
        bytes32 s = 0x2af3e21872456cd6c855a87e47905f3fd2be0469026595a3276595e3f14b5054;
        uint8 v = 0x1b;
        bytes memory sig = bytes.concat(r, s, bytes1(v));

        DataType.Task memory task = DataType.Task(0, 0, 0, 0);

        // Verify the locally generated signature using the private key is the same as the external sig
        assertEq(getTypedDataSignature(task, _buildDomainSeparator(), PRIVATE_KEY), sig);

        // Verify the signer can be recovered using the external sig
        bytes32 hashedTypedData = getHashedTypedData(task, _buildDomainSeparator());
        assertTrue(SIGNER.isValidSignatureNow(hashedTypedData, sig));
    }
}
