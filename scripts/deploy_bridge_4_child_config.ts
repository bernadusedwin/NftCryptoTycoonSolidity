// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { Wallet } from "ethers";
import { ethers } from "hardhat";




async function main() {




  const contractAddress = "0x535ff759ca042fBB1BD1c8B99AAC5452c4189302";
  
  const myContract = await ethers.getContractAt("FxStateChildTunnel", contractAddress);
  const trx1 = await myContract.sendMessageToRoot("0x1234");
  console.log("result", trx1);


  // const contractAddress = "0xa0060Cc969d760c3FA85844676fB654Bba693C22";

  
  // const myContract = await ethers.getContractAt("FxStateChildTunnel", contractAddress);

  // // const target = "0xc4432e7dab6c1b43f4dc38ad2a594ca448aec9af";
  // // const trx1 = await myContract.setFxRootTunnel(target);
  // // console.log("result", trx1);

  // // const trx1 = await myContract.fxRootTunnel();
  // // // 0xC4432E7DAB6c1B43F4Dc38AD2a594CA448aEc9Af
  // // console.log("result", trx1);

  
  
  // const trx1 = await myContract.sendMessageToRoot("0x1234");
  // console.log("result", trx1);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
