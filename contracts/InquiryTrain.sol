//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
// import "./DataStructure.sol";
// import "./erc721.sol";
// import "./interfaces.sol";
// import "./campaign.sol";
import "./TrainTycoon.sol";

contract InquiryTrain {
    TrainTycoon trainTycoon;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function setAddresses(address _trainTycoon) public {
        onlyOwner();
        trainTycoon = TrainTycoon(_trainTycoon);
    }

    function inquiryOwner(address address1)
        public
        view
        returns (uint256[] memory)
    {
        uint256 counter = 0;
        uint256[] memory output = new uint256[](trainTycoon.totalSupply());

        for (uint256 index = 1; index <= trainTycoon.totalSupply(); index++) {
            // console.log("ownerof", trainTycoon.ownerOf[index]);
            if (trainTycoon.ownerOf(index) == address1) {
                output[counter] = index;
                counter++;
            }
        }
        return output;
    }

    function onlyOwner() internal view {
        require(admin == msg.sender, "not_admin");
    }
}
