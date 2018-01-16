# EMX Token Contract

## Preparations

Install the needed components:
- Truffle
- Test RPC

```
$ npm install -g ethereumjs-testrpc
$ npm install -g truffle
```

## Add Node modules
initialize all node components by doing node install
```
$ npm install
```

## Compile

Compiling can be done as:
```
$ truffle compile
```

## Migrate the Contracts

To migrate the contract, run test RPC and do truffle migrate
```
$ testrpc -u 0
$ truffle migrate
```
