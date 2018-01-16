# EMX Token Contract

EMX is set to democratize the USD 6.8 billion dollars Emergency and Medical Services (EMS) industry by offering EMX Token sale for the public to participate in this industry.

EMS industry is a huge market, and pretty much controlled by a few group of companies, as all products sold are copyrighted, and patented. EMS industry can be categorized into 7 (seven) categories:
- Infection Control
- Cardiac and Respiratory
- Transportation Equipment
- Diagnostics
- Trauma and Burn Care
- Blood and Haemorrhage Control
- Hypothermia Prevention

# Our Products

We have 22 patent-pending products that are already being use in the market. These products are the results of our 20 years of Research and Development, thoroughly tested in EMS facilities and hospitals. We also have 6 industrial designs, and 5 copyrights that can be monetize further through EMX eco-system.

# EMX Token

EMX Token is set to be a de-facto standard token in EMS industry. All our products and services are priced in MX, which is an internal token that is pegged to USD dollar. Convertion from EMX to MX can be done via MX P2P Exchanger, where EMX token holders can cash-out via bank transfer to the buyers of MX.

All transactions are one via Ethereum Smart Contract.

# Compiling and Running
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
