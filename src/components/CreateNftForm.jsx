import { useState } from "react";
import { Button, chakra } from "@chakra-ui/react";
import CustomFileInput from "./common/CustomFileInput";
import { useNavigate } from "react-router-dom";

const submitButtonStyle = { bg: "cyan.700", color: "white", w: "full" };

const CreateNftForm = () => {
	const [image, setImage] = useState(null);
	const [fileName, setFileName] = useState("No selected file");
  const nav = useNavigate()

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

  const handleSubmit = (e) => {
    e.preventDefault()
    // const nftId = await fetch()
    // nav(`/ntf/${nftId}`)
  }

	return (
		<chakra.form sx={{ w: "400px", m: "2rem auto" }}>
			<CustomFileInput
				image={image}
				fileName={fileName}
				handleChange={handleChange}
				handleDelete={handleDelete}
			/>
			<Button type="submit" sx={submitButtonStyle}>
				Mint
			</Button>
		</chakra.form>
	);
};

export default CreateNftForm;
