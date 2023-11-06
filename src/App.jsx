import {
	Route,
	RouterProvider,
	createBrowserRouter,
	createRoutesFromElements
} from "react-router-dom";
import Root from "./components/layouts/Root";
import Buy from "./components/pages/Buy";
import Landing from "./components/pages/Landing";
import Sell from "./components/pages/Sell";
import Token from "./components/layouts/Token";
import CreateNftForm from "./components/CreateNftForm";
import NFTDetails from "./components/pages/NFTDetails";
import Swap from "./components/pages/Swap";
import Auction from "./components/pages/Auction";
import AuctionsList from "./components/pages/AuctionsList";

const router = createBrowserRouter(
	createRoutesFromElements(
		<Route path="/" element={<Root />}>
			<Route index element={<Landing />} />
      <Route path="swap" element={<Swap />} />
			<Route path="token" element={<Token />} />
			<Route path="nft">
				<Route path="create" element={<CreateNftForm />} />
				<Route path=":id" element={<NFTDetails />} />
			</Route>
			<Route path="buy" element={<Buy />} />
			<Route path="sell" element={<Sell />} />
			<Route path="auctions">
        <Route index element={<AuctionsList />} />
        <Route path=":id" element={<Auction />} />
      </Route>
		</Route>
	)
);

function App() {
	return <RouterProvider router={router}></RouterProvider>;
}

export default App;
