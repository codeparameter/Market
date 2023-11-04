import React from "react";
import { NavLink } from "react-router-dom";
import { chakra, Flex, HStack, Icon, Text } from "@chakra-ui/react";
import {
	RiNftLine,
	RiMoneyDollarCircleLine,
	RiShoppingCartLine,
	RiHome8Line, RiTokenSwapFill
} from "react-icons/ri";

const navbarStyle = {
	alignItems: "center",
	justifyContent: "space-between",
	m: "20px 0",
	pos: "sticky",
	top: "24px",
	color: "white"
};
const navlinkStyle = {
	display: "flex",
	alignItems: "center",
	gap: "6px",
	p: "10px",
	bg: "cyan.700",
	borderRadius: "8px"
};
const iconStyle = { w: "24px", h: "24px" };
const navlinkTextStyle = { fontSize: "20px" };

const Navbar = () => {
	return (
		<Flex sx={navbarStyle}>
			<chakra.a as={NavLink} to="/" sx={navlinkStyle}>
				<Icon as={RiHome8Line} sx={iconStyle} />
				<Text sx={navlinkTextStyle}>Home</Text>
			</chakra.a>
			<HStack>
				<chakra.a as={NavLink} to="/nft/create" sx={navlinkStyle}>
					<Icon as={RiNftLine} sx={iconStyle} />
					<Text sx={navlinkTextStyle}>Create NFT</Text>
				</chakra.a>
        <chakra.a as={NavLink} to="/token" sx={navlinkStyle}>
					<Icon as={RiTokenSwapFill} sx={iconStyle} />
					<Text sx={navlinkTextStyle}>token</Text>
				</chakra.a>
				<chakra.a as={NavLink} to="/buy" sx={navlinkStyle}>
					<Icon as={RiShoppingCartLine} sx={iconStyle} />
					<Text sx={navlinkTextStyle}>Buy</Text>
				</chakra.a>
				<chakra.a as={NavLink} to="/sell" sx={navlinkStyle}>
					<Icon as={RiMoneyDollarCircleLine} sx={iconStyle} />
					<Text sx={navlinkTextStyle}>Sell</Text>
				</chakra.a>
			</HStack>
		</Flex>
	);
};

export default Navbar;
