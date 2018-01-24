

let acc0 = web3.eth.accounts[0];
let acc1 = web3.eth.accounts[1];
MEXCrowdsale.deployed().then(inst => { crowdsale = inst });
MEXCToken.deployed().then(inst => { token = inst });

crowdsale.addEarlyBacker(acc1).then(res => { resp = res });
crowdsale.isEarlyBacker(acc1).then(res => { resp = res });
crowdsale.sendTransaction({ from: acc1, value: web3.toWei(1, 'ether') }).then(res => { resp = res });

crowdsale.totalRaised().then(res => { resp = res });

crowdsale.token.call().then(inst => { t = inst });

// minting
// token.mint(acc1, web3.toWei(4000, 'ether'), {from: acc0}).then(res => { resp = res });
token.balanceOf(acc1).then(res => { bal = res });
