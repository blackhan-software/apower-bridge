// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "teleporter/contracts/src/Teleporter/upgrades/TeleporterRegistry.sol";
import "teleporter/contracts/src/Teleporter/ITeleporterMessenger.sol";

contract MySource {
    bytes32 TARGET_BID = 0x7f48df43caac9a4133b6faf86eaa06333a1eb724ea3737988f067b7eb80c3b09;
    TeleporterRegistry public immutable REGISTRY;

    constructor(address registry) {
        require(registry != address(0), "MySource: invalid registry");
        REGISTRY = TeleporterRegistry(registry);
    }

    enum Action {
        add,
        sub
    }

    function addAt(address target, uint256 lhs, uint256 rhs) external {
        TeleporterMessageInput memory input = _tmi(target, _addArgs(lhs, rhs));
        ITeleporterMessenger messenger = REGISTRY.getLatestTeleporter();
        messenger.sendCrossChainMessage(input);
    }

    function _addArgs(uint256 lhs, uint256 rhs) private pure returns (bytes memory) {
        bytes memory data = abi.encode(lhs, rhs);
        return abi.encode(Action.add, data);
    }

    function subAt(address target, uint256 lhs, uint256 rhs) external {
        TeleporterMessageInput memory input = _tmi(target, _subArgs(lhs, rhs));
        ITeleporterMessenger messenger = REGISTRY.getLatestTeleporter();
        messenger.sendCrossChainMessage(input);
    }

    function _subArgs(uint256 lhs, uint256 rhs) private pure returns (bytes memory) {
        bytes memory data = abi.encode(lhs, rhs);
        return abi.encode(Action.sub, data);
    }

    function _tmi(address target, bytes memory message) private view returns (TeleporterMessageInput memory) {
        TeleporterFeeInfo memory feeInfo = TeleporterFeeInfo({feeTokenAddress: address(0), amount: 0});
        return TeleporterMessageInput({
            destinationBlockchainID: TARGET_BID,
            destinationAddress: target,
            feeInfo: feeInfo,
            requiredGasLimit: 100000,
            allowedRelayerAddresses: new address[](0),
            message: message
        });
    }
}
