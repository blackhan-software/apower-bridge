// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "teleporter/contracts/src/Teleporter/upgrades/TeleporterRegistry.sol";
import {Test, console} from "forge-std/Test.sol";
import {MyTarget} from "../src/MyTarget.sol";

contract MyTargetTest is Test {
    address public constant MESSENGER = 0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf;
    address public constant REGISTRY = 0xF86Cb19Ad8405AEFa7d09C778215D2Cb6eBfB228;
    address public constant SOURCE = 0x3Db3A2B62C1E77aDaD4E8D0E6fED38E8B1b33776;

    MyTarget public target;

    function setUp() public {
        target = new MyTarget(REGISTRY);
    }

    function testAdd() public {
        bytes4 get_latest = TeleporterRegistry.getLatestTeleporter.selector;
        vm.mockCall(REGISTRY, abi.encodeWithSelector(get_latest), abi.encode(ITeleporterMessenger(MESSENGER)));
        bytes memory message = abi.encode(MyTarget.Action.add, abi.encode(1, 2));
        vm.prank(MESSENGER);
        target.receiveTeleporterMessage(0x0, SOURCE, message);
        assertEq(target.result(), 3);
    }

    function testSub() public {
        bytes4 get_latest = TeleporterRegistry.getLatestTeleporter.selector;
        vm.mockCall(REGISTRY, abi.encodeWithSelector(get_latest), abi.encode(ITeleporterMessenger(MESSENGER)));
        bytes memory message = abi.encode(MyTarget.Action.sub, abi.encode(3, 2));
        vm.prank(MESSENGER);
        target.receiveTeleporterMessage(0x0, SOURCE, message);
        assertEq(target.result(), 1);
    }
}
