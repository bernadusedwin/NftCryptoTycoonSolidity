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

  const TrainTycoon = await ethers.getContractFactory("TrainTycoon");
  const trainTycoon = await TrainTycoon.deploy();
  await trainTycoon.deployed();
  const trainTycoonAddress = trainTycoon.address;
  console.log("trainTycoon deployed to:", trainTycoonAddress);

  const ERC20 = await ethers.getContractFactory("ERC20");
  const eRC20: any = await ERC20.deploy();
  await eRC20.deployed();
  const ercAddress = eRC20.address;
  console.log("eRC20 deployed to:", ercAddress);

  const Campaign = await ethers.getContractFactory("ElfCampaignsV3");
  const campaign: any = await Campaign.deploy();
  await campaign.deployed();
  const campaignAddress = campaign.address;
  console.log("campaign deployed to:", campaignAddress);

  const TrainCargo = await ethers.getContractFactory("TrainCargoNew");
  const trainCargo: any = await TrainCargo.deploy();
  await trainCargo.deployed();
  const trainCargoAddress = trainCargo.address;
  console.log("trainCargo deployed to:", trainCargoAddress);

  const CombineManager = await ethers.getContractFactory("CombineManager");
  const combineManager = await CombineManager.deploy();
  const _combineManager: any = combineManager;
  await combineManager.deployed();
  const combineManagerAddress = _combineManager.address;
  console.log("combineManager deployed to:", combineManagerAddress);


  {

    const trx1 = await combineManager.setAddresses(trainTycoonAddress, trainCargoAddress);
    await trx1.wait();
  }

  {
    const trx1 = await eRC20.setMinter(trainTycoonAddress, true);
    await trx1.wait();
    // console.log("setAddresses", trx1);
  }



  {
    const trx1 = await campaign.initialize(trainTycoonAddress);
    await trx1.wait();

  }

  {
    const trx1 = await trainCargo.initialize(0);
    await trx1.wait();
  }

  {
    // console.log("before set address");
    const trx1 = await trainTycoon.setAddresses(ercAddress, campaignAddress, trainCargoAddress);
    await trx1.wait();
    // console.log("after set address");
  }

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
