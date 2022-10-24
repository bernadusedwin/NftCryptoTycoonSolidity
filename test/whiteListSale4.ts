import { expect } from "chai";
import { ethers } from "hardhat";
import { MerkleTree } from "merkletreejs";
// import { keccak256 } from "ethers.utils";

// const { expect, use } = require('chai')
// const { ethers } = require('hardhat')
// const { MerkleTree } = require('merkletreejs')
// const { keccak256 } = ethers.utils

class test10 {
    async execute() {
        await describe("Greeter", async function () {
            it("Should return the new greeting once it's changed", async function () {

                const WhitelistSale = await ethers.getContractFactory("WhitelistSale");
                const whitelistSale = await WhitelistSale.deploy();
                await whitelistSale.deployed();

                const keccak256 = ethers.utils.keccak256;

                const leaves = ['0x7128617197e555d5c13fB7c96AFb12b0899e9485', '0x4bffe78ea2abce36fa539e478e4e88770bfe278f'].map(v => keccak256(v))
                // const leaves = ['0x4bffe78ea2abce36fa539e478e4e88770bfe278f'].map(v => keccak256(v))

                const sender = "0x7128617197e555d5c13fB7c96AFb12b0899e9485";
                

                const tree = new MerkleTree(leaves, keccak256, { sort: true })
                const leaf = keccak256(sender)
                const proof = tree.getHexProof(leaf)
                const root = tree.getHexRoot()

                // {
                //     const trx1 = await whitelistSale.mint3(proof, sender, root);
                //     await trx1.wait();
                // }

                {
                    const trx1 = await whitelistSale.setAddress(root);
                    await trx1.wait();
                }

                {
                    const trx1 = await whitelistSale.mint4(proof, sender);
                    await trx1.wait();
                }


            });
        });

    }

}

let v = new test10();
export default v;

