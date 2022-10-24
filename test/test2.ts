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
//                 const trainAddress = _trainTycoon.deployTransaction.creates;
//                 const campaignAddress = _campaign.deployTransaction.creates;

//                 console.log("erc address", ercAddress)
//                 console.log("trainAddress", trainAddress)
//                 console.log("address1", address1)
//                 console.log("campaign", campaignAddress)

//                 {

//                     const trx1 = await trainTycoon.setAddresses(ercAddress, campaignAddress,campaignAddress);
//                     await trx1.wait();
//                     // console.log("setAddresses", trx1);
//                 }

//                 {
//                     const options = { value: ethers.utils.parseEther("0.00001") }
//                     const trx1 = await trainTycoon.connect(addr1).freshMint(options);
//                     await trx1.wait();
//                     // console.log("trx1", trx1);
//                 }

//                 {
//                     // const trx1 = await trainTycoon.mint();
//                     const options = { value: ethers.utils.parseEther("0.00001") }
//                     const trx1 = await trainTycoon.connect(addr1).freshMint(options);
//                     await trx1.wait();
//                     // console.log("trx1", trx1);
//                 }


//                 {
//                     const trx1 = await trainTycoon.totalSupply();
//                     console.log("totalSupply-2a", trx1);
//                 }


//                 {
//                     const trx1 = await trainTycoon.getTokenSentinel(1);
//                     // console.log("sentinels1", trx1);
//                 }

//                 {
//                     const trx1 = await trainTycoon.bankBalances(address1);
//                     console.log("bankBalances-0", trx1);
//                 }




//                 {
//                     const trx1 = await campaign.initialize(trainAddress);
//                     await trx1.wait();
//                     // console.log("setAddresses", trx1);
//                 }

//                 {

//                     const trx1 = await trainTycoon.connect(addr1).sendCampaign([1], 1, []);
//                     await trx1.wait();
//                     // console.log("trx1", trx1);
//                 }


//                 {
//                     const trx1 = await trainTycoon.bankBalances(address1);
//                     console.log("bankBalances-0", trx1);
//                     expect(trx1).to.equal(BigNumber.from("10000000000000000000"));
//                 }


//                 {
//                     const trx1 = await trainTycoon.getCurrrentBlockTimeStamp();
//                     console.log("getCurrrentBlockTimeStamp", trx1);
//                 }

                
//                 {
//                     const trx1 = await trainTycoon.getTokenSentinel(1);
//                     console.log("sentinels1 timestamp", trx1.timestamp);
//                 }

//                 {
//                     const trx1 = await trainTycoon.getTokenSentinel(1);
//                     // console.log("sentinels1", trx1);
//                 }

//                 // {

//                 //     const trx1 = await trainTycoon.connect(addr1).sendCampaign([1], 1, 1, false, false, false);
//                 //     await trx1.wait();
//                 //     // console.log("trx1", trx1);
//                 // }

//                 // {
//                 //     const trx1 = await trainTycoon.bankBalances(address1);
//                 //     console.log("bankBalances-0", trx1);
//                 //     expect(trx1).to.equal(BigNumber.from("20000000000000000000"));
//                 // }

//                 // mint
//                 // inquriy before
//                 // active stacking
//                 // check hasil
//             })
//         })


//     }
// }

// let v = new test10();
// export default v;


