// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/utils/ERC1155HolderUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./erc721.sol";

// import "./FreyjaTear.sol";

contract TrainCargoNew is
    Initializable,
    ERC1155SupplyUpgradeable,
    ERC1155HolderUpgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    event Mint(address to, uint256 id, uint256 amount);
    event Stake(uint256 id, uint256 amount, address owner);
    event Unstake(uint256 id, uint256 amount, address owner);
    event RewardMint(address owner, uint256 id, uint256 amount, uint256 tears);

    uint256 public constant WEREWOLF_IDENTITY_FRAGMENT = 1;
    uint256 public constant UNDEAD_IDENTITY_FRAGMENT = 2;
    uint256 public constant VAMPIRE_IDENTITY_FRAGMENT = 3;
    uint256 public constant EYE_OF_SELF_REFLECTION = 4;
    uint256 public constant DROP_OF_BLOOD = 5;
    uint256 public constant DARK_MAGIC_SPELLBOOK = 6;

    bool public publicMintStarted;
    // FreyjaTear private _freyjaTear;
    uint256 private _relicIds;
    mapping(address => mapping(uint256 => uint256)) private _relicOwners;
    mapping(address => mapping(uint256 => uint256)) private _relicStakeTimes;
    mapping(uint256 => uint256) private _relicMintLimits;
    mapping(address => uint8) public walletMintedFragments;
    mapping(address => bool) public fragmentMinters;
    mapping(uint256 => mapping(address => bool)) public relicMinters;
    mapping(uint256 => bytes32) public relicMerkleRoots;
    bytes32 public fragmentsMerkleRoot;
    mapping(uint256 => uint256) private _relicMintCounts;
    address public combineManager;
    address public trainManager;

    constructor() {
        // enableMint();
        publicMintStarted = true;
        uint256 amount = 2000;
        // _relicMintLimits[0] = amount;
        _relicMintLimits[1] = amount;
        _relicMintLimits[2] = amount;
        _relicMintLimits[3] = amount;
    }

    function initialize(uint256 treasury) public initializer {
        __ERC1155_init("https://api.ragnarokonchain.io/api/relics/");
        __ERC1155Supply_init();
        __ERC1155Holder_init();
        __Ownable_init();
        // _freyjaTear = FreyjaTear(tearsAddress);
        _relicIds = 6;
        _unsafeMint(WEREWOLF_IDENTITY_FRAGMENT, treasury);
        _unsafeMint(VAMPIRE_IDENTITY_FRAGMENT, treasury);
        _unsafeMint(UNDEAD_IDENTITY_FRAGMENT, treasury);
    }

    function setCombineManager(address _combineManager) public onlyOwner {
        combineManager = _combineManager;
    }

    function setTrainManager(address _trainManager) public onlyOwner {
        trainManager = _trainManager;
    }

    function inquiryOwnerCargo(address address1)
        public
        view
        returns (uint256[] memory)
    {
        uint256 total = 7;
        uint256[] memory items = new uint256[](total);
        for (uint256 index = 0; index < total; index++) {
            items[index] = balanceOf(address1, index);
        }
        return items;
    }

    function getRelicMintCounts(uint256 id) external view returns (uint256) {
        return _relicMintCounts[id];
    }

    // MINTING FUNCTIONS

    // function mintFragment(uint256 id, bytes32[] calldata proof)
    function mintFragment(uint256 id, uint256 amount) external noContracts {
        require(id < 4, "only fragments");

        // todo - bug issue
        // require(walletMintedFragments[msg.sender] < 10, "mint limit reached");
        require(
            (walletMintedFragments[msg.sender] + amount) < 10,
            "mint limit reached"
        );

        // bool whitelisted = !fragmentMinters[msg.sender] &&
        //     _isWhitelisted(id, msg.sender, proof);
        // require(publicMintStarted || whitelisted, "mint not started");
        require(publicMintStarted, "mint not started");

        for (uint256 i = 0; i < amount; i++) {
            walletMintedFragments[msg.sender]++;
            fragmentMinters[msg.sender] = true;
            _safeMint(id);
        }
    }

    function _safeMint(uint256 id) private onlyExistingRelic(id) {
        require(
            _relicMintCounts[id] < _relicMintLimits[id],
            "E02: Supply limit exceeded"
        );
        return _unsafeMint(id, 1);
    }

    function _unsafeMint(uint256 id, uint256 amount) private {
        emit Mint(msg.sender, id, amount);
        _relicMintCounts[id] += amount;
        return _mint(msg.sender, id, amount, "");
    }

    function enableMint() external onlyOwner {
        publicMintStarted = true;
    }

    function setRelicMintLimit(uint256 id, uint256 amount) external onlyOwner {
        _relicMintLimits[id] = amount;
    }

    function mintTargetWithPay(
        address target,
        uint256 id,
        uint256 amount
    ) external {
        // validation - check caller
        require(trainManager == msg.sender, "not train manager");
        _mint(target, id, amount, "");
    }

    function mintTargetNoCost(
        address target,
        uint256 id,
        uint256 amount
    ) external {
        // validation - check caller
        require(combineManager == msg.sender, "not combine manager-1");
        _mint(target, id, amount, "");
    }

    function burnTarget(
        address target,
        uint256 id,
        uint256 amount
    ) external {
        // validation - check caller
        require(combineManager == msg.sender, "not combine manager-2");
        _burn(target, id, amount);
    }

    function burn(uint256 id, uint256 amount) private {
        _burn(msg.sender, id, amount);
    }

    modifier noContracts() {
        uint256 size = 0;
        address acc = msg.sender;
        assembly {
            size := extcodesize(acc)
        }

        require(msg.sender == tx.origin && size == 0, "No contracts here");
        _;
    }

    modifier onlyExistingRelic(uint256 id) {
        require(id > 0 && id <= _relicIds, "E03: Relic ID does not exists");
        _;
    }
    modifier onlyRelicOwner(uint256 id, uint256 amount) {
        require(_relicOwners[msg.sender][id] >= amount, "E01: Not relic owner");
        _;
    }

    // MANDATORY OVERRIDES

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155Upgradeable, ERC1155ReceiverUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}
}

// function stakeRelic(uint256 id, uint256 amount) external {
//     emit Stake(id, amount, msg.sender);
//     safeTransferFrom(msg.sender, address(this), id, amount, "");
//     _claimReward(id);
//     _relicOwners[msg.sender][id] += amount;
// }

// function _claimReward(uint256 id) private {
//     _mintReward(id, _relicOwners[msg.sender][id]);
//     _relicStakeTimes[msg.sender][id] = block.timestamp;
// }

// function _mintReward(uint256 id, uint256 amount) private returns (uint256) {
//     uint256 reward = _tearsReward(msg.sender, id, amount);

//     if (reward > 0) {
//         // _freyjaTear.mint(msg.sender, reward);
//         emit RewardMint(msg.sender, id, amount, reward);
//     }

//     return reward;
// }

// function _tearsReward(
//     address owner,
//     uint256 id,
//     uint256 amount
// ) private view returns (uint256) {
//     uint256 stakeTime = _relicStakeTimes[owner][id];
//     if (stakeTime == 0) return 0;
//     uint256 elapsedTime = block.timestamp - stakeTime;
//     return (elapsedTime * amount * 1 ether) / 1 days;
// }

// function unstakeRelic(uint256 id, uint256 amount)
//     external
//     onlyRelicOwner(id, amount)
// {
//     emit Unstake(id, amount, msg.sender);
//     _safeTransferFrom(address(this), msg.sender, id, amount, "");
//     _mintReward(id, amount);
//     _relicOwners[msg.sender][id] -= amount;

//     if (_relicOwners[msg.sender][id] == 0) {
//         _relicStakeTimes[msg.sender][id] = 0;
//     }
// }
