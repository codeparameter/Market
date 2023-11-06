import { Button, Grid, GridItem, Text, VStack } from "@chakra-ui/react";
import { useContext, useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { auctionsContext } from "../../context/AuctionsContext";
import { nftContext } from "../../context/NftContext";
import NftImg from "../common/NftImg";

const Auction = () => {
	const { id } = useParams();
	const { nfts } = useContext(nftContext);
	const { auctions } = useContext(auctionsContext);
	const [nft, setNft] = useState();
	const [auction, setAuction] = useState();

	useEffect(() => {
		console.log(nfts, auctions);
		setNft(nfts.find(item => item.id === +id));
		setAuction(auctions.find(item => item.tokenId === +id));
	}, []);

	return (
		<Grid templateColumns="auto 1fr 1fr" gap={6} my="12" fontSize="xl">
			<GridItem>
				<NftImg imgSrc={nft?.urlObject} />
        <Button colorScheme="red" my="6">End Auction</Button>
			</GridItem>
			<GridItem>
				<VStack align="start" gap="6">
					<Text>Seller: {auction?.seller}</Text>
					<Text>Minimum Price: {auction?.minimumPrice}</Text>
					<Text>End Time: {auction?.endTime.toISOString()}</Text>
				</VStack>
			</GridItem>
			<GridItem>
				<VStack align="start" gap="6">
					<Text>Highest Bidder: {auction?.highestBidder}</Text>
					<Text>Highest Bid: {auction?.highestBid}</Text>
          <Button colorScheme="teal">Place Bid</Button>
				</VStack>
			</GridItem>
		</Grid>
	);
};

export default Auction;
