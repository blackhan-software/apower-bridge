// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../src/MySource.sol";

contract Deploy is Script {
    function run() external {
        uint256 key = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(key);
        address registry = vm.envAddress("MAIN_REGISTRY");
        new MySource(registry);
        vm.stopBroadcast();
    }
}
