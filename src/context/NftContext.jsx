import { createContext, useState } from "react";

export const nftContext = createContext();

const NftProvider = ({ children }) => {
	const [nfts, setNfts] = useState([]);

	const addNft = ({ id, urlObject }) => {
		setNfts([...nfts, { id: id, urlObject: urlObject }]);
	};

	return (
		<nftContext.Provider value={{ nfts, addNft }}>
			{children}
		</nftContext.Provider>
	);
};

export default NftProvider;
