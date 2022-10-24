// contracts/GameItems.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./erc721.sol";
import "hardhat/console.sol";

contract TrainCargo is ERC721 {
    /*
mint, jenis nya, harga nya
check total barang yang di punya
check barang yang aktif
ketika campaign, set sebagai aktive
validasi barang yang sudah digunakan
unstake
catat jalur terakhir yang dipakai
*/

    struct Cargo {
        address owner;
        uint256 timestamp;
        uint256 level;
        uint256 typeCargo;
    }

    bool private initialized;
    uint256 version = 5;
    address trainContract;

    mapping(uint256 => Cargo) public cargos;

    constructor(address trainAddress) {
        admin = trainAddress;
        maxSupply = 200;
    }

    function name() external view returns (string memory) {
        return string(abi.encodePacked("Cargo-", toString(version)));
    }

    function symbol() external pure returns (string memory) {
        return "CARGO";
    }

    function initialize(address _trainContract) public payable {
        require(!initialized, "Already initialized");
        // onlyOwner();
        trainContract = _trainContract;
        initialized = true;
    }

    function mintCargo() public payable returns (uint256 id) {
        // totalSupply++;
        id = totalSupply + 1;
        console.log("total supply", id);
        _mint(msg.sender, id);
    }

    function updateTimeStamp(
        uint256 id_,
        uint256 _timestamp,
        address trainOwner
    ) public payable {
        require(trainContract == msg.sender, "OnlyTrainCanCall");

        Cargo storage cargo = cargos[id_];
        require(cargo.timestamp < block.timestamp, "cargo busy");
        if (ownerOf[id_] != address(this)) {
            stake(id_);
        }
        require(cargo.owner == trainOwner, "NotYourCargo");
        cargo.timestamp = _timestamp;
    }

    function updateCargoVersion(uint256 id) public payable {
        require(
            ownerOf[id] == msg.sender || cargos[id].owner == msg.sender,
            "NotYourCargo"
        );
        require(cargos[id].timestamp < block.timestamp, "cargo busy");
        cargos[id].level = cargos[id].level + 1;
    }

    function stake(uint256 id) public payable {
        address owner = ownerOf[id];
        _transfer(owner, address(this), id);
        cargos[id].owner = owner;
    }

    function unstake(uint256 id) public payable {
        require(cargos[id].timestamp < block.timestamp, "cargo busy");
        address owner = cargos[id].owner;
        _transfer(address(this), owner, id);
        cargos[id].owner = address(this);
    }

    function inquiryOwner(address address1)
        public
        view
        returns (uint256[] memory)
    {
        uint256 counter = 0;
        uint256[] memory output = new uint256[](totalSupply);

        for (uint256 index = 1; index <= totalSupply; index++) {
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
            address addressSentinel = cargos[index].owner;

            if (addressSentinel == address1) {
                output[counter] = index;
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

    function onlyOwner() internal view {
        require(admin == msg.sender, "not_admin");
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
                    "data:application/json;",
                    abi.encodePacked(
                        '{"name":"Cargo #',
                        toString(id_),
                        " - ver",
                        toString(version),
                        '", "description":"This is Cargo !!! - ver',
                        toString(version),
                        '", "image": "',
                        "https://pacaviewer.fra1.cdn.digitaloceanspaces.com/renders_prod/ALPACADABRAZ_3D_3.png",
                        '"',
                        "}"
                    )
                )
            );
    }
}
