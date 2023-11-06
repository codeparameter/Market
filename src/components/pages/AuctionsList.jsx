import { useContext } from "react/cjs/react.development";
import { nftContext } from "../../context/NftContext";
import { Box, Grid, Text } from "@chakra-ui/react";
import { Link } from "react-router-dom";
import NftImg from "../common/NftImg";

const AuctionsList = () => {
	const { nfts } = useContext(nftContext);
	const auctions = [
		{
			tokenId: 123,
			highestBid: 123,
			createdAt: new Date("Nov 03 2023"),
			duration: 5
		},
		{
			tokenId: 321,
			highestBid: 1293,
			createdAt: new Date("Nov 03 2023"),
			duration: 5
		}
	];

	const getNft = id => {
		return nfts.find(item => (item.id === id));
	};

	const getRemainingTime = (duration, createdAt) => {
		return Math.ceil(
			(duration * 24 * 60 * 60 * 1000 -
				(new Date().getTime() - createdAt.getTime())) /
				1000 /
				60 /
				60 /
				24
		);
	};

	return (
		<Grid templateColumns="repeat(4, 1fr)" gap={12} my={12}>
			{auctions.map(nft => (
				<Link to={`${nft.tokenId}`} key={nft.tokenId}>
					<NftImg imgSrc={getNft(nft.tokenId)?.urlObject} />
					<Box my={4}>
						<Text>Highest bid : {nft.highestBid}</Text>
						<Text>
							Remaining days : {getRemainingTime(nft.duration, nft.createdAt)}
						</Text>
					</Box>
				</Link>
			))}
		</Grid>
	);
};

export default AuctionsList;
