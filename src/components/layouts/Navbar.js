import React from "react";
import { NavLink } from "react-router-dom";

const Navbar = () => {
	return (
		<div
			style={{
				display: "flex",
				gap: "15px",
				padding: "15px",
        margin: "15px 0",
				background: "teal",
				color: "white"
			}}
		>
			<NavLink to="nft">nft</NavLink>
			<br />
			<NavLink to="buy">buy</NavLink>
			<br />
			<NavLink to="sell">sell</NavLink>
		</div>
	);
};

export default Navbar;
