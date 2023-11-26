#!/bin/bash
# Akmal <makmalarifin25@gmail.com>
# Process raw experimental data from fio into a graph in one shot

# resolve the correct absolute path
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    TOPDIR="$( cd -P "$(dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$TOPDIR/$SOURCE"
done

TOPDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
RAWDIR=$TOPDIR/raw
DATDIR=$TOPDIR/dat
PLOTDIR=$TOPDIR/plot
PDFDIR=$TOPDIR/pdf
SCRIPTDIR=$TOPDIR/script

# Set TARGET to the experiment folder (the subfolder under raw/)
TARGET=$1

# Supported type of DATA & GRAPH:
# line : Line graph
# -- lat-time   : Latency (Y-axis) vs Time (X-axis)
# -- iops-time  : IOPS (Y-axis) vs Time (X-axis)
# -- bw-time    : Bandwidth (Y-axis) vs Time (X-axis)
# -- lat-cdf    : Latency CDF graph

# hist : Histograph
# -- iops-numjobs   : IOPS (Y-axis) vs Numjobs (X-axis)
# -- lat-numjobs    : Latency (Y-axis) vs Numjobs (X-axis)
# GRAPH=$2
# DATA=$3

if [[ $# != 1 ]]; then
    echo "Usage: please read comment in all.sh"
    exit 1
fi

# generate dat file from raw
# $SCRIPTDIR/raw2dat.sh $TARGET $GRAPH $DATA
python $SCRIPTDIR/raw2dat.py $TARGET

# generate plot file from dat
$SCRIPTDIR/genplot.sh $TARGET

# plot the graph
for i in $PLOTDIR/*.plot; do
    gnuplot "${i}"
done

# python $SCRIPTDIR/getter.py $TARGET