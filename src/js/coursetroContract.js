import { ethers, provider, signer } from "./ethers.js";
import { abi } from "./abi.js";

const coursetroContract = async () => {
    const address = "0x31B45869B743996E35D26c7f3bbacF1f36b73574";
    const contract = new ethers.Contract(address, abi, provider);
    // const props = await contract.getInstructor();
    console.log(contract);
    // console.log(props[0]);
    // console.log(props[1].toString());
    // $("#instructor").html(props[0] + ' (' + props[1] + ' years old)');

    const contractWithWallet = contract.connect(signer);

    // $("#button").click(function () {
    //     contractWithWallet.setInstructor($("#name").val(), $("#age").val());
    // });
};

export {coursetroContract};