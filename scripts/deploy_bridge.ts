// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { Wallet } from "ethers";
import { ethers } from "hardhat";




async function main() {




  {
    const Roc = await ethers.getContractFactory("FxERC20RootTunnel");
    const addr1 = "0xda504d5644afa6adecc29e5cae3c5533c56eb9e9";
    const roc = await Roc.deploy(addr1,addr1,addr1);
    await roc.deployed();
    const rocAddress = roc.address;
    console.log("roc address", rocAddress);
  }

  {
    const Roc = await ethers.getContractFactory("FxERC20ChildTunnel");
    const addr1 = "0xda504d5644afa6adecc29e5cae3c5533c56eb9e9";
    const roc = await Roc.deploy(addr1,addr1);
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
