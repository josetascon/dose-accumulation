#!/bin/bash
# @Author: Jose Tascon
# @Date:   2020-04-17 15:58:54
# @Last Modified by:   Jose Tascon
# @Last Modified time: 2021-10-11 15:21:37

register_refenced ()
{
    # Argument 1: patient name
    # Argument 2: images folder
    # Argument 3: transform folder
    
    echo;

    # Argument 1: patient name
    # Argument 2: images folder
    # Argument 3: transform folder
    # Argument 4: nthreads;
    # Argument 5: debug
    # Argument 6: verbose
    echo; echo "Referenced Registration with Elastix"
    echo;
    opt=""
    if [ $5 = true ]; then
        opt="-d ${opt}"
    fi

    if [ $6 = true  ]; then
        opt="-v ${opt}"
    fi

    echo "mkdir -p $3/$1/"
    mkdir -p $3/$1/

    cmd="python register_referenced_elastix.py $opt $2/$1/fractions/ $3/$1/ -n $4"
    echo ${cmd}
    echo;
    # ${cmd}
}

############################################################
# Help                                                     #
############################################################
usage()
{
    # Display Help
    echo "Register images to a reference with Elastix."
    echo
    echo "Syntax: elastix_reference_registration.sh [-h|v|d] -i input -o output [option -n <int>]"
    echo "options:"
    echo "i     Input folder with patients image data"
    echo "o     Output folder with transformations"
    echo "n     Number of threads. Default: 16"
    echo "v     Verbose mode."
    echo "d     Debug mode."
    echo "h     Print help."
    echo
}

############################################################
# Main program                                             #
############################################################

# Set variables
input=""
output=""
verbose=false
debug=false
nthreads=16

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hvdi:o:n:" option; do
    case $option in
    h) # display Help
        usage
        exit;;
    i) # Input
        input=$OPTARG;;
    o) # Output
        output=$OPTARG;;
    n) # Output
        nthreads=$OPTARG;;
    v) # Verbose
        verbose=true;;
    d) # Debug
        debug=true;;
    \?) # Invalid option
        echo "Error: Invalid option";
        usage;
        exit;;
    esac
done

if [ "$input" = "" ]; then
    echo "Missing input argument";
    usage
    exit 1;
fi

if [ "$output" = "" ]; then
    echo "Missing output argument";
    usage
    exit 1;
fi

isint='^[0-9]+$'
if ! [[ $nthreads =~ $isint ]] ; then
    echo "Error: nthreads is not an integer number";
    usage;
    exit 1;
fi

echo $nthreads > nthreads.txt

# input=/mnt/data/radiotherapy/liver/images/
# output=/mnt/data/radiotherapy/liver/transforms/
# echo "input: ${input} output: ${output} verbose: ${verbose} debug: ${debug}"

# Run all
for pt in $(ls ${input})
do
    register_refenced ${pt} ${input} ${output} "nthreads.txt" ${debug} ${verbose}
done 