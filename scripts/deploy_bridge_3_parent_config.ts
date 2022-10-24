// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { Wallet } from "ethers";
import { ethers } from "hardhat";




async function main() {



  {
    // const accounts = await ethers.getSigners()
    // const MyContract = await ethers.getContractFactory("MyContract");
    // const myContract = new ethers.Contract(MyContract, MyContract.interface, accounts[0]);

    const contractAddress = "0x...";
    const myContract = await ethers.getContractAt("MyContract", contractAddress);
  }



}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
