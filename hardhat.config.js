require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.27",
  networks: {
    ganache: {
      url: "http://127.0.0.1:7545",
      accounts: [
        "0x9526085eba52e2840ee2eaebfb69c5768a8d9ee8fa992935feaee3df82d54d52",
        "0x5951fc81626550ec0e044259df5b00d8dad3c9720de3c1d3b0a8e1346bc37b92",
      ],
      chainId: 1337,
    },
  },
};
