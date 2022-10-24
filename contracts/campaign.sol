// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./DataStructure.sol";
import "hardhat/console.sol";

//patch notes: New campaigns!

contract ElfCampaignsV3 {
    struct Camps {
        uint32 baseRewards;
        uint32 creatureCount;
        uint32 creatureHealth;
        uint32 expPoints;
        uint32 minLevel;
    }

    bool private initialized;
    address elfcontract;

    uint256 public MAX_LEVEL;
    uint256 public TIME_CONSTANT;
    uint256 public REGEN_TIME;
    address admin;

    mapping(uint256 => Camps) public camps; //memory slot for campaigns

    bytes32 internal ketchup;

    //EVENTS
    event LastKill(address indexed from);
    event AddCamp(
        uint256 indexed id,
        uint256 baseRewards,
        uint256 creatureCount,
        uint256 creatureHealth,
        uint256 expPoints,
        uint256 minLevel
    );

    /////new storage slots V3/////////
    mapping(uint256 => uint256) public campMaxLevel;
    bool private newCampsInit;

    function initialize(address _elfcontract) public {
        require(!initialized, "Already initialized");

        camps[1] = Camps({
            baseRewards: 5,
            creatureCount: 6000,
            creatureHealth: 12,
            expPoints: 9,
            minLevel: 1
        });
        camps[2] = Camps({
            baseRewards: 15,
            creatureCount: 3000,
            creatureHealth: 72,
            expPoints: 9,
            // minLevel: 15
            minLevel: 1
        });
        camps[3] = Camps({
            baseRewards: 30,
            creatureCount: 3000,
            creatureHealth: 132,
            expPoints: 9,
            // minLevel: 30
            minLevel: 1
        });
        MAX_LEVEL = 100;
        TIME_CONSTANT = 1 hours;
        REGEN_TIME = 300 hours;
        admin = msg.sender;
        elfcontract = _elfcontract;
        initialized = true;
    }

    function newCamps() public {
        require(admin == msg.sender);
        require(!newCampsInit, "Already deployed");

        camps[4] = Camps({
            baseRewards: 24,
            creatureCount: 15000,
            creatureHealth: 192,
            expPoints: 9,
            minLevel: 7
        });
        camps[5] = Camps({
            baseRewards: 36,
            creatureCount: 15000,
            creatureHealth: 264,
            expPoints: 9,
            minLevel: 14
        });
        camps[6] = Camps({
            baseRewards: 48,
            creatureCount: 10000,
            creatureHealth: 396,
            expPoints: 9,
            minLevel: 30
        });

        campMaxLevel[4] = 30;
        campMaxLevel[5] = 50;
        campMaxLevel[6] = 100;
        newCampsInit = true;
    }

    function gameEngine(
        uint256 _campId,
        uint256 _weaponTier,
        uint256[] memory listCargo
        )
        external
        returns (
            uint256 level,
            uint256 rewards,
            uint256 timestamp,
            uint256 inventory
        )
    {
        Camps memory camp = camps[_campId];

        // console.log("sender",msg.sender);
        require(elfcontract == msg.sender, "not elf contract");
        require(camp.creatureCount > 0, "no creatures left");

        camps[_campId].creatureCount = camp.creatureCount - 1;
        

        uint256 _sector = 1;
        uint256 creatureHealth = ((_sector - 1) * 12) + camp.creatureHealth;
        
        timestamp = block.timestamp + (camp.baseRewards * 10);

        rewards = calc(_campId,_weaponTier,listCargo);
        // rewards = camp.baseRewards + (2 * (_sector - 1));
        // rewards = rewards * (1 ether);
        // rewards = (_weaponTier + 1) * rewards;

        // for (uint256 index = 0; index < listCargo.length; index++) {
        //     uint256 total = listCargo[index];
        //     uint256 number1 = 0;
        //     if (index == 0){
        //         number1 = 20;
        //     }
        //     else if (index == 1){
        //         number1 = 30;
        //     }
        //     rewards = rewards + (number1 * total);
        // }

        if (camp.creatureCount == 0) {
            emit LastKill(msg.sender);
        }
    }



    function calc(
        uint256 _campId,
        uint256 _weaponTier,
        uint256[] memory listCargo
        )
        // external
        public
        view
        returns (
            uint256 rewards
        )
        {
            Camps memory camp = camps[_campId];
            uint256 _sector = 1;
            
            rewards = camp.baseRewards + (2 * (_sector - 1));
            rewards = (_weaponTier + 1) * rewards;
            rewards = rewards * (1 ether);

            for (uint256 index = 0; index < listCargo.length; index++) {
            uint256 total = listCargo[index];
            uint256 number1 = 0;
            if (index == 1){
                number1 = 20;
            }
            else if (index == 2){
                number1 = 30;
            }
            rewards = rewards + (number1 * total * (1 ether));
            
            }
        }


    function addCamp(
        uint256 id,
        uint16 baseRewards_,
        uint16 creatureCount_,
        uint16 expPoints_,
        uint16 creatureHealth_,
        uint16 minLevel_,
        uint256 maxLevel_
    ) external {
        require(admin == msg.sender);
        Camps memory newCamp = Camps({
            baseRewards: baseRewards_,
            creatureCount: creatureCount_,
            expPoints: expPoints_,
            creatureHealth: creatureHealth_,
            minLevel: minLevel_
        });
        campMaxLevel[id] = maxLevel_;
        camps[id] = newCamp;

        emit AddCamp(
            id,
            baseRewards_,
            creatureCount_,
            expPoints_,
            creatureHealth_,
            minLevel_
        );
    }

    //////Random Number Generator/////

    function _randomize(
        uint256 ran,
        string memory dom,
        uint256 ness
    ) internal pure returns (uint256) {
        return uint256(keccak256(abi.encode(ran, dom, ness)));
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
}
