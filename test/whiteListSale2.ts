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


                


                const v = new Array<string>();
                v.push("0x7128617197e555d5c13fB7c96AFb12b0899e9485");
                v.push("0x4bffe78ea2abce36fa539e478e4e88770bfe278f");
                v.push("0xedbf44997e7dcbe05367bcd471553bd277718a74");
                v.push("0x7201Cb17A0f51dd2b5A7C651198D57675400801d");


                // ethers.utils.keccak256(ethers.utils.toUtf8Bytes("0x65794a786333426859325666615751694f694a706333426a4d7a513154446c33636c463464565a7a59303154596a5635544646565a4656795458525953434973496d466b5a4849694f6949776544517a596a566d4d54466c4d3252684f4745334d6a517a5a5451325a446c6c4e47497a4e446b355a6a56694f57466c595455314f5455694c434a7862476c6958326c6b496a6f6961577870596a4e42546d39575533704f51544e514e6e513359574a4d556a59356147383157564251576c556966513d3d"))
                // "0x194ad042ecb4cc870c7c5574dc0d92dac9f3865b5a435a8c3df733069a71ef80"

                // const t0 = ethers.utils.toUtf8Bytes("0x7128617197e555d5c13fB7c96AFb12b0899e9485");
                // const t1 = ethers.utils.keccak256(t0);
                // console.log("t1",t1)

                // const t2 = ethers.utils.keccak256("0x7128617197e555d5c13fB7c96AFb12b0899e9485");
                // console.log("t2",t2)

                const whitelisted = v;
                const leaves = whitelisted.map(account => ethers.utils.keccak256(ethers.utils.toUtf8Bytes(account)))
                console.log("leaves sha256", leaves)
                const keccak256 = ethers.utils.keccak256;
                const tree = new MerkleTree(leaves, keccak256, { sort: true })
                // const tree = new MerkleTree(leaves, keccak256, { sort: false })
                const merkleRoot = tree.getHexRoot()

                const merkleProof = tree.getHexProof(keccak256(ethers.utils.toUtf8Bytes("0x7201Cb17A0f51dd2b5A7C651198D57675400801d")))

                console.log("merkleProof", merkleProof);
                console.log("merkleRoot", merkleRoot);



                
                {
                    let merkleRoot2 = ethers.utils.arrayify(merkleRoot);
                    const trx1 = await whitelistSale.setAddress(merkleRoot2);
                    await trx1.wait();
                }

                {
                    const trx1 = await whitelistSale.mint2(merkleProof);
                    await trx1.wait();
                }


                // console.log("test2a");
                // // let test2 = ethers.utils.arrayify("0x5b1129e57a52317081a50380437b3ab7ee2448009240c0fbb32f262ec45860cd");
                // let test2 = ethers.utils.arrayify("0x43cbe0906a4f4f989813a65be1c61b4b61bb7e00be6b32297af6362b9f618477");

                // console.log("test2", test2);
                // {
                //     const trx1 = await whitelistSale.setAddress(test2);
                //     await trx1.wait();
                // }


                // {
                //     let input1 = ethers.utils.arrayify("0xd99d93e06bc6efb74f4c370b826b9f758a4646a70ae5b514d24fabae2a9df4b2");
                //     let input2 = ethers.utils.arrayify("0xa35035444d2807ae23e9ff73fc73a60285935a12286646036a0774a72d184388");
                //     let inputs = new Array<any>();
                //     inputs.push(input1)
                //     inputs.push(input2)
                //     const trx1 = await whitelistSale.mint2(inputs);
                //     await trx1.wait();
                // }



            });
        });

    }

}

let v = new test10();
export default v;

