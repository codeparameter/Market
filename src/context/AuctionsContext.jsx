import { createContext, useEffect, useState } from "react";

export const auctionsContext = createContext();

const AuctionsProvider = ({ children }) => {
	const [auctions, setAuctions] = useState([]);

	const addAuction = (auction) => {
    setAuctions([...auctions, auction])
  };

	return (
		<auctionsContext.Provider value={{ auctions, addAuction }}>
			{children}
		</auctionsContext.Provider>
	);
};

export default AuctionsProvider;
