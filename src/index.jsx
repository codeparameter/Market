import React from "react";
import ReactDOM from "react-dom/client";
import { ChakraProvider } from "@chakra-ui/react";
import App from "./App";
import NftProvider from "./context/NftContext";
import AuctionsProvider from "./context/AuctionsContext";

ReactDOM.createRoot(document.getElementById("root")).render(
    <React.StrictMode>
      <ChakraProvider>
          <NftProvider>
            <AuctionsProvider>
              <App />
            </AuctionsProvider>
          </NftProvider>
      </ChakraProvider>
    </React.StrictMode>
);
