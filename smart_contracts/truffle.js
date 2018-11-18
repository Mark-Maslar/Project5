/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a 
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() { 
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>') 
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */

// module.exports = {
//   // See <http://truffleframework.com/docs/advanced/configuration>
//   // to customize your Truffle configuration!
//   networks: {
//     development: {
//       host: "localhost",
//       port: 7545,
//       network_id: "*" // Match any network id
//     }
//   }
// };

var HDWalletProvider = require('truffle-hdwallet-provider');

var mnemonic = 'orient green refuse wasp dish web chuckle cost focus feel evidence among';

module.exports = {
  networks: { 
    development: {
      host: '127.0.0.1',
      port: 7545,
      network_id: "*"
    }, 
    rinkeby: {
      host: '127.0.0.1',
      port: 7545,
      network_id: 4,
      gas: 4612388, // Gas limit used for deploys
      gasPrice: 10000000000
    },    
    infura: {
      provider: function() { 
        return new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/264f01bf45314faf85b0a07e9fa170c5') 
      },
      network_id: 4,
      gas: 4612388,
      gasPrice: 100000000000,
    }
  }
};