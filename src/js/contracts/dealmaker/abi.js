const abi = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "abcoin",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "buyer",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "lastWeiAmount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "lastTokenAmunt",
				"type": "uint256"
			}
		],
		"name": "BuyRequestMatched",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "buyer",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "newWeiAmount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "newTokenAmunt",
				"type": "uint256"
			}
		],
		"name": "BuyRequestShrinked",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "buyer",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "weiAmount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "tokenAmunt",
				"type": "uint256"
			}
		],
		"name": "BuyRequestStored",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "seller",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "lastWeiAmount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "lastTokenAmunt",
				"type": "uint256"
			}
		],
		"name": "SellRequestMatched",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "seller",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "newWeiAmount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "newTokenAmunt",
				"type": "uint256"
			}
		],
		"name": "SellRequestShrinked",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "seller",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "weiAmount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "tokenAmunt",
				"type": "uint256"
			}
		],
		"name": "SellRequestStored",
		"type": "event"
	},
	{
		"inputs": [],
		"name": "abcoin",
		"outputs": [
			{
				"internalType": "contract ABCoin",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "buyRequests",
		"outputs": [
			{
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "tokenAmount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "weiAmount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "rate",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "allAtOnce",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "createABCoin",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "isOwner",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "sellRequests",
		"outputs": [
			{
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "tokenAmount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "weiAmount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "rate",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "allAtOnce",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "tokenAmount",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "allAtOnce",
				"type": "bool"
			}
		],
		"name": "submitBuyRequest",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "tokenAmount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "weiAmount",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "allAtOnce",
				"type": "bool"
			}
		],
		"name": "submitSellRequest",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
];

export {abi};