import {
	Route,
	RouterProvider,
	createBrowserRouter,
	createRoutesFromElements
} from "react-router-dom";
import Root from "./components/layouts/Root";
import Buy from "./components/pages/Buy";
import Landing from "./components/pages/Landing";
import NFT from "./components/layouts/NFT";
import Sell from "./components/pages/Sell";
import Token from "./components/layouts/Token";
import CreateNftForm from "./components/CreateNftForm";
import NFTDetails from "./components/pages/NFTDetails";
import Auctions from "./components/layouts/Auctions";
import Swap from "./components/pages/Swap";

const router = createBrowserRouter(
	createRoutesFromElements(
		<Route path="/" element={<Root />}>
			<Route index element={<Landing />} />
      <Route path="swap" element={<Swap />} />
			<Route path="token" element={<Token />} />
			<Route path="nft" element={<NFT />}>
				<Route path="create" element={<CreateNftForm />} />
				<Route path=":id" element={<NFTDetails />} />
			</Route>
			<Route path="buy" element={<Buy />} />
			<Route path="sell" element={<Sell />} />
			<Route path="auctions" element={<Auctions />} />
		</Route>
	)
);

function App() {
	return <RouterProvider router={router}></RouterProvider>;
}

export default App;
