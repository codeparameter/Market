import {
	Heading,
	Table,
	TableContainer,
	Tbody,
	Td,
	Tfoot,
	Th,
	Thead,
	Tr
} from "@chakra-ui/react";
import { useEffect, useState } from "react";

const formHeadingStyle = {
	textTransform: "capitalize",
	fontSize: "1.5rem",
	my: "1.5rem"
};

const RequestList = ({ type }) => {
	const [list, setList] = useState([]);
	useEffect(() => {
		// todo: get buy/sell request list
	}, []);

	const headers = ["User", "Token Amount", "Wei Amount", "Rate", "All At Once"];

	const mockData = [
		{
			user: "12gsfdger3879asf8713",
			tokenAmount: 74923874,
			weiAmount: 234980,
			rate: 23,
			allAtOnce: true
		},
		{
			user: "12gsfdger3879asf8713",
			tokenAmount: 74923874,
			weiAmount: 234980,
			rate: 23,
			allAtOnce: true
		},
		{
			user: "12gsfdger3879asf8713",
			tokenAmount: 74923874,
			weiAmount: 234980,
			rate: 23,
			allAtOnce: true
		},
		{
			user: "12gsfdger3879asf8713",
			tokenAmount: 74923874,
			weiAmount: 234980,
			rate: 23,
			allAtOnce: true
		},
		{
			user: "12gsfdger3879asf8713",
			tokenAmount: 74923874,
			weiAmount: 234980,
			rate: 23,
			allAtOnce: true
		}
	];

	return (
		<TableContainer>
			<Heading as="h3" sx={formHeadingStyle}>
				{type} requests
			</Heading>
			<Table variant="striped" colorScheme="teal" size="sm">
				<Thead>
					<Tr>
						{headers.map(item => (
							<Th key={item} textAlign="center">
								{item}
							</Th>
						))}
					</Tr>
				</Thead>
				<Tbody>
					{mockData.map(request => (
						<Request key={request.id} {...request} />
					))}
				</Tbody>
				<Tfoot>
					<Tr>
						{headers.map(item => (
							<Th key={item} textAlign="center">
								{item}
							</Th>
						))}
					</Tr>
				</Tfoot>
			</Table>
		</TableContainer>
	);
};

// struct ExchangeRequest {
//   address user;
//   uint256 tokenAmount;
//   uint256 weiAmount;
//   uint256 rate;
//   bool allAtOnce;
// }

const Request = ({ user, tokenAmount, weiAmount, rate, allAtOnce }) => {
	return (
		<Tr>
			<Td textAlign="center">{user}</Td>
			<Td textAlign="center">{tokenAmount}</Td>
			<Td textAlign="center">{weiAmount}</Td>
			<Td textAlign="center">{rate}</Td>
			<Td textAlign="center">{allAtOnce ? "yes" : "no"}</Td>
		</Tr>
	);
};

export default RequestList;
