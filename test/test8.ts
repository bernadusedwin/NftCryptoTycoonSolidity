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

//                 const InquiryTrain = await ethers.getContractFactory("InquiryTrain");
//                 const inquiryTrain = await InquiryTrain.deploy();
//                 const _inquiryTrain: any = inquiryTrain;
//                 await inquiryTrain.deployed();


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
//                 const inquiryTrainAddress = _inquiryTrain.deployTransaction.creates;


//                 console.log("erc address", ercAddress)
//                 console.log("trainAddress", trainAddress)
//                 console.log("address1", address1)
//                 console.log("campaign", campaignAddress)
//                 console.log("inquiryTrain", inquiryTrainAddress)


//                 {

//                     const trx1 = await inquiryTrain.setAddresses(trainAddress);
//                     await trx1.wait();
//                 }

//                 // {
//                 //     await expect(
//                 //         inquiryTrain.connect(addr1).setAddresses(trainAddress)
//                 //     ).to.be.revertedWith("not_admin");
//                 // }

//                 {

//                     const trx1 = await trainTycoon.setAddresses(ercAddress, campaignAddress,campaignAddress);
//                     await trx1.wait();
//                 }

//                 {
//                     const trx1 = await campaign.initialize(trainAddress);
//                     await trx1.wait();
//                 }


//                 {
//                     const trx1 = await eRC20.setMinter(address2, true);
//                     await trx1.wait();
//                 }
//                 {
//                     const trx1 = await eRC20.setMinter(trainAddress, true);
//                     await trx1.wait();
//                 }



//                 {
//                     console.log("mint fresh train");
//                     const options = { value: ethers.utils.parseEther("1") }
//                     const trx1 = await trainTycoon.connect(addr1).freshMint(options);
//                     await trx1.wait();
//                 }


//                 {
//                     console.log("inquiryCastlePosition");
//                     const trx1 = await trainTycoon.inquiryCastlePosition(1);
//                     expect(trx1).to.equal(false);
//                 }


//                 {

//                     const trx1 = await trainTycoon.ownerOf(1);
//                     console.log("owner1", trx1);
//                 }

//                 {
//                     const trx1 = await trainTycoon.inquiryOwner(address1);
//                     console.log("output inquiry", trx1);
//                 }

//                 {
//                     console.log("passive");
//                     const trx1 = await trainTycoon.connect(addr1).passive([1]);
//                     await trx1.wait();
//                 }

//                 {
//                     console.log("inquiryCastlePosition 2");
//                     const trx1 = await trainTycoon.inquiryCastlePosition(1);
//                     expect(trx1).to.equal(true);
//                 }

//                 {
//                     const trx1 = await trainTycoon.inquiryOwner(address1);
//                     console.log("output inquiry-2", trx1);
//                 }

//                 {
//                     const trx1 = await trainTycoon.inquiryOwnerOnCastle(address1);
//                     console.log("output inquiry-2 on castle", trx1);
//                 }


//                 {
//                     console.log("return pasive");
//                     const trx1 = await trainTycoon.connect(addr1).returnPassive([1]);
//                     await trx1.wait();
//                 }

//                 {
//                     console.log("inquiryCastlePosition 3");
//                     const trx1 = await trainTycoon.inquiryCastlePosition(1);
//                     expect(trx1).to.equal(true);
//                 }

//                 {
//                     console.log("unstake");
//                     const trx1 = await trainTycoon.connect(addr1).unStake([1]);
//                     await trx1.wait();
//                 }

//                 {
//                     console.log("inquiryCastlePosition 4");
//                     const trx1 = await trainTycoon.inquiryCastlePosition(1);
//                     expect(trx1).to.equal(false);
//                 }

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
//                     const trx1 = await trainTycoon.inquiryOwner(address1);
//                     // console.log("output inquiry-3", trx1);
//                 }

//                 {
//                     const trx1 = await trainTycoon.inquiryOwnerOnCastle(address1);
//                     // console.log("output inquiry-3 on castle", trx1);
//                 }

//                 {

//                     const trx1 = await inquiryTrain.inquiryOwner(address1);
//                     // console.log("output inquiry-3a", trx1);
//                 }

//                 {
//                     const trx1 = await trainTycoon.getTokenSentinel(1);
//                     expect(trx1.weaponTier).to.equal(0);
//                 }

//                 {
//                     const trx1 = await trainTycoon.bankBalances(address1);
//                     console.log("bank balance before send campaign", trx1);
//                     expect(trx1).to.equal(0);
//                 }

//                 {
//                     console.log("active on train 2");
//                     const trx1 = await trainTycoon.connect(addr1).sendCampaign([2], 1, []);
//                     await trx1.wait();
//                 }


//                 {

//                     const trx1 = await trainTycoon.bankBalances(address1);
//                     console.log("bank balance after send campaign", trx1);
//                     expect(trx1).to.equal(BigNumber.from("5000000000000000000"));
//                 }

//                 {
//                     console.log("upgrade on train 3");
//                     const trx1 = await trainTycoon.connect(addr1).upgradeWeapon(3);
//                     await trx1.wait();
//                 }

//                 {

//                     const trx1 = await trainTycoon.bankBalances(address1);
//                     console.log("bank balance after upgrade train 3", trx1);
//                     expect(trx1).to.equal(BigNumber.from("3500000000000000000"));
//                 }

//                 {
//                     console.log("active on train 3");
//                     const trx1 = await trainTycoon.connect(addr1).sendCampaign([3], 2, []);
//                     await trx1.wait();
//                 }


//                 {

//                     const trx1 = await trainTycoon.bankBalances(address1);
//                     console.log("bank balance after send campaign", trx1);
//                     expect(trx1).to.equal(BigNumber.from("33500000000000000000"));
//                 }

//                 {

//                     const trx1 = await trainTycoon.tokenURI(1);
//                     console.log("inquiry token uri 1", trx1);

//                 }



                

//                 {

//                     const trx1 = await trainTycoon.totalSupply();
//                     console.log("totalSupply", trx1);
                    
//                 }
//                 {
//                     console.log("mint fresh train - 4");
//                     const options = { value: ethers.utils.parseEther("1") }
//                     const trx1 = await trainTycoon.connect(addr1).freshMint(options);
//                     await trx1.wait();
//                 }


//                 {

//                     const trx1 = await trainTycoon.ownerOf(4);
//                     console.log("owner 4", trx1);
//                     console.log("address mint 4",address1)
//                     expect(trx1).to.equal(address1);
//                 }


//                 {
//                     console.log("mint fresh train - 5");
//                     const options = { value: ethers.utils.parseEther("1") }
//                     const trx1 = await trainTycoon.connect(addr1).freshMint(options);
//                     await trx1.wait();
//                 }


//                 {

//                     const trx1 = await trainTycoon.ownerOf(5);
//                     expect(trx1).to.equal(address1);
//                 }


//                 {
//                     console.log("upgrade  train - 5");
//                     const options = { value: ethers.utils.parseEther("1") }
//                     const trx1 = await trainTycoon.connect(addr1).upgradeWeapon(5);
//                     await trx1.wait();
//                 }


//                 {

//                     const trx1 = await trainTycoon.ownerOf(5);
//                     expect(trx1).to.equal(trainAddress);
//                 }



//             })
//         })


//     }
// }

// let v = new test10();
// export default v;


