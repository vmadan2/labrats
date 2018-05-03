#!/bin/bash
set -eu -o pipefail

echo "[*] Removing any existing Geth/Bootnode/Golang/Constellation/Porosity/Quorum folders [*]"
#rm -rf /usr/local/bin/geth
#rm -rf /usr/local/bin/bootnode
#rm -rf /usr/local/go
#rm -rf /usr/local/bin/constellation-node
#rm -rf /usr/local/bin/porosity
#rm -rf quorum
#rm -rf constellation*
#rm -rf golang*

#1. Install build deps
#echo "[*] Installing build dependencies [*]"
#add-apt-repository ppa:ethereum/ethereum
#apt-get update
#apt-get install -y build-essential unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk

#2. Download & Install Constellation
#echo "[*] Downloading and Installing Constellation [*]"
#CVER="0.3.2"
#CREL="constellation-$CVER-ubuntu1604"
#wget -q https://github.com/jpmorganchase/constellation/releases/download/v$CVER/$CREL.tar.xz
#tar xfJ $CREL.tar.xz
#cp $CREL/constellation-node /usr/local/bin && chmod 0755 /usr/local/bin/constellation-node
#rm -rf $CREL

#3. Download & Install Golang
#echo "[*] Downloading and Installing Golang [*]"
#GOREL=go1.9.3.linux-amd64.tar.gz
#wget -q https://dl.google.com/go/$GOREL
#tar xfz $GOREL
#mv go /usr/local/go
#rm -f $GOREL
#PATH=$PATH:/usr/local/go/bin
#echo 'PATH=$PATH:/usr/local/go/bin' >> /home/dranz3r/.bashrc

#4. Download & Install Quorum
#echo "[*] Downloading and Installing Quorum [*]"
#git clone https://github.com/jpmorganchase/quorum.git
#pushd quorum >/dev/null
#git checkout tags/v2.0.1
#make all
#cp build/bin/geth /usr/local/bin
#cp build/bin/bootnode /usr/local/bin
#popd >/dev/null


#5. Download & Install Porosity
#echo "[*] Downloading and Installing Porosity [*]"
#wget -q https://github.com/jpmorganchase/quorum/releases/download/v1.2.0/porosity
#mv porosity /usr/local/bin && chmod 0755 /usr/local/bin/porosity


#6. Clean up raft$i and Qdata directories
echo "[*] Removing any existing Raft/Qdata folders and passwords[*]"
rm -rf raft*
rm -rf qdata
rm -rf password*

#7. Create qdata/logs directory
echo "[*] Creating logs folder in Qdata [*]"
mkdir qdata
mkdir qdata/logs

	#9a. Create 7 password files, genesis.json file
	echo "1. [*] Creating new password [*]"
	echo password1 > password-file-1.txt
	#9b. Create raft$i, qdata/node$i/keystore, qdata/node$i/geth, qdata/c$i directories.
	echo "1. [*] Creating raft, node/keystore, node/geth, qdata/constellation directories [*]"
	mkdir -p raft1 qdata/node1/{keystore,geth} qdata/c1/keystore raft2 qdata/node2/{keystore,geth} qdata/c2/keystore raft3 qdata/node3/{keystore,geth} qdata/c3/keystore raft4 qdata/node4/{keystore,geth} qdata/c4/keystore raft5 qdata/node5/{keystore,geth} qdata/c5/keystore raft6 qdata/node6/{keystore,geth} qdata/c6/keystore raft7 qdata/node7/{keystore,geth} qdata/c7/keystore
	#9c. Create geth node config in qdata/node$i/geth.
	#echo "1. [*] Initiating Geth and Logging in raft1 directory's Setup.log file [*]"
	#nohup geth --datadir raft1 2>> raft1/setup.log &
	#9d. Add data to raft$i/static-nodes.json.
	echo "1. [*] Adding data to Raft -> static-nodes.json file. Update this file before running Constellation & Geth  [*]"
	sleep 3
	echo "[\"$(cat raft1/setup.log | grep -oEim 1 '(enode.*@)')127.0.0.1:21001?discport=0&raftport=23001\"]" >> raft1/static-nodes.json 
	#9e. Create a new Ethereum account with passwords as password-file$i.txt.
	echo "1. [*] Creating default ethereum account for Node 1 [*]"
	geth --datadir raft1 --password password-file-1.txt account new
	#9f. Stop all geth actions. 
	echo "1. [*] Stopping geth [*]"
	killall geth
	#9g. Generate Constellation Keys (--generatekeys = constellation_node_$i) for each in qdata/c$i/keystore. 
	echo "1. [*] Generating Constellation Keys for Node 1 [*]"	
	cd raft1
	constellation-node --generatekeys=constellation_node_1
	cd ..
	sleep 3	



	#9a. Create 7 password files, genesis.json file
	echo "2. [*] Creating new password [*]"
	echo password2 > password-file-2.txt
	#9b. Create raft$i, qdata/node$i/keystore, qdata/node$i/geth, qdata/c$i directories.
	echo "2. [*] Creating raft, node/keystore, node/geth, qdata/constellation directories [*]"
	#mkdir -p raft2 qdata/node2/{keystore,geth} qdata/c2/keystore
	#9c. Create geth node config in qdata/node$i/geth.
	#echo "2. [*] Initiating Geth and Logging in raft2 directory's Setup.log file [*]"
	#nohup geth --datadir raft2 2>> raft2/setup.log &
	#9d. Add data to raft$i/static-nodes.json.
	echo "2. [*] Adding data to Raft -> static-nodes.json file. Update this file before running Constellation & Geth  [*]"
	sleep 3
	echo "[\"$(cat raft2/setup.log | grep -oEim 1 '(enode.*@)')127.0.0.1:21002?discport=0&raftport=23002\"]" >> raft2/static-nodes.json 
	#9e. Create a new Ethereum account with passwords as password-file$i.txt.
	echo "2. [*] Creating default ethereum account for Node 2[*]"
	geth --datadir raft2 --password password-file-2.txt account new
	#9f. Stop all geth actions. 
	echo "2. [*] Stopping geth [*]"
	killall geth
	#9g. Generate Constellation Keys (--generatekeys = constellation_node_$i) for each in qdata/c$i/keystore. 
	echo "2. [*] Generating Constellation Keys for Node 2 [*]"	
	cd raft2
	constellation-node --generatekeys=constellation_node_2
	cd ..
	sleep 3	



	#9a. Create 7 password files, genesis.json file
	echo "3. [*] Creating new password [*]"
	echo password3 > password-file-3.txt
	#9b. Create raft$i, qdata/node$i/keystore, qdata/node$i/geth, qdata/c$i directories.
	echo "3. [*] Creating raft, node/keystore, node/geth, qdata/constellation directories [*]"
	#mkdir -p raft3 qdata/node3/{keystore,geth} qdata/c3/keystore
	#9c. Create geth node config in qdata/node$i/geth.
	echo "3. [*] Initiating Geth and Logging in raft3 directory's Setup.log file [*]"
	nohup geth --datadir raft3 2>> raft3/setup.log &
	#9d. Add data to raft$i/static-nodes.json.
	echo "3. [*] Adding data to Raft -> static-nodes.json file. Update this file before running Constellation & Geth  [*]"
	sleep 3
	echo "[\"$(cat raft3/setup.log | grep -oEim 1 '(enode.*@)')127.0.0.1:21003?discport=0&raftport=23003\"]" >> raft3/static-nodes.json 
	#9e. Create a new Ethereum account with passwords as password-file$i.txt.
	echo "3. [*] Creating default ethereum account for Node 3[*]"
	geth --datadir raft3 --password password-file-3.txt account new
	#9f. Stop all geth actions. 
	echo "3. [*] Stopping geth [*]"
	killall geth
	#9g. Generate Constellation Keys (--generatekeys = constellation_node_$i) for each in qdata/c$i/keystore. 
	echo "3. [*] Generating Constellation Keys for Node 3 [*]"	
	cd raft3
	constellation-node --generatekeys=constellation_node_3
	cd ..
	sleep 3	



	#9a. Create 7 password files, genesis.json file
	echo "4. [*] Creating new password [*]"
	echo password4 > password-file-4.txt
	#9b. Create raft$i, qdata/node$i/keystore, qdata/node$i/geth, qdata/c$i directories.
	echo "4. [*] Creating raft, node/keystore, node/geth, qdata/constellation directories [*]"
	#mkdir -p raft4 qdata/node4/{keystore,geth} qdata/c4/keystore
	#9c. Create geth node config in qdata/node$i/geth.
	echo "4. [*] Initiating Geth and Logging in raft4 directory's Setup.log file [*]"
	nohup geth --datadir raft4 2>> raft4/setup.log &
	#9d. Add data to raft$i/static-nodes.json.
	echo "4. [*] Adding data to Raft -> static-nodes.json file. Update this file before running Constellation & Geth  [*]"
	sleep 3
	echo "[\"$(cat raft4/setup.log | grep -oEim 1 '(enode.*@)')127.0.0.1:21004?discport=0&raftport=23004\"]" >> raft4/static-nodes.json 
	#9e. Create a new Ethereum account with passwords as password-file$i.txt.
	echo "4. [*] Creating default ethereum account for Node 4[*]"
	geth --datadir raft4 --password password-file-4.txt account new
	#9f. Stop all geth actions. 
	echo "4. [*] Stopping geth [*]"
	killall geth
	#9g. Generate Constellation Keys (--generatekeys = constellation_node_$i) for each in qdata/c$i/keystore. 
	echo "4. [*] Generating Constellation Keys for Node 4 [*]"	
	cd raft4
	constellation-node --generatekeys=constellation_node_4
	cd ..
	sleep 3	



	#9a. Create 7 password files, genesis.json file
	echo "5. [*] Creating new password [*]"
	echo password5 > password-file-5.txt
	#9b. Create raft$i, qdata/node$i/keystore, qdata/node$i/geth, qdata/c$i directories.
	echo "5. [*] Creating raft, node/keystore, node/geth, qdata/constellation directories [*]"
	#mkdir -p raft5 qdata/node5/{keystore,geth} qdata/c5/keystore
	#9c. Create geth node config in qdata/node$i/geth.
	echo "5. [*] Initiating Geth and Logging in raft5 directory's Setup.log file [*]"
	nohup geth --datadir raft5 2>> raft5/setup.log &
	#9d. Add data to raft$i/static-nodes.json.
	echo "5. [*] Adding data to Raft -> static-nodes.json file. Update this file before running Constellation & Geth  [*]"
	sleep 3
	echo "[\"$(cat raft5/setup.log | grep -oEim 1 '(enode.*@)')127.0.0.1:21005?discport=0&raftport=23005\"]" >> raft5/static-nodes.json 
	#9e. Create a new Ethereum account with passwords as password-file$i.txt.
	echo "5. [*] Creating default ethereum account for Node 5 [*]"
	geth --datadir raft5 --password password-file-5.txt account new
	#9f. Stop all geth actions. 
	echo "5. [*] Stopping geth [*]"
	killall geth
	#9g. Generate Constellation Keys (--generatekeys = constellation_node_$i) for each in qdata/c$i/keystore. 
	echo "5. [*] Generating Constellation Keys for Node 5 [*]"	
	cd raft5
	constellation-node --generatekeys=constellation_node_5
	cd ..
	sleep 3	



	#9a. Create 7 password files, genesis.json file
	echo "6. [*] Creating new password [*]"
	echo password6 > password-file-6.txt
	#9b. Create raft$i, qdata/node$i/keystore, qdata/node$i/geth, qdata/c$i directories.
	echo "6. [*] Creating raft, node/keystore, node/geth, qdata/constellation directories [*]"
	#mkdir -p raft6 qdata/node6/{keystore,geth} qdata/c6/keystore
	#9c. Create geth node config in qdata/node$i/geth.
	echo "6. [*] Initiating Geth and Logging in raft6 directory's Setup.log file [*]"
	nohup geth --datadir raft6 2>> raft6/setup.log &
	#9d. Add data to raft$i/static-nodes.json.
	echo "6. [*] Adding data to Raft -> static-nodes.json file. Update this file before running Constellation & Geth  [*]"
	sleep 3
	echo "[\"$(cat raft6/setup.log | grep -oEim 1 '(enode.*@)')127.0.0.1:21006?discport=0&raftport=23006\"]" >> raft6/static-nodes.json 
	#9e. Create a new Ethereum account with passwords as password-file$i.txt.
	echo "6. [*] Creating default ethereum account for Node 6 [*]"
	geth --datadir raft6 --password password-file-6.txt account new
	#9f. Stop all geth actions. 
	echo "6. [*] Stopping geth [*]"
	killall geth
	#9g. Generate Constellation Keys (--generatekeys = constellation_node_$i) for each in qdata/c$i/keystore. 
	echo "6. [*] Generating Constellation Keys for Node 6 [*]"	
	cd raft6
	constellation-node --generatekeys=constellation_node_6
	sleep 3	


	#9a. Create 7 password files, genesis.json file
	echo "7. [*] Creating new password [*]"
	echo password7 > password-file-7.txt
	#9b. Create raft$i, qdata/node$i/keystore, qdata/node$i/geth, qdata/c$i directories.
	echo "7. [*] Creating raft, node/keystore, node/geth, qdata/constellation directories [*]"
	#mkdir -p raft7 qdata/node7/{keystore,geth} qdata/c7/keystore
	#9c. Create geth node config in qdata/node$i/geth.
	echo "7. [*] Initiating Geth and Logging in raft7 directory's Setup.log file [*]"
	nohup geth --datadir raft7 2>> raft7/setup.log &
	#9d. Add data to raft$i/static-nodes.json.
	echo "7. [*] Adding data to Raft -> static-nodes.json file. Update this file before running Constellation & Geth  [*]"
	sleep 3
	echo "[\"$(cat raft7/setup.log | grep -oEim 1 '(enode.*@)')127.0.0.1:21007?discport=0&raftport=23007\"]" >> raft7/static-nodes.json 
	#9e. Create a new Ethereum account with passwords as password-file$i.txt.
	echo "7. [*] Creating default ethereum account for Node 7 [*]"
	geth --datadir raft7 --password password-file-7.txt account new
	#9f. Stop all geth actions. 
	echo "7. [*] Stopping geth [*]"
	killall geth
	#9g. Generate Constellation Keys (--generatekeys = constellation_node_$i) for each in qdata/c$i/keystore. 
	echo "7. [*] Generating Constellation Keys for Node 7 [*]"	
	cd raft7
	constellation-node --generatekeys=constellation_node_7
	sleep 3	

