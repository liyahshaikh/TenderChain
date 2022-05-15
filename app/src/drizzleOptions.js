import Web3 from "web3";
import Tender from "./contracts/Tender.json";
// import SimpleStorage from "./contracts/SimpleStorage.json";
// import TutorialToken from "./contracts/TutorialToken.json";

const options = {
    web3: {
        block: false,
        customProvider: new Web3("ws://localhost:8545"),
    },
    contracts: [Tender],
    events: {
        SimpleStorage: ["StorageSet"],
    },
};

export default options;
