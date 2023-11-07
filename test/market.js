const { expect } = require("chai");

describe("market tests", () => {
  it("pass abcoin to market construct", async () => {
    const { market, abcoin } = await setUp();
    expect(await market.abcoin()).to.equal(abcoin);
  });

  it("create NFT", async () => {
    const { market, otherAccounts } = await setUp();
    const lastId = createNFT(market, otherAccounts[0], 'test');
    expect(await market.showNFT(lastId)).to.equal('test');
  });

  it("create Auction", async () => {
    const { market, owner, otherAccounts } = await setUp();
    const lastId = createNFT(market, otherAccounts[0], 'test');
    await market.connect(otherAccounts[0]).createAuction(lastId, 100, 5);
    const auction = await market.auctions(lastId);
    expect(auction.seller).to.equal(otherAccounts[0].address);
    expect(auction.minimumPrice).to.equal(100);
  });
});

async function setUp() {
  const DealMaker = await hre.ethers.getContractFactory("DealMaker");
  const dealmaker = await DealMaker.deploy();
  await dealmaker.deployed();

  const abcoin = await dealmaker.abcoin();

  const Market = await hre.ethers.getContractFactory("Market");
  const market = await Market.deploy(abcoin);
  await market.deployed();

  const [owner, ...otherAccounts] = await ethers.getSigners();

  return { market, abcoin, owner, otherAccounts };
}

async function createNFT(market, signer, tokenURI){
    await market.connect(signer).createNFT(tokenURI);
    const lastId = await market.getLastNFT();
    return lastId;
}
