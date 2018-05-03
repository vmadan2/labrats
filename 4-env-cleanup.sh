#!/bin/bash
killall geth bootnode constellation-node

CVER="0.3.2"
CREL="constellation-$CVER-ubuntu1604"
GOREL=go1.9.3.linux-amd64.tar.gz

echo "[*] Removing any existing Geth/Bootnode/Golang/Constellation/Porosity/Quorum folders [*]"
rm -rf /usr/local/bin/geth
rm -rf /usr/local/bin/bootnode
rm -rf /usr/local/go
rm -rf /usr/local/bin/constellation-node
rm -rf /usr/local/bin/porosity
rm -rf quorum
rm -rf constellation*
rm -rf $CREL*
rm -rf $GOREL

rm -rf raft*
rm -rf qdata
rm -rf password*

rm -rf storage*
rm -rf *.out
