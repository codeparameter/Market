import { ethers, provider, signer, callMethodWithRevert } from "../../ethers";
import { abi } from "./abi.js";

const address = "0x31B45869B743996E35D26c7f3bbacF1f36b73574";
const dealMaker = new ethers.Contract(address, abi, provider);
const dealMakerWithWallet = dealMaker.connect(signer);

// const props = await contract.getInstructor();

const getBuyRequest = async (index) => {
    return await dealMaker.buyRequests(index);
};

const getSellRequest = async (index) => {
    return await dealMaker.sellRequests(index);
};

const submitBuyRequest = async (tokenAmount, weiAmount, tokenAmount, allAtOnce) => {
    await callMethodWithRevert(dealMakerWithWallet.submitBuyRequest, weiAmount, tokenAmount, allAtOnce);
};

const submitSellRequest = async (tokenAmount, weiAmount, tokenAmount, allAtOnce) => {
    await callMethodWithRevert(dealMakerWithWallet.submitSellRequest, 0, tokenAmount, weiAmount, allAtOnce);
};

export {dealMaker, submitBuyRequest, submitSellRequest, getBuyRequest, getSellRequest};