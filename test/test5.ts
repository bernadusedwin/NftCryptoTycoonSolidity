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
//                 }

//                 {
//                     const trx1 = await campaign.initialize(trainAddress);
//                     await trx1.wait();
//                     // console.log("setAddresses", trx1);
//                 }


//                 {
//                     const trx1 = await eRC20.setMinter(address2, true);
//                     await trx1.wait();
//                     // console.log("trx1", trx1);
//                 }
//                 {
//                     const trx1 = await eRC20.setMinter(trainAddress, true);
//                     await trx1.wait();
//                     // console.log("trx1", trx1);
//                 }



//                 {
//                     console.log("mint fresh train");
//                     const options = { value: ethers.utils.parseEther("1") }
//                     const trx1 = await trainTycoon.connect(addr1).freshMint(options);
//                     await trx1.wait();
//                 }

//                 {

//                     const trx1 = await trainTycoon.connect(addr1).bankBalances(address1);
//                     console.log("bank balance before campaign", trx1);

//                 }

//                 {
//                     console.log("active on train 1");
//                     const trx1 = await trainTycoon.connect(addr1).sendCampaign([1], 1, []);
//                     await trx1.wait();
//                 }

//                 {

//                     const trx1 = await trainTycoon.connect(addr1).bankBalances(address1);
//                     console.log("bank balance after campaign", trx1);

//                 }
//                 {
//                     const trx1 = await trainTycoon.getTokenSentinel(1);
//                     // console.log("sentinels0", trx1);
//                     expect(trx1.action).to.equal(2);

//                 }

//                 {
//                     const trx1 = await trainTycoon.totalSupply();
//                     console.log("total supply: ", trx1);
//                 }


//                 {
//                     console.log("mint train");
//                     const trx1 = await trainTycoon.connect(addr1).mintWithoutSickness();
//                     await trx1.wait();

//                 }

//                 {

//                     const trx1 = await eRC20.balanceOf(address1);
//                     console.log("balance after mint train: ", trx1);
//                 }

//                 {

//                     const trx1 = await trainTycoon.connect(addr1).bankBalances(address1);
//                     console.log("bank balance after mint train", trx1);

//                 }

//                 {
//                     const trx1 = await trainTycoon.totalSupply();
//                     console.log("total supply: ", trx1);
//                 }

//                 {
//                     const trx1 = await trainTycoon.getTokenSentinel(2);
//                     expect(trx1.action).to.equal(1);
//                     // console.log("sentinels0", trx1);
//                 }

//                 // {
//                 //     let balance = await addr1.getBalance();
//                 //     console.log("balance eth", balance);
//                 // }

//                 // {

//                 //     const options = { value: ethers.utils.parseEther("100") }
//                 //     const trx1 = await trainTycoon.connect(addr1).freshMint(options);
//                 //     await trx1.wait();
//                 // }


//                 // {
//                 //     let balance = await addr1.getBalance();
//                 //     console.log("balance eth", balance);
//                 // }



//                 {
//                     console.log("do passive");
//                     const trx1 = await trainTycoon.connect(addr1).passive([2]);
//                     await trx1.wait();


//                 }

//                 {
//                     const trx1 = await trainTycoon.getTokenSentinel(2);
//                     expect(trx1.action).to.equal(3);
//                     // console.log("sentinels0", trx1);
//                 }

//                 {

//                     console.log("do return passive");
//                     const trx1 = await trainTycoon.connect(addr1).returnPassive([2]);
//                     await trx1.wait();

//                 }


//                 {
//                     const trx1 = await trainTycoon.getTokenSentinel(2);
//                     expect(trx1.action).to.equal(4);
//                     // console.log("sentinels0", trx1);
//                 }

//             })
//         })


//     }
// }

// let v = new test10();
// export default v;


