#!/bin/bash
# Akmal <makmalarifin25@gmail.com>
#
# clear all data except in raw folder
#

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    TOPDIR="$( cd -P "$(dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$TOPDIR/$SOURCE"
done

TOPDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )/.."
RAWDIR=$TOPDIR/raw
DATDIR=$TOPDIR/dat
PLOTDIR=$TOPDIR/plot
PDFDIR=$TOPDIR/pdf
SCRIPTDIR=$TOPDIR/script

##############################################################################
# input=$1

# if [[ $# != 1 ]]; then
#     echo ""
#     echo "Usage: ./clear.sh directory-entry"
#     echo ""
#     exit
# fi

echo "Please confirm you want to delete all entries! Type anything .."
read x

# if [[ -e raw/$input ]]; then
#     rm -rf raw/$input
# fi

# if [[ -e dat/$input ]]; then
#     rm -rf dat/$input
# fi

# if [[ -e plot/${input}.plot ]]; then
#     rm -rf plot/${input}.plot
# fi

# if [[ -e pdf/${input}.pdf ]]; then
#     rm -rf pdf/${input}.pdf
# fi

# rm -rf raw/*
rm -rf dat/*
rm -rf plot/*
rm -rf pdf/*

echo "Done!"


