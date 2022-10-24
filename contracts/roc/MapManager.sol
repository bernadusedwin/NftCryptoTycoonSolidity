// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.7;
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
// import "./interfaces/Interfaces.sol";
// import "./SharedLib.sol";
import "./interfaces.sol";
import "./sharedLib.sol";

contract MapManager is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint8 public constant GROUP_SIZE = 6;

    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    enum GroupState {
        OFF,
        IDLE,
        STARTED,
        FINISHED
    }

    struct GroupStats {
        uint16 con;
        uint16 str;
        uint16 dex;
        uint16 wis;
        uint16 intell;
    }

    struct Group {
        uint240 id;
        uint16 mapId;
        address leader;
        uint256 endTime;
        bool isPrivate;
        EnumerableSetUpgradeable.UintSet beasts;
        EnumerableSetUpgradeable.AddressSet invites;
        GroupState state;
        GroupStats stats;
    }

    struct PublicGroup {
        uint256 id;
        uint16 mapId;
        address leader;
        uint256 endTime;
        bool isPrivate;
        BeastState[] beasts;
        address[] invites;
        GroupState state;
        uint256 tears;
    }

    struct Map {
        uint16 id;
        uint16 duration;
        uint256 price;
        uint8 levelRequirement;
        uint8 minGroupSize;
        uint16[GROUP_SIZE] requiredClasses;
        uint64 itemTypeId;
        uint8 itemDropProbability;
        uint256 skullReward;
        uint32 expReward;
        uint32 newDuration;
    }

    struct BeastState {
        uint256 representation;
        uint240 groupId;
        uint16 beastId;
    }

    uint16 private _mapIds;
    uint240 private _groupIds;
    mapping(uint16 => Map) private _maps;
    mapping(uint240 => Group) private _groups;
    mapping(uint16 => BeastState) private _beastStates;
    mapping(address => EnumerableSetUpgradeable.UintSet) private _playerGroups;
    mapping(address => EnumerableSetUpgradeable.UintSet) private _playerBeasts;
    address public beastAddress;
    address public skullAddress;
    address public tearAddress;
    mapping(uint240 => uint256) private _groupTears;
    // V2
    address public randomOracleAddress;
    address public consumableAddress;
    mapping(uint240 => bytes32) private _groupRequestIds;

    function initialize() public initializer {
        __Ownable_init();
    }

    function stakeBeastBatch(uint256[] memory beastIds) external {
        IBeast(beastAddress).pull(msg.sender, beastIds);
    }

    function pullCallback(address owner, uint256[] calldata ids) external {
        require(msg.sender == beastAddress, "not-allowed");
        for (uint256 index = 0; index < ids.length; index++) {
            _stakeBeast(uint16(ids[index]), owner);
        }
    }

    function unstakeBeastBatch(uint16[] memory beastIds) external {
        for (uint256 index = 0; index < beastIds.length; index++) {
            _unstakeBeast(beastIds[index]);
        }
    }

    function _stakeBeast(uint16 beastId, address owner) internal {
        _beastStates[beastId] = BeastState({
            representation: IBeast(beastAddress).getBeastRepresentation(beastId),
            groupId: 0,
            beastId: beastId
        });
        _playerBeasts[owner].add(beastId);
    }

    function _unstakeBeast(uint16 beastId) internal onlyBeastOwner(beastId) {
        require(_beastStates[beastId].groupId == 0, "in group");
        IBeast(beastAddress).transferFrom(address(this), msg.sender, beastId);
        _playerBeasts[msg.sender].remove(beastId);
    }

    function createPublicInstance(uint16 mapId) external onlyExistingMaps(mapId) returns (uint256) {
        _groupIds++;
        uint240 newGroupId = _groupIds;
        Group storage newGroup = _groups[newGroupId];
        newGroup.id = newGroupId;
        newGroup.leader = msg.sender;
        newGroup.mapId = mapId;
        newGroup.state = GroupState.IDLE;

        _playerGroups[msg.sender].add(newGroupId);
        return newGroupId;
    }

    function createPrivateInstance(uint16 mapId, address[] calldata invites)
        external
        onlyExistingMaps(mapId)
        returns (uint240)
    {
        _groupIds++;
        uint240 newGroupId = _groupIds;
        Group storage newGroup = _groups[newGroupId];
        newGroup.id = newGroupId;
        newGroup.leader = msg.sender;
        newGroup.mapId = mapId;
        newGroup.state = GroupState.IDLE;
        newGroup.isPrivate = true;
        newGroup.invites.add(msg.sender);
        for (uint256 index = 0; index < invites.length; index++) {
            newGroup.invites.add(invites[index]);
        }

        _playerGroups[msg.sender].add(newGroupId);
        return newGroupId;
    }

    function deleteGroup(uint240 groupId) external {
        Group storage group = _groups[groupId];
        require(group.leader == msg.sender, "only leader");
        require(group.beasts.length() == 0, "group not empty");
        require(group.state == GroupState.IDLE, "E00: Group already started");
        _playerGroups[msg.sender].remove(groupId);
    }

    function invite(uint240 groupId, address[] calldata invites) external {
        Group storage group = _groups[groupId];
        require(group.leader == msg.sender, "only leader");
        for (uint256 index = 0; index < invites.length; index++) {
            address invitedAddress = invites[index];
            group.invites.add(invitedAddress);
            _playerGroups[invitedAddress].add(groupId);
        }
    }

    function revokeInvite(uint240 groupId, address[] calldata revokes) external {
        Group storage group = _groups[groupId];
        require(group.leader == msg.sender, "only leader");
        uint256[] memory groupBeasts = group.beasts.values();
        for (uint256 index = 0; index < revokes.length; index++) {
            address revokedAddress = revokes[index];
            group.invites.remove(revokedAddress);

            if (!_isAnyBeastFromPlayer(groupBeasts, revokedAddress)) {
                _playerGroups[revokedAddress].remove(groupId);
            }
        }
    }

    function joinGroup(uint240 groupId, uint16 beastId) external {
        _joinGroup(groupId, beastId);
    }

    function joinGroupBatch(uint240 groupId, uint16[] memory beastIds) external {
        for (uint256 index = 0; index < beastIds.length; index++) {
            _joinGroup(groupId, beastIds[index]);
        }
    }

    function _joinGroup(uint240 groupId, uint16 beastId) internal onlyBeastOwner(beastId) {
        BeastState storage beastState = _beastStates[beastId];
        require(beastState.groupId == 0, "in group");
        Group storage group = _groups[groupId];
        require(group.state == GroupState.IDLE, "group started");
        require(group.beasts.length() < GROUP_SIZE, "group full");
        require(!group.isPrivate || group.invites.contains(msg.sender), "E09: The group is private");
        Map memory map = _maps[group.mapId];
        SharedLib.Beast memory beast = SharedLib.representationToBeast(_beastStates[beastId].representation);
        require(beast.level >= map.levelRequirement, "not enough lvl");

        if (map.price > 0) IRagnarokERC20(skullAddress).transferFrom(msg.sender, address(this), map.price);

        beastState.groupId = groupId;

        EnumerableSetUpgradeable.UintSet storage groupBeasts = group.beasts;
        groupBeasts.add(beastId);
        group.stats.con += uint8(beast.con);
        group.stats.str += uint8(beast.str);
        group.stats.dex += uint8(beast.dex);
        group.stats.wis += uint8(beast.wis);
        group.stats.intell += uint8(beast.intell);
        _playerGroups[msg.sender].add(groupId);
    }

    function leaveGroup(uint16 beastId) external {
        _leaveGroup(beastId);
    }

    function _leaveGroup(uint16 beastId) internal onlyBeastOwner(beastId) {
        uint240 groupId = _beastStates[beastId].groupId;
        require(groupId != 0, "not in group");
        Group storage group = _groups[groupId];
        require(group.state == GroupState.IDLE, "E00: Group already started");
        Map memory map = _maps[group.mapId];
        if (map.price > 0) IRagnarokERC20(skullAddress).transfer(msg.sender, map.price);

        _beastStates[beastId].groupId = 0;

        EnumerableSetUpgradeable.UintSet storage groupBeasts = group.beasts;
        SharedLib.Beast memory beast = SharedLib.representationToBeast(_beastStates[beastId].representation);
        groupBeasts.remove(beastId);

        group.stats.con -= uint8(beast.con);
        group.stats.str -= uint8(beast.str);
        group.stats.dex -= uint8(beast.dex);
        group.stats.wis -= uint8(beast.wis);
        group.stats.intell -= uint8(beast.intell);

        if (group.leader != msg.sender && !_isAnyBeastFromPlayer(groupBeasts.values(), msg.sender)) {
            _playerGroups[msg.sender].remove(groupId);
        }
    }

    function offerTears(uint240 groupId, uint256 amount) external {
        require(_groupTears[groupId] < 120 ether, "tears limit reached");
        IRagnarokERC20(tearAddress).transferFrom(msg.sender, address(this), amount);
        IRagnarokERC20(tearAddress).burn((amount * 90) / 100);
        _groupTears[groupId] += amount;
    }

    function startGroup(uint240 groupId) external {
        Group storage group = _groups[groupId];
        require(group.state == GroupState.IDLE, "group started");
        require(group.leader == msg.sender, "only leader");
        uint256 groupSize = group.beasts.length();
        Map memory map = _maps[group.mapId];
        require(groupSize >= map.minGroupSize, "group too small");

        IRagnarokERC20(skullAddress).burn((map.price * groupSize * 90) / 100);
        uint256 timeReduction = ((_groupTears[groupId] / 1 ether) * 60); // 1 minute per tear
        uint256 maxReduction = 60 * 120; // 120 minutes
        timeReduction = timeReduction > maxReduction ? maxReduction : timeReduction;
        group.endTime = block.timestamp + map.duration + map.newDuration - timeReduction;
        group.state = GroupState.STARTED;
        if (map.itemTypeId > 0) {
            _groupRequestIds[groupId] = IRandomOracle(randomOracleAddress).requestRandomNumber();
        }
    }

    function claimGroup(uint240 groupId) external {
        require(_playerGroups[msg.sender].contains(groupId), "not in group");
        Group storage group = _groups[groupId];
        require(group.state != GroupState.IDLE, "not started");
        require(group.endTime < block.timestamp, "not finished");
        group.state = GroupState.FINISHED;
        Map memory map = _maps[group.mapId];
        uint32 experience = (map.expReward * (100 + group.stats.intell / 5)) / 100;
        uint256 skull = (map.skullReward * (100 + group.stats.con / 5)) / 100;
        uint256[] memory groupBeasts = group.beasts.values();
        uint8 playerBeastsInGroup;
        for (uint256 index = 0; index < groupBeasts.length; index++) {
            uint16 beastId = uint16(groupBeasts[index]);
            if (_playerBeasts[msg.sender].contains(beastId)) {
                BeastState storage beastState = _beastStates[beastId];
                beastState.representation = IBeast(beastAddress).giveExperience(beastId, experience);
                beastState.groupId = 0;
                playerBeastsInGroup++;
            }
        }

        if (map.itemTypeId != 0) {
            uint256 itemsCount;
            uint256 randomSeed = IRandomOracle(randomOracleAddress).getRandomNumber(_groupRequestIds[groupId]);
            uint16 itemDropProbability = map.itemDropProbability + (group.stats.wis / 10);
            for (uint256 index = 0; index < playerBeastsInGroup; index++) {
                if (_getRandomNumber(randomSeed, index, 100) < itemDropProbability) {
                    itemsCount++;
                }
            }
            IRagnarokConsumable(consumableAddress).mint(msg.sender, map.itemTypeId, itemsCount);
        }

        IRagnarokERC20(skullAddress).mint(msg.sender, skull * playerBeastsInGroup);
        _playerGroups[msg.sender].remove(groupId);
    }

    function groupRewards(uint240 groupId)
        external
        view
        returns (
            uint32 experience,
            uint256 skull,
            uint256 itemTypeId,
            uint256 items
        )
    {
        Group storage group = _groups[groupId];
        require(group.state != GroupState.IDLE, "not started");
        require(group.endTime < block.timestamp, "not finished");
        Map memory map = _maps[group.mapId];
        itemTypeId = map.itemTypeId;
        experience = (map.expReward * (100 + group.stats.intell / 5)) / 100;
        skull = (map.skullReward * (100 + group.stats.con / 5)) / 100;
        uint256[] memory groupBeasts = group.beasts.values();
        uint8 playerBeastsInGroup;
        for (uint256 index = 0; index < groupBeasts.length; index++) {
            uint16 beastId = uint16(groupBeasts[index]);
            if (_playerBeasts[msg.sender].contains(beastId)) {
                playerBeastsInGroup++;
            }
        }
        skull = skull * playerBeastsInGroup;

        if (map.itemTypeId != 0) {
            uint256 randomSeed = IRandomOracle(randomOracleAddress).getRandomNumber(_groupRequestIds[groupId]);
            for (uint256 index = 0; index < playerBeastsInGroup; index++) {
                if (_getRandomNumber(randomSeed, index, 100) < map.itemDropProbability) {
                    items++;
                }
            }
        }
    }

    /*///////////////////////////////////////////////////////////////
                    ADMIN
    //////////////////////////////////////////////////////////////*/

    function setAddresses(
        address _beastAddress,
        address _skullAddress,
        address _tearAddress
    ) external onlyOwner {
        beastAddress = _beastAddress;
        skullAddress = _skullAddress;
        tearAddress = _tearAddress;
    }

    function setRandomOracleAddress(address _randomOracleAddress) external onlyOwner {
        randomOracleAddress = _randomOracleAddress;
    }

    function setConsumableAddress(address _consumableAddress) external onlyOwner {
        consumableAddress = _consumableAddress;
    }

    function withdraw(
        address to,
        address tokenAddress,
        uint256 amount
    ) external onlyOwner {
        IRagnarokERC20(tokenAddress).transfer(to, amount);
    }

    function registerMapRaw(
        uint32 duration,
        uint256 price,
        uint8 levelRequirement,
        uint8 minGroupSize,
        uint16[GROUP_SIZE] calldata requiredClasses,
        uint64 itemTypeId,
        uint8 itemDropProbability,
        uint256 skullReward,
        uint32 expReward
    ) external onlyOwner {
        _mapIds++;
        uint16 id = _mapIds;
        require(_maps[id].id == 0, "existing map");

        _maps[id] = Map(
            id,
            0,
            price,
            levelRequirement,
            minGroupSize,
            requiredClasses,
            itemTypeId,
            itemDropProbability,
            skullReward,
            expReward,
            duration
        );
    }

    function updateMapRaw(
        uint16 id,
        uint32 duration,
        uint256 price,
        uint8 levelRequirement,
        uint8 minGroupSize,
        uint16[GROUP_SIZE] calldata requiredClasses,
        uint64 itemTypeId,
        uint8 itemDropProbability,
        uint256 skullReward,
        uint32 expReward
    ) external onlyOwner {
        require(_maps[id].id != 0, "invalid map");
        _maps[id] = Map(
            id,
            0,
            price,
            levelRequirement,
            minGroupSize,
            requiredClasses,
            itemTypeId,
            itemDropProbability,
            skullReward,
            expReward,
            duration
        );
    }

    /*///////////////////////////////////////////////////////////////
                    GETTERS
    //////////////////////////////////////////////////////////////*/

    function getMap(uint16 mapId) external view onlyExistingMaps(mapId) returns (Map memory) {
        return _maps[mapId];
    }

    function getMaps() external view returns (Map[] memory) {
        Map[] memory maps = new Map[](_mapIds);
        for (uint16 index = 1; index <= _mapIds; index++) {
            maps[index] = _maps[index];
        }
        return maps;
    }

    function getStakedBeasts(address player) external view returns (uint256[] memory) {
        return _playerBeasts[player].values();
    }

    function getBeasts() public view returns (BeastState[] memory) {
        uint256[] memory beasts = _playerBeasts[msg.sender].values();
        BeastState[] memory beastStates = new BeastState[](beasts.length);
        for (uint16 index = 0; index <= beasts.length; index++) {
            beastStates[index] = _beastStates[uint16(beasts[index])];
        }
        return beastStates;
    }

    function getGroups(address player) public view returns (PublicGroup[] memory) {
        uint256[] memory playerGroups = _playerGroups[player].values();
        PublicGroup[] memory publicGroups = new PublicGroup[](playerGroups.length);

        for (uint256 index = 0; index < playerGroups.length; index++) {
            uint240 groupId = uint240(playerGroups[index]);
            Group storage group = _groups[groupId];
            publicGroups[index] = PublicGroup({
                id: groupId,
                mapId: group.mapId,
                leader: group.leader,
                endTime: group.endTime,
                isPrivate: group.isPrivate,
                beasts: _getBeastStates(group.beasts.values()),
                invites: group.invites.values(),
                state: group.state,
                tears: _groupTears[groupId]
            });
        }

        return publicGroups;
    }

    function getPlayerState(address player) external view returns (PublicGroup[] memory, uint256[] memory) {
        PublicGroup[] memory groups = getGroups(player);
        uint256[] memory beasts = _playerBeasts[player].values();
        return (groups, beasts);
    }

    function getGroup(uint240 groupId) external view returns (PublicGroup memory) {
        Group storage group = _groups[groupId];
        return
            PublicGroup({
                id: groupId,
                mapId: group.mapId,
                leader: group.leader,
                endTime: group.endTime,
                isPrivate: group.isPrivate,
                beasts: _getBeastStates(group.beasts.values()),
                invites: group.invites.values(),
                state: group.state,
                tears: _groupTears[groupId]
            });
    }

    function isOwnerOfBeast(address player, uint256 beastId) external view returns (bool) {
        return _playerBeasts[player].contains(beastId);
    }

    /*///////////////////////////////////////////////////////////////
                    PRIVATE
    //////////////////////////////////////////////////////////////*/

    function _getBeastStates(uint256[] memory beastIds) internal view returns (BeastState[] memory) {
        BeastState[] memory beastStates = new BeastState[](beastIds.length);
        for (uint256 index = 0; index < beastIds.length; index++) {
            beastStates[index] = _beastStates[uint16(beastIds[index])];
        }
        return beastStates;
    }

    function _isAnyBeastFromPlayer(uint256[] memory beastIds, address player) internal view returns (bool) {
        for (uint256 index = 0; index < beastIds.length; index++) {
            uint16 beastId = uint16(beastIds[index]);
            if (_playerBeasts[player].contains(beastId)) {
                return true;
            }
        }
        return false;
    }

    function _getRandomNumber(
        uint256 seed,
        uint256 nonce,
        uint256 limit
    ) internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed, nonce, msg.sender))) % limit;
    }

    /*///////////////////////////////////////////////////////////////
                    MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier onlyBeastOwner(uint16 beastId) {
        require(_playerBeasts[msg.sender].contains(beastId), "only beast owner");
        _;
    }

    modifier onlyExistingMaps(uint16 mapId) {
        require(_maps[mapId].id != 0, "E07: The map does not exists");
        _;
    }

    // MANDATORY OVERRIDES

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}