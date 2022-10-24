// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { Wallet } from "ethers";
import { ethers } from "hardhat";




async function main() {




  {
    // https://docs.polygon.technology/docs/develop/l1-l2-communication/state-transfer
    const Roc = await ethers.getContractFactory("ERC20Item");
    const roc = await Roc.deploy();
    await roc.deployed();
    const rocAddress = roc.address;
    console.log("roc address", rocAddress);
  }

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
