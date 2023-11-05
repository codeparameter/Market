import { createContext, useEffect, useState } from "react";

export const auctionsContext = createContext()

const AuctionsProvider = ({children}) => {
  const [auctions, setAuctions] = useState([])
  
  const addAuction = () => {

  }

  useEffect(() => {
    
  }, [])
  return <auctionsContext.Provider value={{}}>{children}</auctionsContext.Provider>
} 

export default AuctionsProvider