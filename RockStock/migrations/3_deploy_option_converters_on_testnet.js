require('babel-register');

const ESOP = artifacts.require("ESOP");
const ProceedsOptionsConverter = artifacts.require("ProceedsOptionsConverter");
const ERC20OptionsConverter = artifacts.require("ERC20OptionsConverter");


module.exports = function (deployer, network, accounts) {
    // do not deploy options converters on mainnet
	
    if (network === 'test') {
        deployer.then(async function () {
let year_ahead = Math.floor(new Date() / 1000) + 365 * 24 * 60 * 60;
                       deployer.logger.log(`conversion deadline is ${year_ahead}`);
            await deployer.deploy(ERC20OptionsConverter.address, ESOP.address, year_ahead);
            await deployer.deploy(ProceedsOptionsConverter, ESOP.address, year_ahead);

        });
    }
};
