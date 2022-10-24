// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./MapManager.sol";

// https://solidity-by-example.org/hacks/re-entrancy/
contract RocCaller {
    MapManager public mapManager;

    constructor(address _mapManagerAddress) {
        mapManager = MapManager(_mapManagerAddress);
    }

    function createPublicInstance(uint16 mapId) external {
        mapManager.createPublicInstance(mapId);
    }

    function joinGroupBatch(uint240 groupId, uint16[] memory beastIds)
        external
    {
        mapManager.joinGroupBatch(groupId, beastIds);
    }

    function startGroup(uint240 groupId) external {
        mapManager.startGroup(groupId);
    }

    function execute(uint16 mapId, uint16[] memory beastIds) external {
        uint256 groupId2 = mapManager.createPublicInstance(mapId);
        uint240 groupId = uint240(groupId2);
        mapManager.joinGroupBatch(groupId, beastIds);
        mapManager.startGroup(groupId);
    }
}
