// import { expect } from "chai";
// import { BigNumber } from "ethers";
// import { ethers } from "hardhat";

// // console.log("total supply");
// // console.log("balance player");
// // console.log("stacking");
// // console.log("unstacking");


// // console.log("mint");
// // console.log("check balance");
// // console.log("combine");
// // console.log("check balance");
// // console.log("check info train");
// // console.log("split");
// // console.log("check balance");
// // console.log("check info train");


// class test10 {
//     async execute() {
//         await describe("Greeter", async function () {
//             it("Should return the new greeting once it's changed", async function () {
//                 const [addr1, addr2] = await ethers.getSigners();
//                 const address1 = addr1.address;
//                 const address2 = addr2.address;


//                 const TrainCargoNew = await ethers.getContractFactory("TrainCargoNew");
//                 const trainCargoNew = await TrainCargoNew.deploy();
//                 const _trainCargoNew: any = TrainCargoNew;
//                 await trainCargoNew.deployed();


//                 // {

//                 //     const trx1 = await trainCargoNew.inquiry(address2, 2);
//                 //     console.log("result 1", trx1);
//                 // }



//                 {
//                     console.log("initialize");
//                     // const options = { value: ethers.utils.parseEther("1") }
//                     const trx1 = await trainCargoNew.initialize(0);
//                     await trx1.wait();
//                 }





//                 {
//                     console.log("mint player1");
//                     // const options = { value: ethers.utils.parseEther("1") }
//                     const trx1 = await trainCargoNew.connect(addr1).mintFragment(1,1);
//                     await trx1.wait();
//                 }

//                 {
//                     console.log("mint player2");
//                     // const options = { value: ethers.utils.parseEther("1") }
//                     const trx1 = await trainCargoNew.connect(addr2).mintFragment(1,1);
//                     await trx1.wait();
//                 }





//                 {

//                     const trx1 = await trainCargoNew.balanceOf(address1, 1);
//                     console.log("result 1", trx1);
//                 }

//                 {

//                     const trx1 = await trainCargoNew.balanceOf(address2, 1);
//                     console.log("result 2", trx1);
//                 }

//                 {

//                     const trx1 = await trainCargoNew.getRelicMintCounts(1);
//                     console.log("result getRelicMintCounts", trx1);
//                 }



//                 {
//                     console.log("stakeRelic player1");
//                     // const options = { value: ethers.utils.parseEther("1") }
//                     const trx1 = await trainCargoNew.connect(addr1).stakeRelic(1, 1);
//                     await trx1.wait();
//                 }


//                 {

//                     const trx1 = await trainCargoNew.balanceOf(address1, 1);
//                     console.log("result 1", trx1);
//                 }




//                 {
//                     console.log("unstakeRelic player1");
//                     // const options = { value: ethers.utils.parseEther("1") }
//                     const trx1 = await trainCargoNew.connect(addr1).unstakeRelic(1, 1);
//                     await trx1.wait();
//                 }




//                 {

//                     const trx1 = await trainCargoNew.balanceOf(address1, 1);
//                     console.log("result 1", trx1);
//                 }


//                 {
//                     console.log("burn target");
//                     // const options = { value: ethers.utils.parseEther("1") }
//                     const trx1 = await trainCargoNew.burnTarget(address1, 1, 1);
//                     await trx1.wait();
//                 }


//                 {

//                     const trx1 = await trainCargoNew.balanceOf(address1, 1);
//                     console.log("result 1", trx1);
//                 }






//             })
//         })


//     }
// }

// let v = new test10();
// export default v;


