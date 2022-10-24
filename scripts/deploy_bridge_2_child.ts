// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { Wallet } from "ethers";
import { ethers } from "hardhat";




async function main() {




  {
    const Roc = await ethers.getContractFactory("FxStateChildTunnel");
    const child = "0xCf73231F28B7331BBe3124B907840A94851f9f11";
    const roc = await Roc.deploy(child);
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
