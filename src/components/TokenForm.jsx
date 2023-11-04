import { chakra, Checkbox, Heading, Button } from "@chakra-ui/react";
import { useState } from "react";
import CustomNumberInput from "./common/CustomNumberInput";

const TokenForm = ({type}) => {
	const [tokenAmount, setTokenAmount] = useState(0);
	const [weiAmount, setWeiAmount] = useState(0);
	const [allAtOnceChecked, setAllAtOnceChecked] = useState(true);
	const [formState, setFormState] = useState(true);

	const toggleFormState = () => setFormState(prev => !prev);

	return (
		<chakra.form sx={{ display: "flex", flexDir: "column", gap: "16px" }}>
			<Heading textTransform="capitalize">{type} token</Heading>
			<CustomNumberInput
				value={tokenAmount}
				setValue={setTokenAmount}
				label={"Token Amount"}
			/>
			<CustomNumberInput
				value={weiAmount}
				setValue={setWeiAmount}
				label={"Wei Amount"}
			/>
			<Checkbox
				value={allAtOnceChecked}
				onChange={() => setAllAtOnceChecked(!allAtOnceChecked)}
			>
				All At Once
			</Checkbox>
			<Button colorScheme="teal" size="lg" type="submit">
				{type === 'buy' ? "Buy Token" : "Sell Token"}
			</Button>
		</chakra.form>
	);
};

export default TokenForm;
