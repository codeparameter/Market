import { useParams } from "react-router-dom";

const Auction = () => {
	const { id } = useParams();
	return <div>Auction {id}</div>;
};

export default Auction;
