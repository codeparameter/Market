import { Link } from "react-router-dom";
import { Box, Grid, chakra } from "@chakra-ui/react";
import { useContext } from "react";
import { nftContext } from "../../context/NftContext";

const Landing = () => {
	const { nfts } = useContext(nftContext);
  console.log(nfts);
	return (
		<Grid templateColumns="repeat(4, 1fr)" gap={12} my={12}>
			{nfts.map(nft => (
				<Box
					as={Link}
					to={`nft/${nft.id}`}
					key={nft.id}
          borderRadius="8px"
					maxW="300px"
					aspectRatio="1"
					display="grid"
					placeItems="center"
          overflow="hidden"
				>
					<chakra.img objectFit="cover" w="full" h="full" display="block" src={nft.urlObject} />
				</Box>
			))}
		</Grid>
	);
};

export default Landing;
