#!/bin/bash
# Akmal <makmalarifin25@gmail.com>
# Process raw amalan yaumi data from csv into a pdf graph in one shot

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

# Set TARGET to the csv file that want to be created
# Please use the format {ORDERNUMBER}_{MONTH}.csv
# Example: 1_Januari.csv
TARGET=$1

if [[ $# != 1 ]]; then
    echo "Usage: please read comment in all.sh"
    exit 1
fi

# generate dat file from raw
python "$SCRIPTDIR/raw2dat.py" $TARGET

# generate plot file from dat
"$SCRIPTDIR/genplot.sh" $TARGET

# plot the graph
for i in "$PLOTDIR/"*.plot; do
    gnuplot "${i}"
done

# generate pdf
python "$SCRIPTDIR/getter.py" pdf $TARGET

echo "==== generate pdf done ===="