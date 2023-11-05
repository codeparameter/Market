import { ethers, provider, signer } from "../../ethers";
import { abi } from "./abi.js";

const address = "0x31B45869B743996E35D26c7f3bbacF1f36b73574";
const market = new ethers.Contract(address, abi, provider);

export {market};