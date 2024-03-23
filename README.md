## Alfred-contract

**Alfred automates position management in lending protocols, no smart contracts or manual transactions needed. Users maintain specific health rates easily through our intuitive interface.**

The delegatee contract guarantees that all the actions performed by Alfred is permitted by the task signed by the user. Delegatee interact with [Protocolink](https://protocolink.com/) system to achieve flexible and secure operations.

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Deploy

```shell
$ forge script --broadcast \
--rpc-url <RPC-URL> \
--private-key <PRIVATE-KEY> \
--sig 'run()' \
script/Deploy<NETWORK>.s.sol:Deploy<NETWORK> \
--chain-id <CHAIN-ID> \
--etherscan-api-key <ETHERSCAN-API-KEY> \
--verify \
--slow \
--legacy \
--with-gas-price <GAS-IN-WEI>
```