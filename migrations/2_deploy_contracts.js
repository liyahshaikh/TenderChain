const Tender = artifacts.require("Tender");

module.exports = function (deployer) {
    deployer.deploy(Tender);
};
