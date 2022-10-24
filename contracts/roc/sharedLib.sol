// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.7;
pragma solidity ^0.8.0;
library SharedLib {
    uint256 public constant FACTIONS = 6;
    uint256 public constant CLASSES = FACTIONS * 2;

    struct Stats {
        uint256 hp;
        uint256 mana;
        uint256 con;
        uint256 str;
        uint256 dex;
        uint256 wis;
        uint256 intell;
    }

    struct TightStats {
        uint16 hp;
        uint16 mana;
        uint8 con;
        uint8 str;
        uint8 dex;
        uint8 wis;
        uint8 intell;
    }

    struct Beast {
        uint256 level;
        uint256 experience;
        uint256 faction;
        uint256 class;
        uint256 hp;
        uint256 mana;
        uint256 con;
        uint256 str;
        uint256 dex;
        uint256 wis;
        uint256 intell;
        uint256 slot0;
        uint256 slot1;
        uint256 slot2;
        uint256 slot3;
    }

    struct TightBeast {
        uint8 level;
        uint32 experience;
        uint8 faction;
        uint8 class;
        uint16 hp;
        uint16 mana;
        uint8 con;
        uint8 str;
        uint8 dex;
        uint8 wis;
        uint8 intell;
        uint16 slot0;
        uint16 slot1;
        uint16 slot2;
        uint16 slot3;
    }

    function beastToRepresentation(Beast memory beast) internal pure returns (uint256) {
        uint256 representation = uint256(beast.level);
        representation |= beast.experience << 8;
        representation |= beast.faction << 40;
        representation |= beast.class << 48;
        representation |= beast.hp << 56;
        representation |= beast.mana << 72;
        representation |= beast.con << 88;
        representation |= beast.str << 96;
        representation |= beast.dex << 104;
        representation |= beast.wis << 112;
        representation |= beast.intell << 120;
        representation |= beast.slot0 << 136;
        representation |= beast.slot1 << 152;
        representation |= beast.slot2 << 168;
        representation |= beast.slot3 << 184;

        return representation;
    }

    function representationToBeast(uint256 representation) internal pure returns (Beast memory beast) {
        beast.level = uint8(representation);
        beast.experience = uint32(representation >> 8);
        beast.faction = uint8(representation >> 40);
        beast.class = uint8(representation >> 48);
        beast.hp = uint16(representation >> 56);
        beast.mana = uint16(representation >> 72);
        beast.con = uint8(representation >> 88);
        beast.str = uint8(representation >> 96);
        beast.dex = uint8(representation >> 104);
        beast.wis = uint8(representation >> 112);
        beast.intell = uint8(representation >> 120);
        beast.slot0 = uint16(representation >> 136);
        beast.slot1 = uint16(representation >> 152);
        beast.slot2 = uint16(representation >> 168);
        beast.slot3 = uint16(representation >> 184);
    }

    function representationToBeastStats(uint256 representation) internal pure returns (Stats memory stats) {
        stats.hp = uint16(representation >> 56);
        stats.mana = uint16(representation >> 72);
        stats.con = uint8(representation >> 88);
        stats.str = uint8(representation >> 96);
        stats.dex = uint8(representation >> 104);
        stats.wis = uint8(representation >> 112);
        stats.intell = uint8(representation >> 120);
    }

    function statsToRepresentation(Stats memory stats) internal pure returns (uint256) {
        uint256 representation = uint256(stats.hp);
        representation |= stats.mana << 16;
        representation |= stats.con << 32;
        representation |= stats.str << 40;
        representation |= stats.dex << 48;
        representation |= stats.wis << 56;
        representation |= stats.intell << 64;

        return representation;
    }

    function representationToStats(uint256 representation) internal pure returns (Stats memory stats) {
        stats.hp = uint16(representation);
        stats.mana = uint16(representation >> 16);
        stats.con = uint8(representation >> 32);
        stats.str = uint8(representation >> 40);
        stats.dex = uint8(representation >> 48);
        stats.wis = uint8(representation >> 56);
        stats.intell = uint8(representation >> 64);
    }

    struct ItemType {
        uint256 rarity;
        uint256 levelRequirement;
        uint256 con;
        uint256 str;
        uint256 dex;
        uint256 wis;
        uint256 intell;
        uint256[4] slots;
        uint256[6] classes;
    }
    struct TightItemType {
        uint8 rarity;
        uint8 levelRequirement;
        uint8 con;
        uint8 str;
        uint8 dex;
        uint8 wis;
        uint8 intell;
        uint8[4] slots;
        uint8[6] classes;
    }

    function itemTypeToRepresentation(ItemType memory itemType) internal pure returns (uint256) {
        uint256 representation = uint256(itemType.rarity);
        representation |= itemType.levelRequirement << 8;
        representation |= itemType.con << 16;
        representation |= itemType.str << 32;
        representation |= itemType.dex << 40;
        representation |= itemType.wis << 48;
        representation |= itemType.intell << 56;
        uint8 lastPosition = 56;
        for (uint256 index = 0; index < 4; index++) {
            lastPosition += 8;
            representation |= itemType.slots[index] << lastPosition;
        }
        for (uint256 index = 0; index < 6; index++) {
            lastPosition += 8;
            representation |= itemType.classes[index] << lastPosition;
        }

        return representation;
    }

    function representationToItemType(uint256 representation) internal pure returns (ItemType memory itemType) {
        itemType.rarity = uint8(representation);
        itemType.levelRequirement = uint8(representation >> 8);
        itemType.con = uint8(representation >> 16);
        itemType.str = uint8(representation >> 32);
        itemType.dex = uint8(representation >> 40);
        itemType.wis = uint8(representation >> 48);
        itemType.intell = uint8(representation >> 56);
        uint8 lastPosition = 56;
        for (uint256 index = 0; index < 4; index++) {
            lastPosition += 8;
            itemType.slots[index] = uint8(representation >> lastPosition);
        }
        for (uint256 index = 0; index < 6; index++) {
            lastPosition += 8;
            itemType.classes[index] = uint8(representation >> lastPosition);
        }
    }

    function classToNumberRepresentation(uint8 faction, uint8 class) internal pure returns (uint8) {
        if (class == 0) {
            return 0;
        }
        return uint8(faction * FACTIONS + class);
    }

    function numberRepresentationToFaction(uint16 numberRepresentation) internal pure returns (uint8) {
        return uint8(numberRepresentation / FACTIONS);
    }

    function numberRepresentationToClass(uint8 numberRepresentation) internal pure returns (uint8) {
        return uint8(numberRepresentation % FACTIONS);
    }
}