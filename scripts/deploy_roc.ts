// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { Wallet } from "ethers";
import { ethers } from "hardhat";




async function main() {



  const walletPrivateKey = new Wallet("4fffe182cd8dee1f7c68e0ec6b61293e87bf7faa28952ce55b58db8406a422a8");

  console.log("address1", walletPrivateKey.address);
  console.log("process.env.GANACHE_URL", process.env.GANACHE_URL);
  console.log("process.env.MATIC_URL", process.env.MATIC_URL);
  
  // true


  const Roc = await ethers.getContractFactory("RocCaller");
  const roc = await Roc.deploy("0xda504d5644afa6adecc29e5cae3c5533c56eb9e9");
  await roc.deployed();
  const rocAddress = roc.address;
  console.log("roc address", rocAddress);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
