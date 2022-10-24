import { expect } from "chai";
import { BigNumber } from "ethers";
import { ethers } from "hardhat";



class test10 {
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


                const ERC20 = await ethers.getContractFactory("ERC20");
                const eRC20 = await ERC20.deploy();
                const _eRC20: any = eRC20;
                await eRC20.deployed();
                console.log("eRC20 from", eRC20.deployTransaction.from);

                const Campaign = await ethers.getContractFactory("ElfCampaignsV3");
                const campaign = await Campaign.deploy();
                const _campaign: any = campaign;
                await campaign.deployed();


                const ercAddress = _eRC20.deployTransaction.creates;
                const trainAddress = _trainTycoon.deployTransaction.creates;
                const campaignAddress = _campaign.deployTransaction.creates;

                console.log("erc address", ercAddress)
                console.log("trainAddress", trainAddress)
                console.log("address1", address1)
                console.log("campaign", campaignAddress)

                {

                    const trx1 = await trainTycoon.setAddresses(ercAddress, campaignAddress, campaignAddress);
                    await trx1.wait();
                }

                {
                    const trx1 = await eRC20.setMinter(address2, true);
                    await trx1.wait();
                    // console.log("trx1", trx1);
                }
                {
                    const trx1 = await eRC20.setMinter(trainAddress, true);
                    await trx1.wait();
                    // console.log("trx1", trx1);
                }


                {
                    console.log("before mint money");
                    const trx1 = await eRC20.connect(addr2).mint(address2, 1000);
                    await trx1.wait();
                }


                {

                    const trx1 = await eRC20.balanceOf(address1);
                    console.log("balance: ", trx1);
                }

                {
                    console.log("before transfer");
                    const trx1 = await eRC20.connect(addr2).transfer(address1, 10);
                    await trx1.wait();
                }


                {

                    const trx1 = await eRC20.balanceOf(address1);
                    console.log("balance: ", trx1);
                }


                // {
                //     const trx1 = await trainTycoon.connect(addr1).mint();
                //     await trx1.wait();
                //     // console.log("trx1", trx1);
                // }

                {

                    const trx1 = await eRC20.balanceOf(address1);
                    console.log("balance: ", trx1);
                }

                {
                    const trx1 = await trainTycoon.totalSupply();
                    console.log("total supply: ", trx1);
                }

                {
                    const trx1 = await trainTycoon.getTokenSentinel(1);
                    console.log("sentinels0", trx1);
                }

                {
                    let balance = await addr1.getBalance();
                    console.log("balance eth", balance);
                }

                {

                    const options = { value: ethers.utils.parseEther("100") }
                    const trx1 = await trainTycoon.connect(addr1).freshMint(options);
                    await trx1.wait();
                }


                {
                    let balance = await addr1.getBalance();
                    console.log("balance eth", balance);
                }



            })
        })


    }
}

let v = new test10();
export default v;


