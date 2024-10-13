#!/bin/bash
# Akmal <makmalarifin25@gmail.com>
#
# Generate a template gnuplot file
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

GNUPLOT=$(which gnuplot)
if [[ ! -x "$GNUPLOT" ]]; then
    echo "You need gnuplot installed to generate graphs"
    exit 1
fi

[[ ! -d $PLOTDIR ]] && mkdir -p $PLOTDIR

[[ ! -d $PDFDIR ]] && mkdir -p $PDFDIR

TARGET="$1"

STYLE=
XRANGE=
YRANGE=
XLABEL=
YLABEL=
YGRID=
XTICS=
OUTPUT=
KEY=

TITLE=
STYLE="set style fill solid border .7"
XRANGE="set xrange[-1:]"
YRANGE="set yrange[0:]"
XLABEL="set xlabel \"Amalan Yaumi\\n\""
YLABEL="set ylabel \"Persentase\""
YGRID="set grid ytics lt 2 lc rgb \"gray\" lw 1"
KEY="set key bmargin center horizontal"
X="1"
Y="xtic(2)"

TERM="set term pdf"
OUTPUT=
# SIZE="set size 2,1.5"
SIZE="set size 1,1"
PLOT="plot \\"

declare -a rgbcolors=(\"gray\" \"green\" \"blue\" \"magenta\" \"orange\" \
                    \"cyan\" \"yellow\" \"purple\" \"pink\" \"red\")

nbcolors=${#rgbcolors[@]}

function getCI()
{
    local datfname=$1
    echo $(basename $datfname | gawk -F"_" '{print $1}')
}

function getLT()
{
    local rawfname=$1
    echo $(basename $rawfname | gawk -F"_" '{print $2}')
}

# given file name and line titile, get the plot command
# $1: dat file name
# $2: line title, from getLT()
# $3: color index, [0..nbcolors]
# $4: total # of dat files, make sure color red is used for the last file
function plotone()
{
    local datfname=$1
    local LT=$2
    local CI=$3
    local nbdatfiles=$4
    local MAXCI=$(($nbdatfiles - 1))
    if [[ $CI == $MAXCI ]]; then # last will always red
        CI=$(( $nbcolors-1 ))
    elif [[ $CI -gt $nbcolors ]]; then
        CI=$(( $CI % $nbcolors + 1))
    fi
    echo "'$datfname' u $X:$Y t \"$LT\" w hist lc rgb ${rgbcolors[$CI]} lw 2, \\"
}

function genplot()
{
    # we are picky about colors, so be careful about the ordering

    nbfiles=$(ls -l "dat/${1}/"*.dat | wc -l)

    # write plot file
    {
        echo "${TERM}"
        echo "${TITLE}"
        echo "${OUTPUT}"
        echo "${SIZE}"
        echo "${KEY}"
        echo "${STYLE}"
        echo "${XRANGE}"
        echo "${YRANGE}"
        echo "${XLABEL}"
        echo "${YLABEL}"
        echo "${YGRID}"
        echo "${XTICS}"

        # settings should come before this line
        echo "${PLOT}"
        
        cnt=0
        for j in dat/"${1}"/*.dat; do
            IFS="/"
            read -a temp <<< "${j}"
            IFS="."
            read -a temp <<< "${temp[2]}"
            LT=$(getLT $temp)
            plotone "${j}" $LT $cnt $nbfiles
            ((cnt += 1))
        done
    } > "$PLOTDIR/${1}.plot"
}


for i in dat/*; do
    IFS='/'
    read -a temp <<< "${i}"
    TITLE="set title \"${temp[1]}\""
    OUTPUT="set output \""pdf/${temp[1]}/${TARGET}".pdf\""
    if [ ! -d "$PDFDIR/${temp[1]}" ]; then
        mkdir -p "$PDFDIR/${temp[1]}"
    fi
    genplot "${temp[1]}"

done

echo "==== genplot done ===="
