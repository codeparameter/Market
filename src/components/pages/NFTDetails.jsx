import {
	chakra,
	Box,
	Flex,
	Grid,
	GridItem,
	Heading,
	Button,
	HStack,
	ButtonGroup
} from "@chakra-ui/react";
import { useParams } from "react-router-dom";
import { useContext, useEffect, useState } from "react";
import { nftContext } from "../../context/NftContext";
import CustomNumberInput from "../common/CustomNumberInput";

const formStyle = {
	borderRadius: "md"
};
const headingStyle = {
	fontSize: "24px",
	mb: "4"
};
const buttonLeftStyle = { borderEndRadius: "0", borderStartRadius: "lg" };
const buttonRightStyle = { borderEndRadius: "lg", borderStartRadius: "0" };

const NFTDetails = () => {
	const { id } = useParams();
	const [nft, setNft] = useState(null);
	// const [value, setValue] = useState(0);
  const [buyPrice, setBuyPrice] = useState(0)
  const [sellPrice, setSellPrice] = useState(0)
  const [auctionPrice, setAuctionPrice] = useState(0)
	const { nfts } = useContext(nftContext);

	useEffect(() => {
		const nft = nfts.find(item => item.id === +id);
		setNft(nft);
	});

	return (
		<Flex my={12} gap="4" align="start">
			<Box
				borderRadius="md"
				maxW="300px"
				bg="turquoise"
				aspectRatio="1"
				display="grid"
				placeItems="center"
				overflow="hidden"
			>
				<chakra.img
					objectFit="cover"
					w="full"
					h="full"
					display="block"
					src={nft?.urlObject}
					alt="NFT image source not found"
				/>
			</Box>
			<Grid
				flex="1"
				templateColumns="repeat(2, 1fr)"
				templateRows="repeat(2, 1fr)"
				gap="4"
			>
				<GridItem sx={formStyle}>
					<Heading sx={headingStyle}>buy</Heading>
					<HStack align="end">
						<CustomNumberInput
							label="Price"
							value={buyPrice}
							setValue={setBuyPrice}
						/>
						<ButtonGroup spacing="0">
							<Button sx={buttonLeftStyle}>ETH</Button>
							<Button sx={buttonRightStyle}>ABcoin</Button>
						</ButtonGroup>
					</HStack>
				</GridItem>
				<GridItem sx={formStyle}>
					<Heading sx={headingStyle}>sell</Heading>
					<HStack align="end">
						<CustomNumberInput
							label="Price"
							value={sellPrice}
							setValue={setSellPrice}
						/>
						<ButtonGroup spacing="0">
							<Button sx={buttonLeftStyle}>ETH</Button>
							<Button sx={buttonRightStyle}>ABcoin</Button>
						</ButtonGroup>
					</HStack>
				</GridItem>
				<GridItem colSpan="2" sx={formStyle}>
					<Heading sx={headingStyle}>create auction</Heading>
					<HStack align="end">
						<CustomNumberInput
							label="Price"
							value={auctionPrice}
							setValue={setAuctionPrice}
						/>
						<Button>Create Auction</Button>
					</HStack>
				</GridItem>
			</Grid>
		</Flex>
	);
};

const SellNftForm = ({ tokenId }) => {
	return <chakra.form></chakra.form>;
};

export default NFTDetails;
