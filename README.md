# Use our project!
[Link](https://xpay-ui.vercel.app/)

# Related Repos: 
[xpay-api repo](https://github.com/cucupac/xpay-api)

[xpay-ui repo](https://github.com/rahul0eth/xpay-ui)

# Interact with many chains in one click through xPay:
Deployed 14 multi-chain contracts on 4 chains - 
[Gnosis Chain Contracts](https://gnosisscan.io/address/0x7a5717F0B8cAFD96821f419150C4966612FFbbAC#internaltx), 
[Arbitrum Contracts](https://testnet.arbiscan.io/address/0x7a5717F0B8cAFD96821f419150C4966612FFbbAC#internaltx), 
[Celo Contracts](https://explorer.celo.org/mainnet/address/0x7a5717F0B8cAFD96821f419150C4966612FFbbAC/internal-transactions#address-tabs), and
[Base Contracts](https://goerli.basescan.org/address/0x7a5717F0B8cAFD96821f419150C4966612FFbbAC#internaltx), each in one click!

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
