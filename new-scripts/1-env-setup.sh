#!/bin/bash
set -eu -o pipefail

echo "[*] Removing any existing Geth/Bootnode/Golang/Constellation/Porosity/Quorum folders [*]"
rm -rf /usr/local/bin/geth
rm -rf /usr/local/bin/bootnode
rm -rf /usr/local/go
rm -rf /usr/local/bin/constellation-node
rm -rf /usr/local/bin/porosity
rm -rf quorum
rm -rf constellation*
rm -rf golang*

#1. Install build deps
echo "[*] Installing build dependencies [*]"
echo  | add-apt-repository ppa:ethereum/ethereum
apt-get update
apt-get install -y build-essential unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk

#2. Download & Install Constellation
echo "[*] Downloading and Installing Constellation [*]"
CVER="0.2.0"
CREL="constellation-$CVER-ubuntu1604"
wget -q https://github.com/jpmorganchase/constellation/releases/download/v$CVER/$CREL.tar.xz
tar xfJ $CREL.tar.xz
cp $CREL/constellation-node /usr/local/bin && chmod 0755 /usr/local/bin/constellation-node
rm -rf $CREL*

#3. Download & Install Golang
echo "[*] Downloading and Installing Golang [*]"
GOREL=go1.9.3.linux-amd64.tar.gz
wget -q https://dl.google.com/go/$GOREL
tar xfz $GOREL
mv go /usr/local/go
rm -f $GOREL
PATH=$PATH:/usr/local/go/bin
echo 'PATH=$PATH:/usr/local/go/bin' >> /home/dranz3r/.bashrc
rm -rf $GOREL

#4. Download & Install Quorum
echo "[*] Downloading and Installing Quorum [*]"
git clone https://github.com/jpmorganchase/quorum.git
pushd quorum >/dev/null
git checkout tags/v2.0.0
make all
cp build/bin/geth /usr/local/bin
cp build/bin/bootnode /usr/local/bin
popd >/dev/null


#5. Download & Install Porosity
echo "[*] Downloading and Installing Porosity [*]"
wget -q https://github.com/jpmorganchase/quorum/releases/download/v1.2.0/porosity
mv porosity /usr/local/bin && chmod 0755 /usr/local/bin/porosity


#6. Clean up raft$i and Qdata directories
echo "[*] Removing any existing Raft/Qdata folders and passwords[*]"
rm -rf raft*
rm -rf qdata
rm -rf password*

#7. Create qdata/logs directory
echo "[*] Creating logs folder in Qdata [*]"
mkdir -p qdata/logs

#8. For each node:
for i in {1..7}
do
	#9a. Create 7 password files, genesis.json file
	echo "$i. [*] Creating new password [*]"
	echo password$i > password-file-$i.txt
	#9b. Create raft$i, qdata/node$i/keystore, qdata/node$i/geth, qdata/c$i directories.
	echo "$i. [*] Creating raft, node/keystore, node/geth, qdata/constellation directories [*]"
	mkdir -p raft$i qdata/node$i/{keystore,geth} qdata/c$i/keystore
	#9c. Create geth node config in qdata/node$i/geth.
	echo "$i. [*] Creating Geth Config and Logging in raft$i directory's Setup.log file [*]"
	nohup geth --datadir raft$i 2>> raft$i/setup.log &
	#9d. Add data to raft$i/static-nodes.json.
	echo "$i. [*] Adding data to Raft -> static-nodes.json file. Update this file with ./2-node-copy.sh before running Constellation & Geth  [*]"
	sleep 3
	echo "[\"$(cat raft$i/setup.log | grep -oEim 1 '(enode.*@)')127.0.0.1:2100$i?discport=0&raftport=2300$i\"]" >> raft$i/static-nodes.json 
	#9e. Create a new Ethereum account with passwords as password-file$i.txt.
	echo "$i. [*] Creating default ethereum account for Node $i[*]"
	geth --datadir raft$i --password password-file-$i.txt account new
	#9f. Stop all geth actions. 
	echo "$i. [*] Stopping geth [*]"
	killall geth
	#9g. Generate Constellation Keys (--generatekeys = constellation_node_$i) for each in qdata/c$i/keystore. 
	echo "$i. [*] Generating Constellation Keys for Node $i [*]"	
	cd raft$i
	constellation-node --generatekeys=constellation_node_$i
	cd ..
	sleep 3	
#close loop for Step #8
done

killall constellation-node
