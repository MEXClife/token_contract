
compile:
	truffle compile

init:
	npm install

migrate:
	truffle migrate --network development

migrate-live:
	truffle migrate --network live

rpc:
	testrpc --port 7545 -u 0

test: compile
	truffle test

