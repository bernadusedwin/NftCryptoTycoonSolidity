// const { ethers, upgrades } = require("hardhat");
// npx hardhat run --network localhost scripts/upgrade2.ts

// TO DO: Place the address of your proxy here!
const proxyAddress = "0xa295AdE61E61599a49480AeDd26BaB5f7413551c";

async function upgrade2() {
  const BoxV2 = await ethers.getContractFactory("BoxV2");
  const upgraded = await upgrades.upgradeProxy(proxyAddress, BoxV2);
  console.log((await upgraded.area()).toString());
  console.log((await upgraded.perimeter()).toString());

  {
    const trx1 = await upgraded.greet();
    console.log("result", trx1);
  }
}

upgrade2()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });