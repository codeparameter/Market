import { useState, useContext } from "react";
import { Button, chakra } from "@chakra-ui/react";
import CustomFileInput from "./common/CustomFileInput";
import { useNavigate } from "react-router-dom";
import { nftContext } from "../context/NftContext";

const submitButtonStyle = {
	bg: "teal.500",
	color: "white",
	w: "full",
	_disabled: {
		bg: "gray.400",
		cursor: "not-allowed",
		_hover: { bg: "gray.400" }
	}
};

const randomInt = () => {
  return Math.floor(Math.random() * 100 + 1)
}

const CreateNftForm = () => {
	const [image, setImage] = useState(null);
	const [fileName, setFileName] = useState("No selected file");
  const {addNft} = useContext(nftContext)
	const nav = useNavigate();

	const handleChange = ({ target: { files } }) => {
		files[0] && setFileName(files[0].name);
		if (files) {
			setImage(URL.createObjectURL(files[0]));
			console.log(URL.createObjectURL(files[0]));
		}
	};

	const handleDelete = () => {
		setFileName("No selected file");
		setImage(null);
	};

	const handleSubmit = async e => {
		e.preventDefault();
		if (!image) return;
		// const nftId = await fetch()
    addNft({id: randomInt(), urlObject: image})
		nav(`/`);
	};

	return (
		<>
			<chakra.form sx={{ w: "400px", m: "2rem auto" }} onSubmit={handleSubmit}>
				<CustomFileInput
					image={image}
					fileName={fileName}
					handleChange={handleChange}
					handleDelete={handleDelete}
				/>
				<Button type="submit" sx={submitButtonStyle} isDisabled={!image}>
					Mint
				</Button>
			</chakra.form>
		</>
	);
};

export default CreateNftForm;
