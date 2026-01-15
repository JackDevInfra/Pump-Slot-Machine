const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PumpSlotMachine", function () {
  it("should deploy and spin", async function () {
    const [owner, user] = await ethers.getSigners();
    const PumpSlotMachine = await ethers.getContractFactory("PumpSlotMachine");
    const machine = await PumpSlotMachine.deploy(
      ethers.ZeroAddress,
      ethers.parseEther("1")
    );

    await machine.registerHolder(user.address, ethers.parseEther("2"));
    await ethers.provider.send("evm_increaseTime", [600]);
    await machine.spin();

    expect(await machine.lastSpinTimestamp()).to.be.gt(0);
  });
});