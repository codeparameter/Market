const { expect } = require("chai");

describe("market tests", () => {
  it("pass dealMaker as ABC to market construct", async () => {
    const { market, dealMaker } = await setUp();
    expect(await market.abcoin()).to.equal(dealMaker.address);
  });

  it("create NFT", async () => {
    const { market, otherAccounts, createNFT } = await setUp();
    const lastId = await createNFT(otherAccounts[0], "test");
    expect(await market.tokenURI(lastId)).to.equal("test");
  });

  it("create Auction", async () => {
    const { market, otherAccounts, createNFT } = await setUp();
    const lastId = await createNFT(otherAccounts[0], "test");
    await market.connect(otherAccounts[0]).createAuction(lastId, 100, 5);
    const auction = await market.auctions(lastId);
    expect(auction.seller).to.equal(otherAccounts[0].address);
    expect(auction.minimumPrice).to.equal(100);
  });

  it("bid", async () => {
    
    const { market, otherAccounts, createNFT } = await setUp();
    const lastId = await createNFT(otherAccounts[0], "test");
    await market.connect(otherAccounts[0]).createAuction(lastId, 100, 10000);
    
    await market.connect(otherAccounts[1]).bid(lastId, {value: 101});
    
    const auction = await market.auctions(lastId);
    expect(auction.highestBid).to.equal(101);
    expect(auction.highestBidder).to.equal(otherAccounts[1].address);

  });

  it("end auction", async () => {
    
    const { market, otherAccounts, createNFT } = await setUp();
    const lastId = await createNFT(otherAccounts[0], "test");

    const duration = 10000; // ms

    await market.connect(otherAccounts[0]).createAuction(lastId, 100, duration);

    const oldBalance0 = await ethers.provider.getBalance(otherAccounts[0].address);
    const oldBalance1 = await ethers.provider.getBalance(otherAccounts[1].address);
    const oldBalance2 = await ethers.provider.getBalance(otherAccounts[2].address);
    const oldBalance3 = await ethers.provider.getBalance(otherAccounts[3].address);
    const oldBalance4 = await ethers.provider.getBalance(otherAccounts[4].address);
    
    await market.connect(otherAccounts[1]).bid(lastId, {value: 101});
    await market.connect(otherAccounts[2]).bid(lastId, {value: 102});
    await market.connect(otherAccounts[3]).bid(lastId, {value: 103});
    await market.connect(otherAccounts[4]).bid(lastId, {value: 104});
    await market.connect(otherAccounts[1]).bid(lastId, {value: 4});
    
    await market.connect(otherAccounts[2]).payBack(lastId);
    await market.connect(otherAccounts[3]).payBack(lastId);
    await market.connect(otherAccounts[4]).payBack(lastId);

    await ethers.provider.send('evm_increaseTime', [duration]);

    market.connect(otherAccounts[0]).endAuction(lastId);

    const auction = await market.auctions(lastId);
    
    expect(auction.highestBid).to.equal(105);
    expect(auction.highestBidder).to.equal(otherAccounts[1].address);

    expect(await market.connect(otherAccounts[1]).ownerOf(lastId)).to.equal(otherAccounts[1].address);

    const newBalance0 = await ethers.provider.getBalance(otherAccounts[0].address);
    const newBalance1 = await ethers.provider.getBalance(otherAccounts[1].address);
    const newBalance2 = await ethers.provider.getBalance(otherAccounts[2].address);
    const newBalance3 = await ethers.provider.getBalance(otherAccounts[3].address);
    const newBalance4 = await ethers.provider.getBalance(otherAccounts[4].address);

    // because of Gas fee

    expect(newBalance0).to.lt(oldBalance0.add(auction.highestBid));
    expect(newBalance1).to.lt(oldBalance1.sub(auction.highestBid));
    expect(newBalance2).to.lt(oldBalance2);
    expect(newBalance3).to.lt(oldBalance3);
    expect(newBalance4).to.lt(oldBalance4);
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
