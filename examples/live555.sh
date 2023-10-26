#!/bin/bash

set -euo pipefail

git clone https://github.com/cozy131/live555.git --branch snapfuzz live555
cd live555
mkdir tmp
export SUBJECT=$PWD; export TMP_DIR=$PWD/tmp

# changing for your environment
export AFLGO=$HOME/fuzzingtool/SnapFuzz-artefact/builds/aflgo

# changing for your environment
echo "MPEG1or2Demux.cpp:129" > $TMP_DIR/BBtargets.txt

./genMakefiles linux1
make -j clean all
cat $TMP_DIR/BBnames.txt | rev | cut -d: -f2- | rev | sort | uniq > $TMP_DIR/BBnames2.txt && mv $TMP_DIR/BBnames2.txt $TMP_DIR/BBnames.txt
cat $TMP_DIR/BBcalls.txt | sort | uniq > $TMP_DIR/BBcalls2.txt && mv $TMP_DIR/BBcalls2.txt $TMP_DIR/BBcalls.txt

$AFLGO/distance/gen_distance_fast.py ./testProgs/ $TMP_DIR 

./genMakefiles linux2
make -j clean all

# changing for your environment
export SNAPFUZZ=$HOME/fuzzingtool/SnapFuzz-artefact
cp ./testProgs/testOnDemandRTSPServer "${SNAPFUZZ}/testOnDemandRTSPServer"