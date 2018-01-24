# MEXC Token Contract

MEXC is set to democratize the USD 6.8 billion dollars Emergency and Medical Services (EMS) industry by offering MEXC Token sale for the public to participate in this industry.

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

# MEXC Token

MEXC Token is set to be a de-facto standard token in EMS industry. All our products and services are priced in MX, which is an internal token that is pegged to USD dollar. Convertion from MEXC to MX can be done via MX P2P Exchanger, where MEXC token holders can cash-out via bank transfer to the buyers of MX.

All transactions are done via Ethereum Smart Contract.

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
$ make init
```

## Compile

Compiling can be done as:
```
$ make
```

## Migrate the Contracts

To migrate the contract, run test RPC on a separate console, and do `make rpc`. Then run `make migrate` to migrate the contracts to the development network.
```
$ make rpc
$ make migrate
```

You should see something similar to below:
```
$ make migrate
truffle migrate --network development
Using network 'development'.

Running migration: 1_initial_migration.js
  Deploying Migrations...
  ... 0x77e33af1d950541c869e42d92dd631e1273cba37d4acce77b7c97afb8a98ce2d
  Migrations: 0xbf87b082b6ad2863e4d6bd980c87ebc584c81901
Saving successful migration to network...
  ... 0xf4d021eceba6df3d8b4334b7d9719a573b0f4bf67c5b9c0c614a4bccc6e2e8ab
Saving artifacts...
Running migration: 2_deploy_contracts.js
  Deploying MEXCToken...
  ... 0x94d275fb12d8ab2a2e1a74f0edbb35e673bae83a895520bcb5056feb7f68729b
  MEXCToken: 0xbb2edd737da84bfe9befc63da5aa7cfb5b6725b2
  Deploying MEXCrowdsale...
  ... 0x541bb7d3c989d5861917d4a3e778d45a0ff52df83eda344a1b5b0f45e229600d
  MEXCrowdsale: 0x303f4c9668033b9eba43bdeb1ca1f1928cc9fce1
Saving successful migration to network...
  ... 0x79b713cbea0c255bc46cc64f7c71544ee067c1d58cc191e72547a64062883b9d
Saving artifacts...
$
```
