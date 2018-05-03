This is a repository of code where I wrote a shell script, to deploy on Ubuntu 16.04, the following:
a. Constellation
b. Golang
c. Quorum
d. Porosity
e. Install dependencies for the above



The Steps are as follows:
1. Install build deps 
2. Download & Install Constellation
3. Download & Install Golang
4. Download & Install Quorum
5. Download & Install Porosity
6. Clean up raft$i and Qdata directories
7. Create qdata/logs directory
8. For each node:
	a. Create 7 password files, genesis.json file
	b. Create raft$i, qdata/node$i/keystore, qdata/node$i/geth, qdata/c$i directories.
	c. Create geth node config in qdata/node$i/geth.
	d. Add data to raft$i/static-nodes.json. 
	e. Create a new Ethereum account with passwords as password-file$i.txt.
	f. Stop all geth actions. 
	g. Generate Constellation Keys (--generatekeys = constellation_node_$i) for each in qdata/c$i/keystore. 
9. Edit static-nodes.json file to add all nodes in the same order, copy it over to all raft nodes.
10. For each node, do:
	a. Copy raft$i/keystore/$(sudo ls raft$i/keystore) to qdata/node$i/keystore/acckey
	b. Copy raft$i/geth/nodekey to qdata/node$i/geth/nodekey
	c. Copy raft$i/constellation.pub and constellation.key to qdata/c$i/keystore/
	d. Copy raft$i/static-nodes.json to qdata/node$i/static-nodes.json
	e. Initiate Geth
11. For each node, do:
	a. Initiate Constellation with conf command "constellation-node --url=https://127.0.0.$i:900$i/ --port=900$i --workdir=$DDIR --socket=tm.ipc --publickeys=tm.pub --privatekeys=tm.key 
12. For each node, do
	a. Initiate geth for each node with "geth --datadir qdata/node$i init genesis.json"

	
