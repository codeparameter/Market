import { Outlet } from "react-router-dom";
import Navbar from "../common/Navbar";
import { Box, Container } from "@chakra-ui/react";

const Root = () => {
	return (
		<Container maxW="1200px">
			<Navbar />
			<Outlet />
		</Container>
	);
};

export default Root;
