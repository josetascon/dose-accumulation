#!/bin/bash
# @Author: Jose Tascon
# @Date:   2020-04-17 15:58:54
# @Last Modified by:   Jose Tascon
# @Last Modified time: 2021-10-12 23:10:06

############################################################
# Help                                                     #
############################################################
usage()
{
    # Display Help
    echo "Dose accumulation full pipeline."
    echo
    echo "Syntax: dose_accumulation.sh [-h|v|d] -i input -o output -m <method-name> [option -n <int>]"
    echo "options:"
    echo "i     Input folder with images and doses"
    echo "o     Output folder with transformations and accumulation"
    echo "t     Method used in dose summation. Options: affine, ants, elastix"
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
method=""
verbose=false
debug=false
nthreads=16

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hvdi:o:m:n:" option; do
    case $option in
    h) # display Help
        usage
        exit;;
    i) # Input
        input=$OPTARG;;
    o) # Output
        output=$OPTARG;;
    m) # Output
        method=$OPTARG;;
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

if [ "$method" = "" ]; then
    echo "Missing method argument";
    usage
    exit 1;
fi

isint='^[0-9]+$'
if ! [[ $nthreads =~ $isint ]] ; then
    echo "Error: nthreads is not an integer number";
    usage;
    exit 1;
fi

# transforms=/mnt/data/radiotherapy/liver/transforms

# python sum_images.py -v $2/$1/$3 $2/$1/$4

# sum_doses "patient06" ${transforms} "affine_doses_ants" "sum_affine"
# sum_doses "patient06" ${transforms} "warped_doses_ants" "sum_ants"
# sum_doses "patient06" ${transforms} "warped_doses_elastix" "sum_elastix"

opt=""
if [ $debug = true ]; then
    opt="-d ${opt}"
fi

if [ $verbose = true  ]; then
    opt="-v ${opt}"
fi

if [ "$method" = "affine" ]; then
    ./ants_reference_registration.sh -i ${input} -o ${output} ${opt} -a -n ${nthreads}
    ./ants_reference_transform_affine.sh -i ${input} -o ${output} ${opt}
    ./sum_doses.sh -i ${output} -r "affine_doses_ants" -o "sum_ants"
elif [ "$method" = "ants" ]; then
    ./ants_reference_registration.sh -i ${input} -o ${output} ${opt} -n ${nthreads}
    ./ants_reference_transform.sh -i ${input} -o ${output} ${opt}
    ./sum_doses.sh -i ${output} -r "warped_doses_ants" -o "sum_ants"
elif [ "$method" = "elastix" ]; then
    ./elastix_reference_registration.sh -i ${input} -o ${output} ${opt} -n ${nthreads}
    ./elastix_reference_transform.sh -i ${input} -o ${output} ${opt}
    ./sum_doses.sh -i ${output} -r "warped_doses_elastix" -o "sum_elastix"
else
    echo
fi