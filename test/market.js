const { expect } = require('chai');

describe('market tests', () => {

    async function setUp (){
        const DealMaker = await hre.ethers.getContractFactory('DealMaker');
        const dealmaker = await DealMaker.deploy();
        await dealmaker.deployed();
        const abcoin = await dealmaker.abcoin();
    
        const Market = await hre.ethers.getContractFactory('Market');
        const market = await Market.deploy(abcoin);
        await market.deployed();

        const [owner, ...otherAccounts] = await ethers.getSigners();

        console.log(owner);
        console.log(otherAccounts);
    
        return {market, abcoin, owner, otherAccounts};
    }

    it("pass abcoin to market construct", async () => {
        const {market, abcoin} = await setUp();
        expect(await market.abcoin()).to.equal(abcoin);
    });

    // it("auction", async () => {
    //     const {market, abcoin} = await setUp();
        
    //     expect(await market.abcoin()).to.equal(abcoin);
    // });
});
