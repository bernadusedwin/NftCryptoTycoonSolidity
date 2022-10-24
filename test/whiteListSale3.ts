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

                console.log("one")
                const keccak256 = ethers.utils.keccak256;
                console.log("one1a")
                const leaves = ['0x7128617197e555d5c13fB7c96AFb12b0899e9485', '0x4bffe78ea2abce36fa539e478e4e88770bfe278f'].map(v => keccak256(v))
                // const leaves = ['a', 'b', 'c', 'd'].map(v => keccak256(v))
                // const leaves = ['a', 'b', 'c', 'd'].map(v => keccak256(ethers.utils.toUtf8Bytes(v)))
                console.log("one1b")
                const tree = new MerkleTree(leaves, keccak256, { sort: true })
                console.log("two")
                const root = tree.getHexRoot()
                console.log("root",root)
                const leaf = keccak256('0x7128617197e555d5c13fB7c96AFb12b0899e9485')
                const proof = tree.getHexProof(leaf)
                console.log("three")
                
                console.log(await whitelistSale.verify(root, leaf, proof)) // true
                // console.log(await whitelistSale.verify.call(root, leaf, proof)) // true



            });
        });

    }

}

let v = new test10();
export default v;

