import {
	FormControl,
	FormLabel,
	NumberDecrementStepper,
	NumberIncrementStepper,
	NumberInput,
	NumberInputField,
	NumberInputStepper
} from "@chakra-ui/react";

const CustomNumberInput = ({ label, value, setValue }) => {
	return (
		<FormControl isRequired>
			<FormLabel>{label}</FormLabel>
			<NumberInput
				value={value}
				onChange={value => setValue(+value)}
				precision={2}
				step={1}
				min={0}
			>
				<NumberInputField />
				<NumberInputStepper>
					<NumberIncrementStepper />
					<NumberDecrementStepper />
				</NumberInputStepper>
			</NumberInput>
		</FormControl>
	);
};

export default CustomNumberInput