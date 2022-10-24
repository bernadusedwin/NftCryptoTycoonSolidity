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


                const EtherStore = await ethers.getContractFactory("EtherStore");
                const etherStore = await EtherStore.deploy();
                await etherStore.deployed();

                // let etherStoreAddress = etherStore.deployTransaction.from;
                const etherStore2: any = etherStore;
                const etherStoreAddress = etherStore2.deployTransaction.creates;
                console.log("etherStoreAddress address", etherStoreAddress);

                const Attack = await ethers.getContractFactory("Attack");
                const attack = await Attack.deploy(etherStoreAddress);
                await attack.deployed();

                {
                    const bal1 = await addr1.getBalance();
                    const ethValue = ethers.utils.formatEther(bal1);
                    console.log("self balance", ethValue);
                }

                {
                    console.log("deposit");
                    const options = { value: ethers.utils.parseEther("1") }
                    const trx1 = await etherStore.connect(addr1).deposit(options);
                    await trx1.wait();
                }

                {
                    const trx1 = await etherStore.connect(addr1).getBalance();
                    const ethValue = ethers.utils.formatEther(trx1);
                    console.log("account balance-1", ethValue);
                }
                {
                    const bal1 = await addr1.getBalance();
                    const ethValue = ethers.utils.formatEther(bal1);
                    console.log("self balance", ethValue);
                }


                {
                    console.log("try attack");
                    const options = { value: ethers.utils.parseEther("1") }
                    const trx1 = await attack.connect(addr1).attack(options);
                    await trx1.wait();
                }


                {

                    const trx1 = await etherStore.connect(addr1).getBalance();
                    const ethValue = ethers.utils.formatEther(trx1);
                    console.log("account balance-2", ethValue);
                }

                {
                    const bal1 = await addr1.getBalance();
                    const ethValue = ethers.utils.formatEther(bal1);
                    console.log("self balance", ethValue);
                }


            })
        })


    }
}

let v = new test17();
export default v;


