#!/bin/bash
# @Author: Jose Tascon
# @Date:   2020-04-17 15:58:54
# @Last Modified by:   Jose Tascon
# @Last Modified time: 2021-10-12 21:42:23

transform_referenced ()
{
    # Argument 1: patient name
    # Argument 2: images folder
    # Argument 3: transform folder
    # Argument 4: debug
    # Argument 5: verbose
    echo; echo "Transform with ANTS"
    echo;

    opt=""
    if [ $4 = true ]; then
        opt="-d ${opt}"
    fi

    if [ $5 = true  ]; then
        opt="-v ${opt}"
    fi

    cmd="python transform_referenced_ants_affine.py ${opt} $2/$1/fractions/$1_fraction00.nrrd \
        $2/$1/doses/ $3/$1/ants/ $3/$1/"
    echo ${cmd}
    echo;
    ${cmd}
}

############################################################
# Help                                                     #
############################################################
usage()
{
    # Display Help
    echo "Transform images with affine transforms to a reference using ANTS."
    echo
    echo "Syntax: ants_reference_transform_affine.sh [-h|v|d] -i input -o output"
    echo "options:"
    echo "i     Input folder with patients image data"
    echo "o     Output folder with transformations"
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

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hvdi:o:" option; do
    case $option in
    h) # display Help
        usage
        exit;;
    i) # Input
        input=$OPTARG;;
    o) # Output
        output=$OPTARG;;
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


# input=/mnt/data/radiotherapy/liver/images/
# output=/mnt/data/radiotherapy/liver/transforms/
# echo "input: ${input} output: ${output} verbose: ${verbose} debug: ${debug}"

# Run all
for pt in $(ls ${input})
do
    transform_referenced ${pt} ${input} ${output} ${debug} ${verbose}
done
