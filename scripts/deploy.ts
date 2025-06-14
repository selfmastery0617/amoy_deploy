import { ethers } from "hardhat";
import { MintingManager__factory } from "../typechain-types";

async function main() {
    // Get the contract factory
    const MintingManager: MintingManager__factory = await ethers.getContractFactory("MintingManager");

    // Deploy the contract
    const mintingManager = await MintingManager.deploy();
    await mintingManager.waitForDeployment();

    const address = await mintingManager.getAddress();
    console.log("MintingManager deployed to:", address);
}

// Execute deployment
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });