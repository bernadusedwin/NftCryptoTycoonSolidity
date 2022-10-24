// contracts/GameItems.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./interfaces.sol";
import "hardhat/console.sol";

contract TrainCargoConcept is ERC1155 {
    uint256 public constant GOLD = 0;
    uint256 public constant SILVER = 1;
    uint256 public constant THORS_HAMMER = 2;
    uint256 public constant SWORD = 3;
    uint256 public constant SHIELD = 4;

    constructor() public ERC1155("https://game.example/api/item/{id}.json") {
        _mint(msg.sender, GOLD, 10**18, "");
        _mint(msg.sender, SILVER, 10**27, "");
        _mint(msg.sender, THORS_HAMMER, 1, "");
        _mint(msg.sender, SWORD, 10**9, "");
        _mint(msg.sender, SHIELD, 10**9, "");
    }

    // function inquiryOwner(address address1)
    //     public
    //     view
    //     returns (uint256[] memory)
    // {

    function balanceOf(address account, uint256 id)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return 20;
    }

    function inquiry(address account, uint256 id)
        public
        view
        returns (uint256)
    {
        return 10;
    }

    struct Raid {
        uint16 minLevel;
        uint16 maxLevel;
        uint16 duration;
        uint16 cost;
        uint16 grtAtMin;
        uint16 grtAtMax;
        uint16 supAtMin;
        uint16 supAtMax;
        uint16 regReward;
        uint16 grtReward;
        uint16 supReward;
        uint16 minPotions;
        uint16 maxPotions; // Rewards are scale down to 100(= 1BS & 1=0.01) to fit uint16.
    }

    mapping(uint256 => address) public commanders;

    ERC1155Like items;

    uint256 public constant MAX_RUNES = 3;

    struct Campaign {
        uint8 location;
        bool double;
        uint64 end;
        uint112 runesUsed;
        uint64 seed;
    } // warning: runesUsed is both indication that a campaing has rewards and the actual numbers of runes used.

    function foundSomething2(uint256 rune, uint256 rdn) public {
        // if (cmp.runesUsed > 0 && cmp.runesUsed <= 2 * MAX_RUNES) return;

        // if (cmp.runesUsed == 0 || cmp.runesUsed >= 2 * MAX_RUNES) return;
        if (rune == 0 || rune >= 2 * MAX_RUNES) {
        // if (rune <= 2 * MAX_RUNES) {
            // if (rune > 0) {
            console.log("no runes");
            return;
        }

        if (rdn >= 9_700) {
            console.log("9700");
        }

        if (rdn <= 300) {
            console.log("300");
        }
    }

    function _foundSomething(
        Raid memory raid,
        Campaign memory cmp,
        uint256 rdn,
        uint256 id
    ) public {
        // if (cmp.runesUsed > 0 && cmp.runesUsed <= 2 * MAX_RUNES) return;
        if (cmp.runesUsed > 0 && cmp.runesUsed <= 2 * MAX_RUNES) {
            console.log("no runes");
        }

        if (rdn >= 9_700) {
            console.log("9700");
            // if (items.balanceOf(address(this), 100) > 0)
            //     items.safeTransferFrom(
            //         address(this),
            //         commanders[id],
            //         100,
            //         1,
            //         new bytes(0)
            //     );
        }

        if (rdn <= 300) {
            console.log("300");
            // if (items.balanceOf(address(this), 101) > 0)
            //     items.safeTransferFrom(
            //         address(this),
            //         commanders[id],
            //         101,
            //         1,
            //         new bytes(0)
            //     );
        }
    }
}
