// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

// const ROPSTEN_PRIVATE_KEY = "YOUR ROPSTEN PRIVATE KEY";

// module.exports = {
//   solidity: "0.7.3",
//   networks: {
//     ropsten: {
//       url: `https://rinkeby.infura.io/v3/605cc3bbb6b2412fa0399ee07e8bbb49`,
//       accounts: [`${ROPSTEN_PRIVATE_KEY}`]
//     }
//   }
// };

module.exports = {
  defaultNetwork: "ganache",
  networks: {
    ganache: {
      gasLimit: 6000000000,
      defaultBalanceEther: 10,
    },
  },
};

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy

  // const Greeter = await ethers.getContractFactory("Greeter");
  // const greeter = await Greeter.deploy("Hello, Hardhat!");

  // await greeter.deployed();

  // console.log("Greeter deployed to:", greeter.address);


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

  // console.log("eRC20 from", eRC20.deployTransaction.from);
  // console.log("eRC20-1", eRC20.deployTransaction.creates);

  // const fromAddress = eRC20.deployTransaction.creates;



  {
    const trx1 = await trainTycoon.setAddresses(ercAddress);
    await trx1.wait();
    // console.log("setAddresses", trx1);
  }

  {
    const trx1 = await eRC20.setMinter(trainTycoonAddress,true);
    await trx1.wait();
    // console.log("setAddresses", trx1);
  }

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
