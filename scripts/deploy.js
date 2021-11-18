const hre = require("hardhat");

async function main() {
  const Crowdfunding = await hre.ethers.getContractFactory("CrowdFunding");
  const crowd = await Crowdfunding.deploy("Hello, Hardhat!");

  await crowd.deployed();

  console.log("Greeter deployed to:", crowd.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
