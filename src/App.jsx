import {
	Route,
	RouterProvider,
	createBrowserRouter,
	createRoutesFromElements
} from "react-router-dom";
import Root from "./components/layouts/Root";
import Buy from "./components/pages/Buy";
import Landing from "./components/pages/Landing";
import NFTs from "./components/layouts/NFTs";
import Sell from "./components/pages/Sell";
import Token from "./components/layouts/Token";

const router = createBrowserRouter(
	createRoutesFromElements(
		<Route path="/" element={<Root />}>
			<Route index element={<Landing />} />
			<Route path="token" element={<Token />} />
			<Route path="nft" element={<NFTs />} />
			<Route path="buy" element={<Buy />} />
			<Route path="sell" element={<Sell />} />
		</Route>
	)
);

function App() {
	return <RouterProvider router={router}></RouterProvider>;
}

export default App;
