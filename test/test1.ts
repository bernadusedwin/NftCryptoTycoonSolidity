import { expect } from "chai";
import { ethers } from "hardhat";



class test10 {
    async execute() {
        await describe("Greeter", async function () {
            it("Should return the new greeting once it's changed", async function () {


                const [addr1, addr2] = await ethers.getSigners();
                const address1 = addr1.address;
                const address2 = addr2.address;

                const Greeter = await ethers.getContractFactory("Greeter");
                const greeter = await Greeter.deploy("Hello, world!");
                await greeter.deployed();

                expect(await greeter.greet()).to.equal("Hello, world!");

                const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

                // wait until the transaction is mined
                await setGreetingTx.wait();

                expect(await greeter.greet()).to.equal("Hola, mundo!");


                const TrainTycoon = await ethers.getContractFactory("TrainTycoon");
                const trainTycoon = await TrainTycoon.deploy();
                const _trainTycoon: any = trainTycoon;
                await trainTycoon.deployed();

                const ERC20 = await ethers.getContractFactory("ERC20");
                const eRC20 = await ERC20.deploy();
                const _eRC20: any = eRC20;
                await eRC20.deployed();
                console.log("eRC20 from", eRC20.deployTransaction.from);
                // console.log("eRC20-1", eRC20.deployTransaction.creates);

                // const fromAddress = eRC20.deployTransaction.creates;
                const ercAddress = _eRC20.deployTransaction.creates;
                const trainAddress = _trainTycoon.deployTransaction.creates;

                console.log("erc address", ercAddress)
                console.log("trainAddress", trainAddress)
                console.log("address1", address1)

                {

                    const trx1 = await trainTycoon.setAddresses(ercAddress, ercAddress,ercAddress);
                    await trx1.wait();
                    // console.log("setAddresses", trx1);
                }

                {
                    const trx1 = await trainTycoon.totalSupply();
                    console.log("totalSupply-1", trx1);
                }

                {

                    // const trx1 = await trainTycoon.mint();
                    const options = { value: ethers.utils.parseEther("0.00001") }
                    const trx1 = await trainTycoon.connect(addr1).freshMint(options);
                    await trx1.wait();
                    // console.log("trx1", trx1);
                }

                {
                    const trx1 = await trainTycoon.totalSupply();
                    console.log("totalSupply-2a", trx1);
                }

                {
                    // const trx1 = await trainTycoon.mint();
                    const options = { value: ethers.utils.parseEther("0.00001") }
                    const trx1 = await trainTycoon.connect(addr1).freshMint(options);
                    await trx1.wait();
                    // console.log("trx1", trx1);
                }

                {
                    const trx1 = await trainTycoon.totalSupply();
                    console.log("totalSupply-2b", trx1);
                }

                {
                    // const trx1 = await trainTycoon.mint();

                    const options = { value: ethers.utils.parseEther("0.00001") }
                    const trx1 = await trainTycoon.connect(addr1).freshMint(options);
                    await trx1.wait();
                    // console.log("trx1", trx1);
                }

                {
                    const trx1 = await trainTycoon.totalSupply();
                    console.log("totalSupply-2c", trx1);
                }

                {
                    const trx1 = await trainTycoon.getTokenSentinel(0);
                    // console.log("sentinels0", trx1);
                }

                {
                    const trx1 = await trainTycoon.getTokenSentinel(1);
                    // console.log("sentinels1", trx1);
                }

                {
                    const trx1 = await trainTycoon.getTokenSentinel(2);
                    // console.log("sentinels2", trx1);
                }


                {
                    const trx1 = await trainTycoon.ownerOf(0);
                    console.log("ownerOf-0", trx1);
                }

                {
                    const trx1 = await trainTycoon.ownerOf(1);
                    console.log("ownerOf-1", trx1);
                }

                {
                    const trx1 = await trainTycoon.ownerOf(2);
                    console.log("ownerOf-2", trx1);
                }


                {
                    const trx1 = await trainTycoon.bankBalances(address1);
                    console.log("bankBalances-0", trx1);
                }



                {
                    const trx1 = await trainTycoon.ownerOf(1);
                    console.log("ownerOf-1 before passive", trx1);
                }

                {
                    const trx1 = await trainTycoon.getTokenSentinel(1);
                    // console.log("getTokenSentinel-1 before passive", trx1);
                }

                {

                    const trx1 = await trainTycoon.connect(addr1).passive([1]);
                    await trx1.wait();
                    // console.log("trx1", trx1);
                }

                {
                    const trx1 = await trainTycoon.ownerOf(1);
                    console.log("ownerOf-1 after passive", trx1);
                }

                {
                    const trx1 = await trainTycoon.getTokenSentinel(1);
                    // console.log("sentinels1 after passive", trx1);
                }

                {

                    const trx1 = await trainTycoon.connect(addr1).returnPassive([1]);
                    await trx1.wait();
                    // console.log("trx1", trx1);
                }
                {
                    const trx1 = await trainTycoon.getTokenSentinel(1);
                    // console.log("sentinels1 after return passive", trx1);
                }

                {
                    const trx1 = await trainTycoon.bankBalances(address1);
                    console.log("bankBalances-1", trx1);
                }


                // {
                //   const trx1 = await trainTycoon.connect(addr1).withdrawTokenBalance();
                //   await trx1.wait();
                //   // console.log("trx1", trx1);
                // }

                {
                    const trx1 = await trainTycoon.balanceOf(address1);
                    console.log("total nft of players", trx1);
                }

                {

                    const trx1 = await eRC20.setMinter(address2, true);
                    await trx1.wait();
                    // console.log("trx1", trx1);
                }
                {

                    const trx1 = await eRC20.isMinter(address2);
                    console.log("is erc address minter", trx1);
                }



                {
                    console.log("before try mint");
                    const trx1 = await eRC20.connect(addr2).mint(address1, 50);
                    await trx1.wait();
                    // console.log("trx1", trx1);
                }

                {
                    const trx1 = await eRC20.balanceOf(address1);
                    console.log("balance address1", trx1);
                }


            });
        });

    }

}

let v = new test10();
export default v;

