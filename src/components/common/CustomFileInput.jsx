import { Box, Icon, Text, chakra } from "@chakra-ui/react";
import { useRef } from "react";
import { MdDelete, MdCloudUpload } from "react-icons/md";

const imgFormStyle = {
	display: "grid",
	placeContent: "center",
	border: "1px",
	borderColor: "teal.500",
	borderRadius: "8px",
	w: "full",
	aspectRatio: "1",
	cursor: "pointer"
};

const CustomFileInput = ({ image, fileName, handleChange, handleDelete }) => {
	const hiddenFileInput = useRef();
	const handleClick = () => hiddenFileInput.current.click();

	return (
		<>
			<Box onClick={handleClick} sx={imgFormStyle}>
				<input
					type="file"
					accept="image/*"
					hidden
					ref={hiddenFileInput}
					onChange={handleChange}
				/>

				{image ? (
					<chakra.img src={image} w="full" h="full" alt={fileName} />
				) : (
					<>
						<Icon
							as={MdCloudUpload}
							sx={{ w: "40", h: "40", color: "teal.500" }}
						/>
						<Text>Browse Files to upload</Text>
					</>
				)}
			</Box>

			<Box sx={{ my: "1rem", display: "flex", alignItems: "center" }}>
				{fileName} -
				<Icon
					as={MdDelete}
					onClick={handleDelete}
					sx={{ color: "red", w: "5", h: "5", cursor: "pointer" }}
				/>
			</Box>
		</>
	);
};

export default CustomFileInput;
