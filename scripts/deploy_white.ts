// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";




async function main() {


  const WhitelistSale = await ethers.getContractFactory("WhitelistSale");
  // const whitelistSale = await WhitelistSale.deploy("7075152d03a5cd92104887b476862778ec0c87be5c2fa1c0a90f87c49fad6eff");
  const whitelistSale = await WhitelistSale.deploy();
  await whitelistSale.deployed();
  const whitelistSaleAddress = whitelistSale.address;
  console.log("whitelistSaleAddress", whitelistSaleAddress);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
