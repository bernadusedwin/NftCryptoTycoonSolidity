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
    const Roc = await ethers.getContractFactory("FxStateRootTunnel");
    const checkPoint = "0x2890bA17EfE978480615e330ecB65333b880928e";
    const root = "0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA";
    const roc = await Roc.deploy(checkPoint,root);
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
