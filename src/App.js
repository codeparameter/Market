import {
	Route,
	RouterProvider,
	createBrowserRouter,
	createRoutesFromElements
} from "react-router-dom";
import RootLayout from "./components/layouts/RootLayout";
import NFT from "./components/pages/NFT";
import Buy from "./components/pages/Buy";
import Sell from "./components/pages/Sell";

const router = createBrowserRouter(
	createRoutesFromElements(
		<Route path="/" element={<RootLayout />}>
			<Route path="nft" element={<NFT />} />
			<Route path="buy" element={<Buy />} />
			<Route path="sell" element={<Sell />} />
		</Route>
	)
);

function App() {
	return <RouterProvider router={router}></RouterProvider>;
}

export default App;
