const baseURL = "localhost:3001";
const url = {
	TOKEN: 'localhost:3001/token',
  TOKEN_SELL: 'localhost:3001/token/sell',
  TOKEN_BUY: 'localhost:3001/token/buy',
  NFT: 'localhost:3001/nfts',
  NFT_CREATE: 'localhost:3001/nfts/create',
  NFT_SELL_ETH: 'localhost:3001/nfts/sell/eth',
  NFT_SELL_TOKEN: 'localhost:3001/nfts/sell/token',
  NFT_BUY_ETH: 'localhost:3001/nfts/buy/eth',
  NFT_BUY_TOKEN: 'localhost:3001/nfts/buy/token',
  AUCTIONS: 'localhost:3001/auctions',
};

// localhost:port/token
// localhost:port/token/sell
// localhost:port/token/buy

// list of all nfts by using for loop on showNFT
// localhost:port/nfts

// localhost:port/nfts/create
// localhost:port/nfts/sell/eth
// localhost:port/nfts/sell/token
// localhost:port/nfts/buy/eth
// localhost:port/nfts/buy/token

// list of all auctions by using for loop on showAuction
// localhost:port/auctions

// localhost:port/auctions/create
// localhost:port/auctions/bid/{tokenId}?price
// localhost:port/auctions/{tokenId}
// localhost:port/auctions/payback/{tokenId}
