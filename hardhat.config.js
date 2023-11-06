/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    ganache: {
      url: "http://127.0.0.1:8545",
      chainId: "1337",
      accounts: [
        `0x6a6fee362532e3999e2bec3c7d0a9500f38699c25ea55883e14a7cc324633706`,
        `0x5493e0d44627b2205519eb2fb209fa813ae388f449da40fea517e4fde4485df5`,
        `0xe6e0861674b1d86188a8f47b881273d67471af9b2db2ed02731c86cb01bd56cc`,
        `0x26d95f937da6b4ecffa0f48c6a094f38bf8c13838711d6b807e25340b1b3a17b`,
        `0x77c26b93a92c04e2c8d321e6bcae96e3089de5cf587ef12fc237881221d516f3`,
        `0x305116c782f4eba6355456cbd497bdef6b507a7c71b5618cf73908612fbde20b`,
        `0xde939da704f8cea40f66e95817cb48879340f0c472a32ca95516f7f928fef78a`,
        `0xd9c0b196c2b2e68e7860f0fd12e1aacb596225430f75aa88603b3a70cb827d6b`,
        `0xa33bc954d1c21f462d128bf8ff2810e0b25b524cf9535cd782d84520437cbd87`,
      ],
    },
  },
};
