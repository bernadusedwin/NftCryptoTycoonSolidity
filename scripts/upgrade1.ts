



// npx hardhat run --network localhost scripts/upgrade1.ts


async function upgrade1() {
  const BoxV1 = await ethers.getContractFactory("BoxV1");
  const instance = await upgrades.deployProxy(BoxV1, [14, 14]);
  await instance.deployed();

  console.log(instance.address);
  console.log((await instance.area()).toString());
  {
    const trx1 = await instance.setGreeting("hello world");
    await trx1.wait();
  }
  
  {
    const trx1 = await instance.greet();
    console.log("result:",trx1);
  }
  

}

upgrade1();