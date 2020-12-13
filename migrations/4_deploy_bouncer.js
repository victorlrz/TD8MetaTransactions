const BouncerProxy = artifacts.require("BouncerProxy");

module.exports = function (deployer) {
  deployer.deploy(BouncerProxy);
};

// truffle migrate -f 4 --to 4, to migrate this specific files