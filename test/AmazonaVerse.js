const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('Amazona Verse Contract', () => {
  const setup = async ({ maxSupply = 10000 }) => {
    const [owner] = await ethers.getSigners()

    const AmazonaVerse = await ethers.getContractFactory('AmazonaVerse')
    const deployed = await AmazonaVerse.deploy(maxSupply)

    return {
      owner,
      deployed,
    }
  }

  describe('Deployment', () => {
    it('Set Max Supply', async () => {
      const maxSupply = 4000

      const { deployed } = await setup({ maxSupply })

      const returnedMaxSupply = await deployed.maxSupply()

      expect(maxSupply).to.equal(returnedMaxSupply)
    })
  })

  describe('Minting NFT', () => {
    it('Mints new Token', async () => {
      const { owner, deployed } = await setup({})

      await deployed.mint()

      const ownerMinted = await deployed.ownerOf(0)

      expect(ownerMinted).to.equal(owner.address)
    })

    it('Minting limit', async () => {
      const maxSupply = 2

      const { deployed } = await setup({ maxSupply })

      await Promise.all([deployed.mint(), deployed.mint()])

      await expect(deployed.mint()).to.be.revertedWith('No hay Amazona Verse')
    })
  })

  describe('tokenURI', () => {
    it('return valid metadata', async () => {
      const { deployed } = await setup({})
      await deployed.mint()

      const tokenURI = await deployed.tokenURI(0)

      const stringTokenURI = await tokenURI.toString()

      const [, base64JSON] = stringTokenURI.split(
        'data:application/json;base64,',
      )

      const stringifiedMetadata = await Buffer.from(
        base64JSON,
        'base64',
      ).toString('ascii')

      const metadata = JSON.parse(stringifiedMetadata)

      expect(metadata).to.have.all.keys('name', 'description', 'image')
    })
  })
})
