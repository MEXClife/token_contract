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

To migrate the contract, run test RPC on a separate console, and do `make`
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
  ... 0x1cb95fca0fed0e69da0339bee98e307c24880366f2752e45e2915e26040af673
  Migrations: 0x0a9a77197ee38f39e2bfddb9df8da44e6f442b83
Saving successful migration to network...
  ... 0x8356ceab873bfd9c7785455b456bbb5be5ee1a9581e20b2f00e6ed7a1b6b0ee5
Saving artifacts...
Running migration: 2_deploy_contracts.js
  Deploying EMXToken...
  ... 0x1e5f2435f6401b87f9dc120febaae64399e46c4cfcd8971209b543b559083049
  EMXToken: 0x6534e701e0577baad7f15cb5acdf4ab94ffd8814
  Deploying EMXCrowdsale...
  ... 0x4caf47f4730e777997c4361cbe947628ad4d19e0e4fc504e41d5cd09a90afaae
  EMXCrowdsale: 0x0f69175d6f9150667d5c77f31833f905f5e0e057
Saving successful migration to network...
  ... 0xdebc20d6b2b31f4863850e17ec10038cbd2ce94460c4bd5d9e88086af1f25266
Saving artifacts...
$
```
