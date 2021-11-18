const { ethers } = require('hardhat')

const deploy = async () => {
  const [deployer] = await ethers.getSigners()

  console.log('Deploying contract with the account: ', deployer.address)
  const AmazonaVerse = await ethers.getContractFactory('AmazonaVerse')
  const deployed = await AmazonaVerse.deploy()

  console.log('Amazona Verse is deployed at: ', deployed.address)
}

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error)
    process.exit(1)
  })
