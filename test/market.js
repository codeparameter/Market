const { expect } = require("chai");

describe("market tests", () => {
  it("pass dealMaker as ABC to market construct", async () => {
    const { market, dealMaker } = await setUp();
    expect(await market.abcoin()).to.equal(dealMaker.address);
  });

  it("create NFT", async () => {
    const { market, otherAccounts, createNFT } = await setUp();
    const lastId = createNFT(otherAccounts[0], "test");
    expect(await market.tokenURI(lastId)).to.equal("test");
  });

  it("create Auction", async () => {
    const { market, otherAccounts, createNFT } = await setUp();
    const lastId = createNFT(otherAccounts[0], "test");
    await market.connect(otherAccounts[0]).createAuction(lastId, 100, 5);
    const auction = await market.auctions(lastId);
    expect(auction.seller).to.equal(otherAccounts[0].address);
    expect(auction.minimumPrice).to.equal(100);
  });
});

async function deploy(name, ...args) {
  const Contract = await hre.ethers.getContractFactory(name);
  const contract = await Contract.deploy(...args);
  await contract.deployed();
  return contract;
}

async function setUp() {

  const dealMaker = await deploy("DealMaker");
  const market = await deploy("Market", dealMaker.address);

  const [owner, ...otherAccounts] = await ethers.getSigners();


  const createNFT = async (signer, tokenURI) => {
    await market.connect(signer).nftMint(tokenURI);
    const lastId = await market.tokenIds();
    return lastId;
  };


  return { market, dealMaker, owner, otherAccounts, createNFT };
}
