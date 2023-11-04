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
			<GridItem colSpan={2}>
				<TokenForm />
			</GridItem>
			<GridItem>
				<RequestList />
			</GridItem>
			<GridItem>
				<RequestList />
			</GridItem>
		</Grid>
	);
};

export default Token;
