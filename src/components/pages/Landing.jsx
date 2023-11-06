import { Link } from "react-router-dom";
import { Box, Grid, chakra } from "@chakra-ui/react";
import { useContext } from "react";
import { nftContext } from "../../context/NftContext";
import NftImg from "../common/NftImg";

const Landing = () => {
	const { nfts } = useContext(nftContext);
	console.log(nfts);
	return (
		<Grid templateColumns="repeat(4, 1fr)" gap={12} my={12}>
			{nfts.map(nft => (
				<Link to={`nft/${nft.id}`} key={nft.id}>
          <NftImg imgSrc={nft.urlObject} />
				</Link>
			))}
		</Grid>
	);
};

export default Landing;
