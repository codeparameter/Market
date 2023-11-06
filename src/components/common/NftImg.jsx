import { Box, chakra } from "@chakra-ui/react";

const NftImg = ({ imgSrc }) => {
	return (
		<Box
			borderRadius="md"
			maxW="300px"
			bg="gray.400"
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
				src={imgSrc}
				alt="NFT image source not found"
			/>
		</Box>
	);
};

export default NftImg;
