import {
	Box,
	Button,
	ButtonGroup,
	Flex,
	Grid,
	GridItem,
	HStack,
	Heading,
	Text,
	VStack,
	chakra
} from "@chakra-ui/react";
import { useContext, useEffect, useState } from "react";
import { RiCoinsLine } from "react-icons/ri";
import { useNavigate, useParams } from "react-router-dom";
import { nftContext } from "../../context/NftContext";
import CustomNumberInput from "../common/CustomNumberInput";
import NftImg from "../common/NftImg";
import { auctionsContext } from "../../context/AuctionsContext";

const formStyle = {
	borderRadius: "md"
};
const headingStyle = {
	fontSize: "24px",
	mb: "4"
};
const buttonLeftStyle = { borderEndRadius: "0", borderStartRadius: "lg" };
const buttonRightStyle = { borderEndRadius: "lg", borderStartRadius: "0" };

const calcEndTime = time => {
	return time * 24 * 60 * 60 * 1000 + Date.now();
};

const NFTDetails = () => {
	const { id } = useParams();
	const [nft, setNft] = useState(null);
	const [sellPrice, setSellPrice] = useState(0);
	const [auctionPrice, setAuctionPrice] = useState(0);
	const [auctionDuration, setAuctionDuration] = useState(1);
	const { nfts } = useContext(nftContext);
	const { addAuction } = useContext(auctionsContext);
	const nav = useNavigate();

	useEffect(() => {
		const nft = nfts.find(item => item.id.toString() === id);
		setNft({ ...nft, price: 45 });
	}, []);

	const createAuction = () => {
		if (!auctionPrice || !auctionDuration) return;
		const data = {
			seller: "asdfghjkl",
			tokenId: id,
			minimumPrice: auctionPrice,
			endTime: calcEndTime(auctionDuration),
			highestBidder: "lkjhgfdsa",
			highestBid: 0,
			ended: false
		};
		addAuction(data);
		nav(`/auctions/${id}`);
	};

	return (
		<Flex my={12} gap="4" align="start">
			<VStack>
				<NftImg imgSrc={nft?.urlObject} />
				<HStack fontSize="24px">
					<RiCoinsLine />
					<Text>{nft?.price}</Text>
				</HStack>
			</VStack>
			<Grid flex="1" maxW="400px" templateRows="repeat(3, auto)" gap="8">
				<GridItem sx={formStyle}>
					<Heading sx={headingStyle}>buy</Heading>
					<HStack align="end">
						<ButtonGroup spacing="0" w="full">
							<Button sx={buttonLeftStyle} colorScheme="telegram" flex="1">
								ETH
							</Button>
							<Button sx={buttonRightStyle} colorScheme="teal" flex="1">
								ABcoin
							</Button>
						</ButtonGroup>
					</HStack>
				</GridItem>
				<GridItem sx={formStyle}>
					<Heading sx={headingStyle}>sell</Heading>
					<VStack align="Stretch">
						<CustomNumberInput
							label="Price"
							value={sellPrice}
							setValue={setSellPrice}
						/>
						<ButtonGroup spacing="0" w="full">
							<Button sx={buttonLeftStyle} colorScheme="telegram" flex="1">
								ETH
							</Button>
							<Button sx={buttonRightStyle} colorScheme="teal" flex="1">
								ABcoin
							</Button>
						</ButtonGroup>
					</VStack>
				</GridItem>
				<GridItem sx={formStyle}>
					<Heading sx={headingStyle}>create auction</Heading>
					<VStack align="stretch">
						<CustomNumberInput
							label="Minimum Price"
							value={auctionPrice}
							setValue={setAuctionPrice}
						/>
						<CustomNumberInput
							label="Duration (days)"
							value={auctionDuration}
							setValue={setAuctionDuration}
						/>
						<Button colorScheme="telegram" onClick={createAuction}>
							Create Auction
						</Button>
					</VStack>
				</GridItem>
			</Grid>
		</Flex>
	);
};

const SellNftForm = ({ tokenId }) => {
	return <chakra.form></chakra.form>;
};

export default NFTDetails;
