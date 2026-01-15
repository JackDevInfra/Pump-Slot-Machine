const hre = require("hardhat");

async function main() {
  const PumpSlotMachine = await hre.ethers.getContractFactory("PumpSlotMachine");
  const machine = await PumpSlotMachine.deploy(
    "0x0000000000000000000000000000000000000000",
    hre.ethers.parseEther("1")
  );

  await machine.waitForDeployment();
  console.log("PumpSlotMachine deployed to:", await machine.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});