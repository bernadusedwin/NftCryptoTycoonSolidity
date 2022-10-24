//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
// import "./DataStructure.sol";
// import "./erc721.sol";
// import "./interfaces.sol";
// import "./campaign.sol";
import "./TrainTycoon.sol";
import "./TrainCargoNew.sol";

contract CombineManager {
    TrainTycoon trainTycoon;
    TrainCargoNew trainCargo;

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function setAddresses(address _trainTycoon, address _cargo) public {
        onlyOwner();
        trainTycoon = TrainTycoon(_trainTycoon);
        trainCargo = TrainCargoNew(_cargo);
    }

    function combineCargoBatch(uint256 id_, uint256[] memory inputs)
        external
        payable
    {
        // validation owner
        // validation type exist
        // validation has cargo before burn
        // validation is train now cooldown
        // isPlayer();
        uint256 total = inputs.length;

        // console.log("input id", id_);
        // console.log("total", total);
        for (uint256 index = 0; index < total; index = index + 2) {
            uint256 type1 = inputs[index];
            // console.log("index", type1);
            uint256 amount = inputs[index + 1];
            // console.log("amount", amount);
            combineCargoLogic(msg.sender, id_, type1, amount);
        }

        // cargo.burn
        // train update info
    }

    function combineCargoLogic(
        address sender,
        uint256 id_,
        uint256 type1,
        uint256 amount
    )  private {
        // validation owner
        // validation type exist
        // validation has cargo before burn
        // validation is train now cooldown
        // isPlayer();

        if (amount < 1000) {
            uint256 newNumber = trainTycoon.listCargo(id_, type1) + amount;
            trainTycoon.setCargo(id_, type1, newNumber);
            // console.log("sender", sender);
            trainCargo.burnTarget(sender, type1, amount);
        } else {
            amount = amount - 1000;
            // console.log("remove combine",amount);
            uint256 newNumber = trainTycoon.listCargo(id_, type1) - amount;
            trainTycoon.setCargo(id_, type1, newNumber);
            trainCargo.mintTargetNoCost(sender, type1, amount);
        }
    }

    function onlyOwner() internal view {
        require(admin == msg.sender, "not_admin");
    }
}

// function combineCargo(
//     uint256 id_,
//     uint256 type1,
//     uint256 amount
// ) external payable {
//     // validation owner
//     // validation type exist
//     // validation has cargo before burn
//     // validation is train now cooldown
//     // isPlayer();

//     // listCargo[id_][type1] = listCargo[id_][type1] + amount;

//     // console.log("combine cargo 1");
//     uint256 newNumber = trainTycoon.listCargo(id_, type1) + amount;
//     // console.log("combine cargo 2");
//     trainTycoon.setCargo(id_, type1, newNumber);
//     // console.log("combine cargo 3");

//     address sender = msg.sender;
//     console.log("sender", sender);
//     trainCargo.burnTarget(sender, type1, amount);
//     // console.log("combine cargo 4");

//     // cargo.burn
//     // train update info
// }

// function splitCargo(
//     uint256 id_,
//     uint256 type1,
//     uint256 amount
// ) external payable {
//     // validation owner
//     // validation type exist
//     // validation is train now cooldown
//     // validation totalCargo must more than zero after substract

//     // isPlayer();
//     uint256 newNumber = trainTycoon.listCargo(id_, type1) - amount;
//     trainTycoon.setCargo(id_, type1, newNumber);
//     trainCargo.mintTargetNoCost(msg.sender, type1, amount);
// }

// function combineCargo(
//     uint256 id_,
//     uint256 type1,
//     uint256 amount
// ) external payable {
//     // validation owner
//     // validation type exist
//     // validation has cargo before burn
//     // validation is train now cooldown
//     // isPlayer();

//     // uint256 test = trainCargo.totalCargoPublic[id_][type1] + amount;
//     // uint256 test = trainTycoon.collect1(1);
//     // uint256 test2 = trainTycoon.totalCargoPublic(1,2);
//     trainCargo.burnTarget(msg.sender, type1, amount);

//     // trainCargo.totalCargoPublic[id_][type1] + amount;
//     // trainCargo.collect

//     // cargo.burn
//     // train update info
// }

// function combineCargoBatch(uint256 id_, uint256[] memory inputs)
//     external
//     payable
// {
//     // validation owner
//     // validation type exist
//     // validation has cargo before burn
//     // validation is train now cooldown
//     isPlayer();
//     uint256 total = inputs.length;

//     for (uint256 index = 0; index < total; index = index + 2) {
//         uint256 type1 = inputs[index];
//         uint256 amount = inputs[index + 1];
//         this.combineCargo(id_, type1, amount);
//     }

//     // cargo.burn
//     // train update info
// }
