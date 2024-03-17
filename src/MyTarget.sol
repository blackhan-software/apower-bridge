// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "teleporter/contracts/src/Teleporter/upgrades/TeleporterRegistry.sol";
import "teleporter/contracts/src/Teleporter/ITeleporterReceiver.sol";

contract MyTarget is ITeleporterReceiver {
    TeleporterRegistry public immutable REGISTRY;

    constructor(address registry) {
        require(registry != address(0), "MyTarget: invalid registry");
        REGISTRY = TeleporterRegistry(registry);
    }

    enum Action {
        add,
        sub
    }

    function receiveTeleporterMessage(
        bytes32, // senderChainID,
        address, // senderAddress,
        bytes calldata message
    ) external {
        // only the teleporter receiver can deliver a message
        ITeleporterMessenger messenger = REGISTRY.getLatestTeleporter();
        require(msg.sender == address(messenger), "MyTarget: unauthorized");
        // decoding the action type
        (Action action, bytes memory args) = abi.decode(message, (Action, bytes));
        // route to the appropriate function
        if (action == Action.add) {
            (uint256 lhs, uint256 rhs) = abi.decode(args, (uint256, uint256));
            _add(lhs, rhs);
            return;
        }
        if (action == Action.sub) {
            (uint256 lhs, uint256 rhs) = abi.decode(args, (uint256, uint256));
            _sub(lhs, rhs);
            return;
        }
        revert("MyTarget: invalid action");
    }

    function _add(uint256 lhs, uint256 rhs) internal {
        result = lhs + rhs;
    }

    function _sub(uint256 lhs, uint256 rhs) internal {
        result = lhs - rhs;
    }

    uint256 public result;
}
