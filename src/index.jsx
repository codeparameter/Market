import React from "react";
import ReactDOM from "react-dom/client";
import { ChakraProvider } from "@chakra-ui/react";
import App from "./App";
import NftProvider from "./context/NftContext";

ReactDOM.createRoot(document.getElementById("root")).render(
    <React.StrictMode>
      <ChakraProvider>
          <NftProvider>
            <App />
          </NftProvider>
      </ChakraProvider>
    </React.StrictMode>
);
