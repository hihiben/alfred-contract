// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {DataType as ProtocolinkDataType} from "@protocolink/libraries/DataType.sol";
import {DataType} from "src/libraries/DataType.sol";
import {Delegatee, IDelegatee} from "src/Delegatee.sol";
import {IRouter} from "@protocolink/interfaces/IRouter.sol";
import {TypedDataSignature} from "./utils/TypedDataSignature.sol";
import {Pool} from "./mocks/MockAavev3Pool.sol";
import {Router} from "./mocks/MockRouter.sol";

contract DelegateeTest is Test, TypedDataSignature {
    uint256 public constant BPS_BASE = 10_000;
    address public user;
    uint256 public key;
    address public alfred;

    address public router;
    address public signer;
    address public aavev3Pool;
    Delegatee public delegatee;
    bytes public taskSig;
    bytes public dataIn;
    bytes public dataOut;
    address public verifyingContract;
    uint256 public chainId;
    uint256 public someEther;

    // Empty arrays
    // Empty types
    address[] public tokensReturnEmpty;
    ProtocolinkDataType.Fee[] public feesEmpty;
    ProtocolinkDataType.Input[] public inputsEmpty;
    ProtocolinkDataType.Logic[] public logicsEmpty;
    ProtocolinkDataType.LogicBatch public logicBatchEmpty;
    bytes[] public permit2DatasEmpty;
    bytes32[] public referralsEmpty;

    function setUp() external {
        (user, key) = makeAddrAndKey("User");
        alfred = makeAddr("Alfred");
        router = address(new Router());
        signer = makeAddr("Signer");
        vm.etch(router, "code");
        aavev3Pool = address(new Pool(user));
        someEther = 1 ether;
        deal(alfred, someEther);

        delegatee = new Delegatee(router, aavev3Pool);

        // EIP712
        verifyingContract = address(delegatee);
        chainId = 1;

        // Make calldata
        uint256 deadline = block.timestamp;
        ProtocolinkDataType.LogicBatch memory logicBatch =
            ProtocolinkDataType.LogicBatch(logicsEmpty, feesEmpty, referralsEmpty, deadline);
        bytes memory signature = new bytes(65);
        bytes memory temp = new bytes(0);
        dataIn = abi.encodeCall(
            IRouter.executeWithSignerFee, (permit2DatasEmpty, logicBatch, signer, signature, tokensReturnEmpty)
        );
        console.logBytes(dataIn);
        dataOut = abi.encodeCall(
            IRouter.executeForWithSignerFee, (user, permit2DatasEmpty, logicBatch, signer, signature, tokensReturnEmpty)
        );

        vm.label(address(delegatee), "Delegatee");
        vm.mockCall(router, someEther, dataOut, temp);
    }

    function _buildDomainSeparator() internal view returns (bytes32) {
        bytes32 typeHash =
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
        bytes32 nameHash = keccak256("Alfred");
        bytes32 versionHash = keccak256("1");
        return keccak256(abi.encode(typeHash, nameHash, versionHash, chainId, verifyingContract));
    }

    function testExecuteTask() external {
        DataType.Task memory task = DataType.Task(15000, 14000, 16000, 1713754824);
        taskSig = getTypedDataSignature(task, _buildDomainSeparator(), key);
        vm.startPrank(alfred);
        delegatee.executeTask{value: someEther}(user, task, taskSig, dataIn);
    }
}
