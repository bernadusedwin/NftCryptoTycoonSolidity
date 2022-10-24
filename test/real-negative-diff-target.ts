import { expect } from "chai";
import { BigNumber } from "ethers";
import { ethers } from "hardhat";



class test17 {
    async execute() {
        await describe("Greeter", async function () {
            it("Should return the new greeting once it's changed", async function () {
                const [addr1, addr2] = await ethers.getSigners();
                const address1 = addr1.address;
                const address2 = addr2.address;




                const TrainTycoon = await ethers.getContractFactory("TrainTycoon");
                const trainTycoon = await TrainTycoon.deploy();
                const _trainTycoon: any = trainTycoon;
                await trainTycoon.deployed();

                const InquiryTrain = await ethers.getContractFactory("InquiryTrain");
                const inquiryTrain = await InquiryTrain.deploy();
                const _inquiryTrain: any = inquiryTrain;
                await inquiryTrain.deployed();


                const ERC20 = await ethers.getContractFactory("ERC20");
                const eRC20 = await ERC20.deploy();
                const _eRC20: any = eRC20;
                await eRC20.deployed();
                console.log("eRC20 from", eRC20.deployTransaction.from);

                const Campaign = await ethers.getContractFactory("ElfCampaignsV3");
                const campaign = await Campaign.deploy();
                const _campaign: any = campaign;
                await campaign.deployed();

                const TrainCargoNew = await ethers.getContractFactory("TrainCargoNew");
                const trainCargoNew = await TrainCargoNew.deploy();
                const _trainCargoNew: any = trainCargoNew;
                await trainCargoNew.deployed();

                const CombineManager = await ethers.getContractFactory("CombineManager");
                const combineManager = await CombineManager.deploy();
                const _combineManager: any = combineManager;
                await combineManager.deployed();



                const ercAddress = _eRC20.deployTransaction.creates;
                const trainAddress = _trainTycoon.deployTransaction.creates;
                const campaignAddress = _campaign.deployTransaction.creates;
                const inquiryTrainAddress = _inquiryTrain.deployTransaction.creates;
                const trainCargoNewAddress = _trainCargoNew.deployTransaction.creates;
                const combineManagerAddress = _combineManager.deployTransaction.creates;


                console.log("erc address", ercAddress)
                console.log("trainAddress", trainAddress)
                console.log("address1", address1)
                console.log("campaign", campaignAddress)
                console.log("inquiryTrain", inquiryTrainAddress)


                {

                    const trx1 = await combineManager.setAddresses(trainAddress, trainCargoNewAddress);
                    await trx1.wait();
                }



                {

                    const trx1 = await inquiryTrain.setAddresses(trainAddress);
                    await trx1.wait();
                }



                {

                    const trx1 = await trainTycoon.setAddresses(ercAddress, campaignAddress, trainCargoNewAddress);
                    await trx1.wait();
                }

                {
                    const trx1 = await campaign.initialize(trainAddress);
                    await trx1.wait();
                }


                {
                    const trx1 = await eRC20.setMinter(address2, true);
                    await trx1.wait();
                }
                {
                    const trx1 = await eRC20.setMinter(trainAddress, true);
                    await trx1.wait();
                }


                {
                    console.log("initialize");
                    // const options = { value: ethers.utils.parseEther("1") }
                    const trx1 = await trainCargoNew.initialize(0);
                    await trx1.wait();
                }

                {
                    const trx1 = await trainCargoNew.setTrainManager(trainAddress);
                    await trx1.wait();
                }

                {
                    const trx1 = await trainCargoNew.setCombineManager(combineManagerAddress);
                    await trx1.wait();
                }

                {

                    const trx1 = await trainTycoon.setCombineManager(combineManagerAddress);
                    await trx1.wait();
                }



                // start

                {
                    console.log("mint fresh train");
                    const options = { value: ethers.utils.parseEther("1") }
                    const trx1 = await trainTycoon.connect(addr1).freshMint(options);
                    await trx1.wait();
                    // train 1
                }


                // mint train
                {
                    console.log("mint fresh train");
                    const options = { value: ethers.utils.parseEther("1") }
                    const trx1 = await trainTycoon.connect(addr1).freshMint(options);
                    await trx1.wait();
                    // train 2
                }



                {
                    console.log("mint fresh train");
                    const options = { value: ethers.utils.parseEther("1") }
                    const trx1 = await trainTycoon.connect(addr1).freshMint(options);
                    await trx1.wait();
                    // train 3
                }




                // campaign
                {
                    console.log("start campaign");

                    {
                        await expect(
                            trainTycoon.connect(addr2).sendCampaign([1], 3)
                        ).to.be.revertedWith("NotYourElf");
                    }

                    const trx1 = await trainTycoon.connect(addr1).sendCampaign([1], 3);
                    await trx1.wait();

                }

                // upgrade

                {
                    console.log("upgrade campaign");

                    {
                        await expect(
                            trainTycoon.connect(addr2).upgradeWeapon(2)
                        ).to.be.revertedWith("NotYourElf");
                    }

                    const trx1 = await trainTycoon.connect(addr1).upgradeWeapon(2);
                    await trx1.wait();

                }



                // mint container

                {
                    console.log("mintCargo");
                    const trx1 = await trainTycoon.connect(addr1).mintCargo(2, 1);
                    await trx1.wait();

                }

                // combine

                {
                    console.log("combine");

                    // {
                    //     await expect(
                    //         trainTycoon.connect(addr2).upgradeWeapon(2)
                    //     ).to.be.revertedWith("NotYourElf");
                    // }

                    const trx1 = await combineManager.connect(addr1).combineCargoBatch(1, [2, 1]);
                    await trx1.wait();

                }

                // unstake train2


                {
                    console.log("unstake");

                    {
                        await expect(
                            trainTycoon.connect(addr2).unStake([2])
                        ).to.be.revertedWith("NotYourElf");
                    }

                    const trx1 = await trainTycoon.connect(addr1).unStake([2]);
                    await trx1.wait();

                }




            })
        })


    }
}

let v = new test17();
export default v;


