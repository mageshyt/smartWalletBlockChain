import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Smart Wallet", function () {
  let owner: any;
  async function deploySmartWalletFixture() {
    const SmartWallet = await ethers.getContractFactory("SmartWallet");
    const smartWallet = await SmartWallet.deploy();

    console.log("deploying ---");
    [owner] = await ethers.getSigners();

    // create accounts for users
    await smartWallet.createAccount().then((tx: any) => tx.wait());

    return { smartWallet };
  }

  //   create use function

  async function createUserFixture() {
    // get users
    const [owner, user1, user2] = await ethers.getSigners();

    // create accounts for users
    const SmartWallet = await ethers.getContractFactory("SmartWallet");
    const smartWallet = await SmartWallet.deploy();
  }
  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      const { smartWallet } = await loadFixture(deploySmartWalletFixture);

      expect(await smartWallet.getOwner()).to.equal(owner.address);
    });
  });

  it("Should set the right owner", async function () {
    const { smartWallet } = await loadFixture(deploySmartWalletFixture);

    expect(await smartWallet.getOwner()).to.equal(owner.address);
  });

  it("Should receive and store the funds to lock", async function () {
    const { smartWallet } = await loadFixture(deploySmartWalletFixture);

    expect(await ethers.provider.getBalance(smartWallet.address)).to.equal(0);
  });

  describe("checking Fuctions", function () {
    //   deposit
    it("it should deposit", async function () {
      // use user 1
      const { smartWallet } = await loadFixture(deploySmartWalletFixture);

      // deposit 1 eth
      await smartWallet.deposite({ value: 1000 }).then((tx: any) => tx.wait());

      // check balance
      expect(await ethers.provider.getBalance(smartWallet.address)).to.equal(
        1000
      );
    });

    //   withdraw
    it("it should withdraw", async function () {
      const { smartWallet } = await loadFixture(deploySmartWalletFixture);

      // deposit 1 eth
      await smartWallet.deposite({ value: 1000 }).then((tx: any) => tx.wait());

      // check balance
      expect(await ethers.provider.getBalance(smartWallet.address)).to.equal(
        1000
      );

      // withdraw 1 eth
      await smartWallet.withdraw(1000).then((tx: any) => tx.wait());

      // check balance
      expect(await ethers.provider.getBalance(smartWallet.address)).to.equal(0);
    });
  });
});
