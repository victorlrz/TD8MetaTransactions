const ERC20Token = artifacts.require("ERC20Token");

module.exports = function (deployer) {
  deployer.deploy(ERC20Token);
};

// truffle migrate -f 5 --to 5, to migrate this specific files