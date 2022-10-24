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




                const TrainCargo = await ethers.getContractFactory("TrainCargo");
                const trainCargo = await TrainCargo.deploy(address1);
                const _trainCargo: any = trainCargo;
                await trainCargo.deployed();




                const trainCargoAddress = _trainCargo.deployTransaction.creates;


                console.log("trainCargo", trainCargoAddress)



                {
                    console.log("mint");
                    const trx1 = await trainCargo.connect(addr1).mintCargo();
                    await trx1.wait();
                }



                {

                    const trx1 = await trainCargo.balanceOf(address1);
                    console.log("inquiry balance", trx1);
                }

                {

                    const trx1 = await trainCargo.totalSupply();
                    console.log("inquiry totalSupplyGold", trx1);
                }

                {

                    const trx1 = await trainCargo.ownerOf(1);
                    console.log("inquiry owner id 1", trx1);
                    expect(trx1).to.equal(address1);
                }

                {

                    const trx1 = await trainCargo.cargos(1);
                    expect(trx1.level).to.equal(0);
                }

                // update version

                {
                    console.log("updateCargoVersion");
                    const trx1 = await trainCargo.connect(addr1).updateCargoVersion(1);
                    await trx1.wait();
                }
                // await network.provider.send("evm_increaseTime", [3600])

                // await expect(
                //     hardhatToken.connect(addr1).transfer(owner.address, 1)
                //   ).to.be.revertedWith("Not enough tokens");

                await expect(
                    trainCargo.connect(addr2).updateCargoVersion(1)
                ).to.be.revertedWith("NotYourCargo");



                {

                    const trx1 = await trainCargo.cargos(1);
                    expect(trx1.level).to.equal(1);
                }



                {
                    // console.log("stake1 start")
                    const trx1 = await trainCargo.connect(addr1).stake(1);
                    await trx1.wait();
                    // console.log("stake1 end")
                }


                {
                    const trx1 = await trainCargo.connect(addr1).unstake(1);
                    await trx1.wait();
                }


                {

                    const trx1 = await trainCargo.inquiryOwner(address1);
                    console.log("address1 on opensea", trx1);
                }

                {

                    const trx1 = await trainCargo.inquiryOwnerOnCastle(address1);
                    console.log("address1 on castle", trx1);
                }


                {

                    const trx1 = await trainCargo.totalSupply();
                    console.log("totalSupply - A", trx1);

                }
                {
                    console.log("mint cargo - 2");
                    const options = { value: ethers.utils.parseEther("1") }
                    const trx1 = await trainCargo.connect(addr1).mintCargo(options);
                    await trx1.wait();
                }

                {

                    const trx1 = await trainCargo.totalSupply();
                    console.log("totalSupply - B", trx1);
                    expect(trx1).to.equal(2);

                }


                // {

                //     const trx1 = await trainTycoon.ownerOf(4);
                //     console.log("owner 4", trx1);
                //     console.log("address mint 4",address1)
                //     expect(trx1).to.equal(address1);
                // }


            })
        })


    }
}

let v = new test10();
export default v;


