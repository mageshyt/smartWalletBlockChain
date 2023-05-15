import { ethers } from "hardhat";

async function main() {
  const SmartWallet = await ethers.getContractFactory("SmartWallet");

  // Start deployment, returning a promise that resolves to a contract object
  const smartWallet = await SmartWallet.deploy();

  console.log("Contract deployed to address:", smartWallet.address);
  console.log(
    "Contract deployed by address:",
    smartWallet.deployTransaction.from
  );
  console.log("Contract deployed by hash:", smartWallet.deployTransaction.hash);
  console.log(
    "Contract deployed by nonce:",
    smartWallet.deployTransaction.nonce
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
