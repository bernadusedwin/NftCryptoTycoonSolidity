// import { expect } from "chai";
// import { ethers } from "hardhat";
import test1 from "./test1";
// import test2 from "./test2";
// import test3 from "./test3";
// import test4 from "./test4";
// import test5 from "./test5";
import test6 from "./test6";
// import test7 from "./test7";
// import test8 from "./test8";
import test9 from "./test9";
// import test10 from "./test10";
// import test11 from "./test11";
// import test12 from "./test12";
// import test13 from "./test13";
// import test14 from "./test14";

import realGameLogic from "./real-game-logic";
import realNegativeInit from "./real-negative-init";
import realNegativeMint from "./real-negative-mint";

import realNegativeDiffTarget from "./real-negative-diff-target";
import realNegativeCombine from "./real-negative-combine";
import realNegativeInterSection from "./real-negative-inter-section";

import test15 from "./test15";
import test16 from "./test16";
import test17 from "./test17";

import test_attack from "./test_attack";

// import whitelistSale from "./whitelistSale2";
// import whitelistSale from "./whitelistSale3";
import whitelistSale from "./whitelistSale4";

async function test() {
  // await realGameLogic.execute();
  // await realNegativeInit.execute();
  // await realNegativeMint.execute();
  // await realNegativeInterSection.execute();

  // await realNegativeDiffTarget.execute();

  // await whitelistSale.execute();
  await test_attack.execute();


  // await test1.execute();
  // await test2.execute();
  // await test3.execute();
  // await test4.execute();
  // await test5.execute();
  // await test6.execute();
  // await test7.execute();  
  // await test8.execute();  
  // await test9.execute();  
  // await test10.execute();  
  // await test11.execute();  
  // await test12.execute();  
  // await test13.execute();  
  // await test14.execute();  

  // await test15.execute();  
  // await test16.execute();


  // await test17.execute();


}

test();