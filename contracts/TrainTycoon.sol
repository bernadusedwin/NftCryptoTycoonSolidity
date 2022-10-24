//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./DataStructure.sol";
import "./erc721.sol";
import "./interfaces.sol";
import "./campaign.sol";
// import "./TrainCargo.sol";
import "./TrainCargoNew.sol";

contract TrainTycoon is ERC721 {
    event BalanceChanged(
        address indexed owner,
        uint256 indexed amount,
        bool indexed subtract
    );

    event Action(
        address indexed from,
        uint256 indexed action,
        uint256 indexed tokenId
    );

    mapping(uint256 => mapping(uint256 => uint256)) public listCargo;
    // mapping(uint256 => mapping(uint256 => uint256)) public totalCargoPublic;
    // mapping(uint256 => uint256) public collect1;

    string private greeting;

    bool public isMintOpen;
    bool public isGameActive;

    uint256 version = 5;
    uint256 public INIT_SUPPLY;
    uint256 public price;

    bytes32 internal ketchup;

    address public combineManager;

    IERC20Lite public trainCoin;
    ElfCampaignsV3 campaigns;

    TrainCargoNew trainCargo;

    function name() external view returns (string memory) {
        return string(abi.encodePacked("Crypto Tycoon-", toString(version)));
    }

    function symbol() external pure returns (string memory) {
        return "TYCOON";
    }

    mapping(uint256 => uint256) public sentinels;
    mapping(address => uint256) public bankBalances;

    constructor() {
        isMintOpen = true;
        isGameActive = true;
        maxSupply = 6666;
        INIT_SUPPLY = 3300;
        price = 1;
        admin = msg.sender;
    }

    function setAddresses(
        address _trainCoin,
        address _campaigns,
        address _trainCargo
    ) public {
        onlyOwner();
        trainCoin = IERC20Lite(_trainCoin);
        campaigns = ElfCampaignsV3(_campaigns);
        trainCargo = TrainCargoNew(_trainCargo);
    }

    function setCombineManager(address _combineManager) public {
        onlyOwner();
        combineManager = _combineManager;
    }

    function isPlayer() internal {
        uint256 size = 0;
        address acc = msg.sender;
        assembly {
            size := extcodesize(acc)
        }
        require((msg.sender == tx.origin && size == 0));
        ketchup = keccak256(abi.encodePacked(acc, block.coinbase));
    }

    function _rand() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        msg.sender,
                        block.difficulty,
                        block.timestamp,
                        // block.basefee,
                        ketchup
                    )
                )
            );
    }

    function setCargo(
        uint256 id_,
        uint256 type1,
        uint256 amount
    ) public {
        // console.log("sender set cargo",msg.sender);
        require(combineManager == msg.sender, "not combine manager-3");
        listCargo[id_][type1] = amount;
    }

    function _setAccountBalance(
        address _owner,
        uint256 _amount,
        bool _subtract
    ) private {
        _subtract
            ? bankBalances[_owner] -= _amount
            : bankBalances[_owner] += _amount;
        emit BalanceChanged(_owner, _amount, _subtract);
    }

    function unStake(uint256[] calldata ids) external {
        isPlayer();

        uint256[] memory numbers;
        for (uint256 index = 0; index < ids.length; index++) {
            _actions(ids[index], 0, msg.sender, 0, numbers);
        }
    }

    function passive(uint256[] calldata ids) external {
        isPlayer();

        uint256[] memory numbers;
        for (uint256 index = 0; index < ids.length; index++) {
            _actions(ids[index], 3, msg.sender, 0, numbers);
        }
    }

    function returnPassive(uint256[] calldata ids) external {
        isPlayer();

        uint256[] memory numbers;
        for (uint256 index = 0; index < ids.length; index++) {
            _actions(ids[index], 2, msg.sender, 0, numbers);
        }
    }

    function withdrawTokenBalance() external {
        require(bankBalances[msg.sender] > 0, "NoBalance");
        trainCoin.mint(msg.sender, bankBalances[msg.sender]);
        bankBalances[msg.sender] = 0;
    }

    function sendCampaign(uint256[] calldata ids, uint256 campaign_) external {
        isPlayer();
        // uint256[] memory cargoIds;

        for (uint256 index = 0; index < ids.length; index++) {
            uint256 id_ = ids[index];
            uint256 total = 7;
            uint256[] memory inputsCargo = new uint256[](total);
            for (uint256 index = 0; index < total; index++) {
                inputsCargo[index] = listCargo[id_][index];
            }

            _actions(id_, 2, msg.sender, campaign_, inputsCargo);
            // _actions(
            //     ids[index],
            //     2,
            //     msg.sender,
            //     campaign_,
            //     1,
            //     false,
            //     false,
            //     false,
            //     1,
            //     inputsCargo
            // );
        }
    }

    function upgradeWeapon(uint256 id_) external {
        uint256[] memory numbers;
        _actions(id_, 101, msg.sender, 0, numbers);
    }

    function _actions(
        uint256 id_,
        uint256 action,
        address elfOwner,
        uint256 campaign_,
        uint256[] memory cargoIds
    ) private {
        DataStructures.Elf memory elf = DataStructures.getElf(sentinels[id_]);
        DataStructures.ActionVariables memory actions;
        require(isGameActive, "game not active");
        require(
            ownerOf[id_] == msg.sender || elf.owner == msg.sender,
            "NotYourElf"
        );

        // uint256 rand = _rand();

        if (action == 0) {
            //Unstake if currently staked

            require(ownerOf[id_] == address(this), "error owner");
            require(elf.timestamp < block.timestamp, "elf busy");

            if (elf.action == 3) {
                // actions.timeDiff = (block.timestamp - elf.timestamp) / 1 days; //amount of time spent in camp CHANGE TO 1 DAYS!
                actions.timeDiff = (block.timestamp - elf.timestamp) / 1; //amount of time spent in camp CHANGE TO 1 DAYS!
                // elf.level = _exitPassive(actions.timeDiff, elf.level);
            }

            _transfer(address(this), elfOwner, id_);

            elf.owner = address(0);
        } else if (action == 2) {
            //campaign loop - bloodthirst and rampage mode loop.

            require(elf.timestamp < block.timestamp, "elf busy");
            require(elf.action != 3, "exit passive mode first");

            if (ownerOf[id_] != address(this)) {
                _transfer(elfOwner, address(this), id_);
                elf.owner = elfOwner;
            }

            (
                elf.level,
                actions.reward,
                elf.timestamp,
                elf.inventory
            ) = campaigns.gameEngine(campaign_, elf.weaponTier, cargoIds);

            uint256 options;
            options = 0;

            if (options > 0) {
                (
                    elf.weaponTier,
                    elf.primaryWeapon,
                    elf.inventory
                ) = DataStructures.roll(
                    id_,
                    elf.level,
                    _rand(),
                    options,
                    elf.weaponTier,
                    elf.primaryWeapon,
                    elf.inventory
                );
            }
            // actions.reward = (elf.weaponTier + 1) * actions.reward;
            _setAccountBalance(msg.sender, actions.reward, false);

            // emit Campaigns(msg.sender, actions.reward, campaign_, sector_, id_);
        } else if (action == 3) {
            //passive campaign
            //set timestamp to current block time
        } else if (action == 4) {
            ///return from passive mode
        } else if (action == 5) {} else if (action == 6) {} else if (
            action == 101
        ) {
            require(elf.timestamp < block.timestamp, "elf busy");
            elf.weaponTier = elf.weaponTier + 1;
            console.log("elf weapon tier", elf.weaponTier);

            if (ownerOf[id_] != address(this)) {
                _transfer(elfOwner, address(this), id_);
                elf.owner = elfOwner;
            }

            uint256 cost = 1.5 ether;
            bankBalances[msg.sender] >= cost
                ? _setAccountBalance(msg.sender, cost, true)
                : trainCoin.burn(msg.sender, cost);
        } else if (action == 7) {}

        actions.traits = DataStructures.packAttributes(
            elf.hair,
            elf.race,
            elf.accessories
        );
        actions.class = DataStructures.packAttributes(
            elf.sentinelClass,
            elf.weaponTier,
            elf.inventory
        );
        elf.healthPoints = DataStructures.calcHealthPoints(
            elf.sentinelClass,
            elf.level
        );
        elf.attackPoints = DataStructures.calcAttackPoints(
            elf.sentinelClass,
            elf.weaponTier
        );
        elf.level = elf.level > 100 ? 100 : elf.level;
        elf.action = action;

        sentinels[id_] = DataStructures._setElf(
            elf.owner,
            elf.timestamp,
            elf.action,
            elf.healthPoints,
            elf.attackPoints,
            elf.primaryWeapon,
            elf.level,
            actions.traits,
            actions.class
        );
        emit Action(msg.sender, action, id_);
    }

    function getTokenSentinel(uint256 _id)
        public
        view
        returns (DataStructures.Token memory token)
    {
        return DataStructures.getToken(sentinels[_id]);
    }

    function inquiryCargo(uint256 id) external view returns (uint256[] memory) {
        uint256 total = 7;
        uint256[] memory items = new uint256[](total);
        for (uint256 index = 0; index < total; index++) {
            items[index] = listCargo[id][index];
        }

        return items;
    }

    function mintCargo(uint256 id, uint256 amount) external {
        uint256 cost = amount * 10 * 1 ether;
        bankBalances[msg.sender] >= cost
            ? _setAccountBalance(msg.sender, cost, true)
            : trainCoin.burn(msg.sender, cost);
        // validation - check caller
        address target = msg.sender;
        trainCargo.mintTargetWithPay(target, id, amount);
    }

    function freshMint() external payable returns (uint256 id) {
        isPlayer();
        require(isMintOpen, "Minting is closed");
        uint256 cost;
        (cost, ) = getFreshMintPriceLevel();

        // console.log("output1",cost );

        if (totalSupply <= INIT_SUPPLY) {
            // console.log("output2a");
            require(msg.value >= cost, "NotEnoughEther");
        } else {
            // console.log("output2b");
            bankBalances[msg.sender] >= cost
                ? _setAccountBalance(msg.sender, cost, true)
                : trainCoin.burn(msg.sender, cost);
        }

        return _mintElf(msg.sender, address(0), 0, 0);
    }

    function mintWithCountdown() public payable returns (uint256 id) {
        isPlayer();
        require(isMintOpen, "Minting is closed");
        uint256 cost;
        (cost, ) = getMintPriceLevel();

        bankBalances[msg.sender] >= cost
            ? _setAccountBalance(msg.sender, cost, true)
            : trainCoin.burn(msg.sender, cost);

        uint16 id_ = _mintElf(msg.sender, msg.sender, 100, 1);
        ownerOf[id_] = address(this);
        return id_;
    }

    function _mintElf(
        address _to,
        address owner,
        uint256 _addBlock,
        uint256 action
    ) private returns (uint16 id) {
        uint256 rand = _rand();

        {
            DataStructures.Elf memory elf;
            id = uint16(totalSupply + 1);

            elf.owner = owner;

            elf.timestamp = block.timestamp + _addBlock;

            elf.weaponTier = elf.inventory = 0;
            elf.action = action;

            elf.primaryWeapon = 69; //69 is the default weapon - fists.

            (, elf.level) = getMintPriceLevel();

            elf.sentinelClass = uint16(_randomize(rand, "Class", id)) % 3;

            elf.race = rand % 100 > 97
                ? 3
                : uint16(_randomize(rand, "Race", id)) % 3;

            elf.hair = elf.race == 3
                ? 0
                : uint16(_randomize(rand, "Hair", id)) % 3;

            elf.accessories = elf.sentinelClass == 0
                ? (uint16(_randomize(rand, "Accessories", id)) % 2) + 3
                : uint16(_randomize(rand, "Accessories", id)) % 2; //2 accessories MAX 7

            uint256 _traits = DataStructures.packAttributes(
                elf.hair,
                elf.race,
                elf.accessories
            );
            uint256 _class = DataStructures.packAttributes(
                elf.sentinelClass,
                elf.weaponTier,
                elf.inventory
            );

            elf.healthPoints = DataStructures.calcHealthPoints(
                elf.sentinelClass,
                elf.level
            );
            elf.attackPoints = DataStructures.calcAttackPoints(
                elf.sentinelClass,
                elf.weaponTier
            );

            sentinels[id] = DataStructures._setElf(
                elf.owner,
                elf.timestamp,
                elf.action,
                elf.healthPoints,
                elf.attackPoints,
                elf.primaryWeapon,
                elf.level,
                _traits,
                _class
            );
        }

        _mint(_to, id);
    }

    function getFreshMintPriceLevel()
        public
        view
        returns (uint256 mintCost, uint256 mintLevel)
    {
        return (0.01 ether, 3);
    }

    function getMintPriceLevel()
        public
        view
        returns (uint256 mintCost, uint256 mintLevel)
    {
        return (0.5 ether, 3);
    }

    function _randomize(
        uint256 ran,
        string memory dom,
        uint256 ness
    ) internal pure returns (uint256) {
        return uint256(keccak256(abi.encode(ran, dom, ness)));
    }

    function getCurrrentBlockTimeStamp()
        public
        view
        returns (uint256 mintCost)
    {
        return block.timestamp;
    }

    function inquiryOwner(address address1)
        public
        view
        returns (uint256[] memory)
    {
        uint256 counter = 0;
        uint256[] memory output = new uint256[](totalSupply);

        for (uint256 index = 1; index <= totalSupply; index++) {
            // console.log("ownerof",ownerOf[index]);
            if (ownerOf[index] == address1) {
                output[counter] = index;
                counter++;
            }
        }
        return output;
    }

    function inquiryOwnerOnCastle(address address1)
        public
        view
        returns (uint256[] memory)
    {
        uint256 counter = 0;
        uint256[] memory output = new uint256[](totalSupply);

        for (uint256 index = 1; index <= totalSupply; index++) {
            address addressSentinel = getTokenSentinel(index).owner;

            if (addressSentinel == address1) {
                output[counter] = index;
                // console.log("inquiryOwnerOnCastle", index);
                counter++;
            }
        }
        return output;
    }

    function inquiryCastlePosition(uint256 item) public view returns (bool) {
        address address1 = ownerOf[item];
        if (address1 == address(this)) {
            return true;
        } else {
            return false;
        }
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function tokenURI(uint256 id_) external view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '{"name":"Train #',
                    toString(id_),
                    " - ver",
                    toString(version),
                    '", "description":"This is Train !!! - ver',
                    toString(version),
                    '", "image": "',
                    "https://pacaviewer.fra1.cdn.digitaloceanspaces.com/renders_prod/ALPACADABRAZ_3D_3.png",
                    '"',
                    "}"
                )
            );
    }

    function onlyOwner() internal view {
        require(admin == msg.sender, "not_admin");
    }
}
