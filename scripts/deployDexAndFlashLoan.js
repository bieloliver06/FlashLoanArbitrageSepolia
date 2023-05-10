const hre = require("hardhat");

async function main() {
  console.log("Deploying Dex and FlashLoanSepolia...");
  const Dex = await hre.ethers.getContractFactory("Dex");
  const dex = await Dex.deploy();

  await dex.deployed();
  console.log("Dex deployed to:", dex.address);

  const FlashLoanSepolia = await hre.ethers.getContractFactory(
    "FlashLoanSepolia"
  );
  const flashLoanSepolia = await FlashLoanSepolia.deploy(
    "0x0496275d34753A48320CA58103d5220d394FF77F",
    dex.address
  );

  await flashLoanSepolia.deployed();
  console.log("FlashLoanSepolia deployed to:", flashLoanSepolia.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
