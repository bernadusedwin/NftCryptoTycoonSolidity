// import { expect } from "chai";
// import { BigNumber } from "ethers";
// import { ethers } from "hardhat";



// class test10 {
//     async execute() {
//         await describe("Greeter", async function () {
//             it("Should return the new greeting once it's changed", async function () {
//                 const [addr1, addr2] = await ethers.getSigners();
//                 const address1 = addr1.address;
//                 const address2 = addr2.address;


//                 const TrainTycoon = await ethers.getContractFactory("TrainTycoon");
//                 const trainTycoon = await TrainTycoon.deploy();
//                 const _trainTycoon: any = trainTycoon;
//                 await trainTycoon.deployed();


//                 const trainAddress = _trainTycoon.deployTransaction.creates;

//                 const TrainCargo = await ethers.getContractFactory("TrainCargo");
//                 const trainCargo = await TrainCargo.deploy(trainAddress);
//                 const _trainCargo: any = trainCargo;
//                 await trainCargo.deployed();


//                 const ERC20 = await ethers.getContractFactory("ERC20");
//                 const eRC20 = await ERC20.deploy();
//                 const _eRC20: any = eRC20;
//                 await eRC20.deployed();
//                 console.log("eRC20 from", eRC20.deployTransaction.from);

//                 const Campaign = await ethers.getContractFactory("ElfCampaignsV3");
//                 const campaign = await Campaign.deploy();
//                 const _campaign: any = campaign;
//                 await campaign.deployed();

//                 const ercAddress = _eRC20.deployTransaction.creates;

//                 const campaignAddress = _campaign.deployTransaction.creates;
//                 // const inquiryTrainAddress = _inquiryTrain.deployTransaction.creates;
//                 const trainCargoAddress = _trainCargo.deployTransaction.creates;


//                 {
//                     const trx1 = await trainTycoon.setAddresses(ercAddress, campaignAddress, trainCargoAddress);
//                     await trx1.wait();
//                 }

//                 {
//                     const trx1 = await campaign.initialize(trainAddress);
//                     await trx1.wait();
//                 }

//                 {
//                     const trx1 = await trainCargo.initialize(trainAddress);
//                     await trx1.wait();
//                 }


//                 console.log("trainCargo", trainCargoAddress)
//                 console.log("address1", address1)
//                 console.log("trainAddress", trainAddress)



//                 {
//                     console.log("mint fresh train");
//                     const options = { value: ethers.utils.parseEther("1") }
//                     const trx1 = await trainTycoon.connect(addr1).freshMint(options);
//                     await trx1.wait();
//                 }


//                 {
//                     console.log("mint fresh train");
//                     const options = { value: ethers.utils.parseEther("1") }
//                     const trx1 = await trainTycoon.connect(addr1).freshMint(options);
//                     await trx1.wait();
//                 }


//                 {
//                     console.log("mint cargo");
//                     const trx1 = await trainCargo.connect(addr1).mintCargo();
//                     await trx1.wait();
//                 }

//                 {
//                     console.log("mint cargo");
//                     const trx1 = await trainCargo.connect(addr1).mintCargo();
//                     await trx1.wait();
//                 }

//                 {
//                     console.log("mint cargo");
//                     const trx1 = await trainCargo.connect(addr2).mintCargo();
//                     await trx1.wait();
//                 }
//                 {
//                     console.log("mint cargo");
//                     const trx1 = await trainCargo.connect(addr1).mintCargo();
//                     await trx1.wait();
//                 }


//                 {
//                     console.log("cargo1 time");
//                     const trx1 = await trainCargo.cargos(1);
//                     console.log("cargo1 time", trx1.timestamp);
//                 }

//                 {
//                     await expect(
//                         trainTycoon.connect(addr1).sendCampaign([1], 1, [1, 2, 3])
//                     ).to.be.revertedWith("NotYourCargo");
//                 }

//                 {
//                     console.log("active on train 1");
//                     const trx1 = await trainTycoon.connect(addr1).sendCampaign([1], 1, [1, 2]);
//                     // const trx1 = await trainTycoon.connect(addr1).sendCampaign([1], 1, [1]);
//                     await trx1.wait();
//                 }



//                 {
//                     console.log("cargo1 time");
//                     const trx1 = await trainCargo.cargos(1);
//                     console.log("cargo1 time", trx1.timestamp);
//                 }

//                 {
//                     await expect(
//                         trainTycoon.connect(addr1).sendCampaign([2], 1, [3])
//                     ).to.be.revertedWith("NotYourCargo");
//                 }

//                 {
//                     console.log("active on train 2");
//                     const trx1 = await trainTycoon.connect(addr1).sendCampaign([2], 1, [4]);
//                     await trx1.wait();
//                 }





//             })
//         })


//     }
// }

// let v = new test10();
// export default v;


