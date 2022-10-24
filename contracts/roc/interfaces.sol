// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.7;
// import "../SharedLib.sol";
pragma solidity ^0.8.0;
import "./sharedLib.sol";


interface IRagnarokItem {
    function mint(address to, uint16 id) external;

    function mintRandom(
        address to,
        uint16 rarity,
        uint256 randomSeed
    ) external;

    function getItemsByRarity(uint16 rarity) external view returns (uint16[] memory);

    function balanceOf(address account, uint256 id) external view returns (uint256);

    function burnFrom(
        address from,
        uint256 id,
        uint256 amount
    ) external;

    function getItemType(uint16 itemTypeId) external view returns (uint256);
}

interface IRagnarokERC20 {
    function balanceOf(address from) external view returns (uint256 balance);

    function burn(uint256 amount) external;

    function burnFrom(address from, uint256 amount) external;

    function mint(address from, uint256 amount) external;

    function transfer(address to, uint256 amount) external;

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

interface IFreyjaRelic {
    function mint(
        address to,
        uint256 id,
        uint256 amount
    ) external;

    function burn(uint256 id, uint256 amount) external;

    function burnBatch(uint256[] calldata ids, uint256[] memory amounts) external;

    function burnFrom(
        address from,
        uint256 id,
        uint256 amount
    ) external;

    function burnBatchFrom(
        address from,
        uint256[] calldata ids,
        uint256[] calldata amounts
    ) external;

    function balanceOf(address account, uint256 id) external view returns (uint256);

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _amount,
        bytes memory _data
    ) external;
}

interface IBeast {
    function transferFrom(
        address from,
        address to,
        uint256 id
    ) external;

    function transfer(address to, uint256 id) external;

    function ownerOf(uint256 id) external returns (address owner);

    function mint(address to, uint256 tokenid) external;

    function getBeastClassNumberRepresentation(uint256 beastId) external view returns (uint16);

    function giveExperience(uint256 beastId, uint32 experience) external returns (uint256);

    function getBeastRepresentation(uint256 beastId) external view returns (uint256);

    function pull(address owner, uint256[] calldata ids) external;
}

interface IRagnarokConsumable {
    function mint(
        address to,
        uint256 id,
        uint256 amount
    ) external;
}

interface IERC721Puller {
    function pullCallback(address owner, uint256[] calldata ids) external;
}

interface IRandomOracle {
    function getRandomNumber(bytes32 requestId) external view returns (uint256);

    function requestRandomNumber() external returns (bytes32 requestId);
}

interface IBeastStaker {
    function getStakedBeasts(address player) external view returns (uint256[] memory);

    function isOwnerOfBeast(address player, uint256 beastId) external view returns (bool);
}

interface IExperienceTable {
    function getLevelUpExperience(uint8 currentLvl) external pure returns (uint32);
}