import { Grid, GridItem } from "@chakra-ui/react";
import TokenForm from "../TokenForm";
import RequestList from "../RequestList";

const Token = () => {
	return (
		<Grid
			templateColumns="repeat(2, 1fr)"
			templateRows="repeat(2, 1fr)"
			gap={6}
			py={6}
		>
			<GridItem>
				<TokenForm type={'buy'} />
			</GridItem>
      <GridItem>
				<TokenForm type={'sell'} />
			</GridItem>
			<GridItem>
				<RequestList type={'buy'} />
			</GridItem>
			<GridItem>
				<RequestList type={'sell'} />
			</GridItem>
		</Grid>
	);
};

export default Token;
