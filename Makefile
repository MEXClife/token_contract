
compile:
	truffle compile

init:
	npm install

clean:
	truffle networks --clean
	rm -rf ./build

reset: clean
	truffle migrate --reset

migrate:
	truffle migrate --network development

migrate-live:
	truffle migrate --network live

rpc:
	testrpc --port 7545 -u 0 --gas 9712388

test: compile
	truffle test --network development

console:
	truffle console --network development
