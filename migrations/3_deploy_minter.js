const MinterContract = artifacts.require("MinterContract");

module.exports = function (deployer) {
  deployer.deploy(MinterContract, "0x40d5eC2471644BAe9aa2389B91196d41befeCB81");
};

// truffle migrate -f 3 --to 3, to migrate this specific files