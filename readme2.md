readme2.md


yarn run hardhat clear-abi
yarn run hardhat export-abi
cd /Users/edwin/work_eth/tycoonGamefi/tycoonNFT2
npx hardhat node

npx hardhat run --network localhost scripts/deploy5.ts
npx hardhat run --network rinkeby scripts/deploy5.ts
npx hardhat run --network ropsten scripts/deploy5.ts

npx hardhat run --network ganache scripts/deploy5.ts

npx hardhat run --network localhost scripts/deploy3.ts
npx hardhat run --network rinkeby scripts/deploy3.ts
npx hardhat verify --network rinkeby 0x827D5015ecC04707997B949A0A6cc5A9312cD7D4 


npx hardhat verify --network rinkeby 0x81Df778Dc7BeeB301c27B694673a970E5D004597 
npx hardhat verify --network rinkeby 0x2E2402d5B2cDd892B1846536808B761031920Ad7 

npx hardhat run --network ganache scripts/deploy3.ts


npx hardhat run --network ropsten scripts/deploy3.ts

npx hardhat run --network localhost scripts/deploy.ts
npx hardhat run --network rinkeby scripts/deploy.ts



npx hardhat run --network ganache scripts/deploy.ts
npx hardhat run --network ropsten scripts/deploy.ts



----- rinkeby ----
trainTycoon deployed to: 0x81Df778Dc7BeeB301c27B694673a970E5D004597
eRC20 deployed to: 0x2E2402d5B2cDd892B1846536808B761031920Ad7





----

trainTycoon deployed to: 0x1ebc69506e82c66798AFfaE56931bCAD71018Df8
eRC20 deployed to: 0x0eA26F365F4638dca836015096F6DE9411659909
campaign deployed to: 0x96a15fB3e407D3F5195B782cee48E8bCAdA8AC82

npx hardhat run --network rinkeby scripts/upgrade1.ts
0x329898771096f0803Eb2feE77b6449ca27d31fb8
392

npx hardhat verify --network rinkeby 0xc4d07470e5dbdc7ca90e81475768d3c938ef8e98 
npx hardhat run --network rinkeby scripts/upgrade2.ts
npx hardhat verify --network rinkeby 0x852e9006247700820e42f79cfb9ec6d8758e2c7d 



npx hardhat run --network localhost scripts/upgrade1.ts


-- result --

edwin@edwins-MacBook-Pro-2 tycoonNFT2 % npx hardhat run --network localhost scripts/deploy5.ts
No need to generate any newer typings.
trainTycoon deployed to: 0x5FbDB2315678afecb367f032d93F642f64180aa3
eRC20 deployed to: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
campaign deployed to: 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
trainCargo deployed to: 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
combineManager deployed to: 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9


edwin@edwins-MacBook-Pro-2 tycoonNFT2 % npx hardhat run --network rinkeby scripts/deploy5.ts
No need to generate any newer typings.
trainTycoon deployed to: 0xED588036eA4873235BD633E64EC734cBc554792B
eRC20 deployed to: 0x4294E48209f37A3F2020d76D3b752aF73F732Df6
campaign deployed to: 0xd006E10f87F751eE02D6eDF706E4be518E880780
trainCargo deployed to: 0xBB6DF88bB61103c903609F40723829F43354D984
combineManager deployed to: 0xC6e4FbbBFa2810377fE5DDe8E3057988de905EFa
edwin@edwins-MacBook-Pro-2 tycoonNFT2 % 


whitelist

npx hardhat run --network rinkeby scripts/deploy_white.ts
0xA1DCacFCae06A76F549FDE92167cF336E10474E0
npx hardhat verify --network rinkeby 0xA1DCacFCae06A76F549FDE92167cF336E10474E0


roc

npx hardhat run --network rinkeby scripts/deploy_roc.ts
0xbeb4526499842A60b246A53F2f98b2377419e27e
npx hardhat verify --network rinkeby 0xbeb4526499842A60b246A53F2f98b2377419e27e


npx hardhat run --network matic scripts/deploy_roc.ts
0x535ff759ca042fBB1BD1c8B99AAC5452c4189302
npx hardhat verify --network matic 0x535ff759ca042fBB1BD1c8B99AAC5452c4189302 "0xda504d5644afa6adecc29e5cae3c5533c56eb9e9"


Error in plugin @nomiclabs/hardhat-etherscan: The constructor for contracts has 1 parameters
but 0 arguments were provided instead.


bridge

npx hardhat run --network localhost scripts/deploy_bridge.ts


https://goerli.etherscan.io/address/0x535ff759ca042fBB1BD1c8B99AAC5452c4189302#code
npx hardhat run --network goerli scripts/deploy_bridge_1_parent.ts
npx hardhat verify --network goerli 0x535ff759ca042fBB1BD1c8B99AAC5452c4189302 "0x2890bA17EfE978480615e330ecB65333b880928e" "0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA"
    const checkPoint = "0x2890bA17EfE978480615e330ecB65333b880928e";
    const root = "0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA";
0x535ff759ca042fBB1BD1c8B99AAC5452c4189302

https://mumbai.polygonscan.com/address/0x535ff759ca042fBB1BD1c8B99AAC5452c4189302#code
npx hardhat run --network mumbai scripts/deploy_bridge_2_child.ts
npx hardhat verify --network mumbai 0x535ff759ca042fBB1BD1c8B99AAC5452c4189302 "0xCf73231F28B7331BBe3124B907840A94851f9f11"
0x535ff759ca042fBB1BD1c8B99AAC5452c4189302

npx hardhat run --network goerli scripts/deploy_bridge_3_parent_config.ts
npx hardhat run --network mumbai scripts/deploy_bridge_4_child_config.ts


bridge2


https://goerli.etherscan.io/address/0x8e4d7b745Ee9AbECd61Dee46651B5e99723D0FdC#code
npx hardhat run --network goerli scripts/deploy_bridge_1_parent.ts
npx hardhat verify --network goerli 0x8e4d7b745Ee9AbECd61Dee46651B5e99723D0FdC "0x2890bA17EfE978480615e330ecB65333b880928e" "0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA"
    
0x8e4d7b745Ee9AbECd61Dee46651B5e99723D0FdC

https://mumbai.polygonscan.com/address/0x8e4d7b745Ee9AbECd61Dee46651B5e99723D0FdC#code
npx hardhat run --network mumbai scripts/deploy_bridge_2_child.ts
npx hardhat verify --network mumbai 0x8e4d7b745Ee9AbECd61Dee46651B5e99723D0FdC "0xCf73231F28B7331BBe3124B907840A94851f9f11"

0xCf73231F28B7331BBe3124B907840A94851f9f11

0x8e4d7b745Ee9AbECd61Dee46651B5e99723D0FdC


--- bridge 3
npx hardhat run --network goerli scripts/deploy_bridge_B_1_deploy_erc_on_eth.ts
npx hardhat verify  --contract contracts/erc20-item.sol:ERC20Item  --network goerli 0x581D3247806c4Ec6EcC022F74745d6782469C9AF 
https://goerli.etherscan.io/address/0x581D3247806c4Ec6EcC022F74745d6782469C9AF#code


npx hardhat run --network goerli scripts/deploy_bridge_B_2_deploy_parent_on_eth.ts
npx hardhat verify  --network goerli 0xeF5BD727b9F6d1eC1E52Bde269d0b5ED82062276    "0x2890bA17EfE978480615e330ecB65333b880928e" "0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA" "0x581D3247806c4Ec6EcC022F74745d6782469C9AF"
https://goerli.etherscan.io/address/0xeF5BD727b9F6d1eC1E52Bde269d0b5ED82062276#code

npx hardhat run --network mumbai scripts/deploy_bridge_B_3_deploy_erc_on_matic.ts
npx hardhat verify  --contract contracts/erc20-item.sol:ERC20Item  --network mumbai 0xDBdd5D3094DDb81F43b314ef0e40D55423D768A7 
https://mumbai.polygonscan.com/address/0xDBdd5D3094DDb81F43b314ef0e40D55423D768A7#code


npx hardhat run --network mumbai scripts/deploy_bridge_B_4_deploy_child_on_matic.ts
0xD87678D2c75Aee354ff2a12BA192e52621694d33
npx hardhat verify  --contract contracts/bridge/examples/erc20-transfer/FxERC20ChildTunnel.sol:FxERC20ChildTunnel --network mumbai 0xD87678D2c75Aee354ff2a12BA192e52621694d33    "0x535ff759ca042fBB1BD1c8B99AAC5452c4189302" "0xDBdd5D3094DDb81F43b314ef0e40D55423D768A7" 
https://mumbai.polygonscan.com/address/0xD87678D2c75Aee354ff2a12BA192e52621694d33#code