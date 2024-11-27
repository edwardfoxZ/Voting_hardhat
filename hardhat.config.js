require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.27",
  networks: {
    ganache: {
      url: "http://127.0.0.1:7545",
      accounts: [
        "0xa02b5da68d922b47926cb282821de0aaa513ce03e527fc136fa48f897a6ba095",
        "0xa2296fab83c30529df3b2e9c3ec53a18c635e61d294503a9f6906d60e551a859",
      ],
      chainId: 1337,
    },
  },
};
