// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/utils/ERC1155HolderUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

import "./FreyjaTear.sol";

contract FreyjaRelic is
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
    FreyjaTear private _freyjaTear;
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

    function initialize(address tearsAddress, uint256 treasury)
        public
        initializer
    {
        __ERC1155_init("https://api.ragnarokonchain.io/api/relics/");
        __ERC1155Supply_init();
        __ERC1155Holder_init();
        __Ownable_init();
        _freyjaTear = FreyjaTear(tearsAddress);
        _relicIds = 6;
        _unsafeMint(WEREWOLF_IDENTITY_FRAGMENT, treasury);
        _unsafeMint(VAMPIRE_IDENTITY_FRAGMENT, treasury);
        _unsafeMint(UNDEAD_IDENTITY_FRAGMENT, treasury);
    }

    // MINTING FUNCTIONS

    function mintFragment(uint256 id, bytes32[] calldata proof)
        external
        noContracts
    {
        require(id < 4, "only fragments");
        require(walletMintedFragments[msg.sender] < 10, "mint limit reached");
        bool whitelisted = !fragmentMinters[msg.sender] &&
            _isWhitelisted(id, msg.sender, proof);
        require(publicMintStarted || whitelisted, "mint not started");

        walletMintedFragments[msg.sender]++;
        fragmentMinters[msg.sender] = true;
        _safeMint(id);
    }

    function mint(uint256 id, bytes32[] calldata proof) external noContracts {
        require(id > 3, "no fragments");
        require(publicMintStarted, "mint not started");
        require(!relicMinters[id][msg.sender], "already minted");
        require(_isWhitelisted(id, msg.sender, proof), "not in whitelist");

        relicMinters[id][msg.sender] = true;
        _safeMint(id);
    }

    function burn(uint256 id, uint256 amount) external {
        _burn(msg.sender, id, amount);
    }

    function burnBatch(uint256[] calldata ids, uint256[] memory amounts)
        external
    {
        _burnBatch(msg.sender, ids, amounts);
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

    // STAKING FUNCTIONS

    function claimRelicReward(uint256 id) external {
        _claimReward(id);
    }

    function claimAllRewards() external {
        for (uint256 id = 1; id <= _relicIds; id++) {
            _claimReward(id);
        }
    }

    function stakeRelic(uint256 id, uint256 amount) external {
        emit Stake(id, amount, msg.sender);
        safeTransferFrom(msg.sender, address(this), id, amount, "");
        _claimReward(id);
        _relicOwners[msg.sender][id] += amount;
    }

    function unstakeRelic(uint256 id, uint256 amount)
        external
        onlyRelicOwner(id, amount)
    {
        emit Unstake(id, amount, msg.sender);
        _safeTransferFrom(address(this), msg.sender, id, amount, "");
        _mintReward(id, amount);
        _relicOwners[msg.sender][id] -= amount;

        if (_relicOwners[msg.sender][id] == 0) {
            _relicStakeTimes[msg.sender][id] = 0;
        }
    }

    function getAllAvailableRewards() external view returns (uint256) {
        uint256 totalReward;
        for (uint256 id = 1; id <= _relicIds; id++) {
            totalReward += _tearsReward(
                msg.sender,
                id,
                _relicOwners[msg.sender][id]
            );
        }
        return totalReward;
    }

    function getAvailableReward(uint256 id) external view returns (uint256) {
        return _tearsReward(msg.sender, id, _relicOwners[msg.sender][id]);
    }

    function getStakedRelicCount(uint256 id) external view returns (uint256) {
        return _relicOwners[msg.sender][id];
    }

    function getAllStakedRelicCount() external view returns (uint256[] memory) {
        uint256[] memory allCounts = new uint256[](_relicIds);
        for (uint256 index = 0; index < _relicIds; index++) {
            allCounts[index] = _relicOwners[msg.sender][index + 1];
        }
        return allCounts;
    }

    function uri(uint256 id) public view override returns (string memory) {
        return
            string(
                abi.encodePacked(super.uri(id), StringsUpgradeable.toString(id))
            );
    }

    function isWhitelisted(
        uint256 id,
        address account,
        bytes32[] calldata proof
    ) external view returns (bool) {
        return _isWhitelisted(id, account, proof);
    }

    function _isWhitelisted(
        uint256 id,
        address account,
        bytes32[] calldata proof
    ) internal view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(account));

        if (id < 4) {
            return MerkleProof.verify(proof, fragmentsMerkleRoot, leaf);
        }
        return MerkleProof.verify(proof, relicMerkleRoots[id], leaf);
    }

    function getRelicSupplyLimit(uint256 id) external view returns (uint256) {
        return _relicMintLimits[id];
    }

    function _claimReward(uint256 id) private {
        _mintReward(id, _relicOwners[msg.sender][id]);
        _relicStakeTimes[msg.sender][id] = block.timestamp;
    }

    function _mintReward(uint256 id, uint256 amount) private returns (uint256) {
        uint256 reward = _tearsReward(msg.sender, id, amount);

        if (reward > 0) {
            _freyjaTear.mint(msg.sender, reward);
            emit RewardMint(msg.sender, id, amount, reward);
        }

        return reward;
    }

    function _tearsReward(
        address owner,
        uint256 id,
        uint256 amount
    ) private view returns (uint256) {
        uint256 stakeTime = _relicStakeTimes[owner][id];
        if (stakeTime == 0) return 0;
        uint256 elapsedTime = block.timestamp - stakeTime;
        return (elapsedTime * amount * 1 ether) / 1 days;
    }

    // OWNER FUNCTIONS

    function setUri(string memory newUri) external onlyOwner {
        _setURI(newUri);
    }

    function setRelicMintLimit(uint256 id, uint256 amount) external onlyOwner {
        _relicMintLimits[id] = amount;
    }

    function addNewRelic() external onlyOwner {
        _relicIds++;
    }

    function enableMint() external onlyOwner {
        publicMintStarted = true;
    }

    function disableMint() external onlyOwner {
        publicMintStarted = false;
    }

    function setFragmentsMerkleRoot(bytes32 merkleRoot) external onlyOwner {
        fragmentsMerkleRoot = merkleRoot;
    }

    function setRelicMerkleRoot(uint256 id, bytes32 merkleRoot)
        external
        onlyOwner
    {
        relicMerkleRoots[id] = merkleRoot;
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

    // MODIFIERS

    modifier onlyRelicOwner(uint256 id, uint256 amount) {
        require(_relicOwners[msg.sender][id] >= amount, "E01: Not relic owner");
        _;
    }

    modifier onlyExistingRelic(uint256 id) {
        require(id > 0 && id <= _relicIds, "E03: Relic ID does not exists");
        _;
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
}