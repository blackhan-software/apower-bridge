// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "teleporter/contracts/src/Teleporter/upgrades/TeleporterRegistry.sol";
import {Test, console} from "forge-std/Test.sol";
import {MySource} from "../src/MySource.sol";

contract MySourceTest is Test {
    address public constant MESSENGER = 0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf;
    address public constant REGISTRY = 0xF86Cb19Ad8405AEFa7d09C778215D2Cb6eBfB228;
    address public constant TARGET = 0xd54e3E251b9b0EEd3ed70A858e927bbC2659587d;

    MySource public source;

    function setUp() public {
        source = new MySource(REGISTRY);
    }

    function testAdd() public {
        bytes4 get_latest = TeleporterRegistry.getLatestTeleporter.selector;
        vm.mockCall(REGISTRY, abi.encodeWithSelector(get_latest), abi.encode(ITeleporterMessenger(MESSENGER)));
        bytes4 send_ccm = ITeleporterMessenger.sendCrossChainMessage.selector;
        bytes32 message_id = 0x0101010101010101010101010101010101010101010101010101010101010101;
        vm.mockCall(MESSENGER, abi.encodeWithSelector(send_ccm), abi.encode(message_id));
        source.addAt(TARGET, 1, 2);
    }

    function testSub() public {
        bytes4 get_latest = TeleporterRegistry.getLatestTeleporter.selector;
        vm.mockCall(REGISTRY, abi.encodeWithSelector(get_latest), abi.encode(ITeleporterMessenger(MESSENGER)));
        bytes4 send_ccm = ITeleporterMessenger.sendCrossChainMessage.selector;
        bytes32 message_id = 0x0202020202020202020202020202020202020202020202020202020202020202;
        vm.mockCall(MESSENGER, abi.encodeWithSelector(send_ccm), abi.encode(message_id));
        source.subAt(TARGET, 3, 2);
    }
}
