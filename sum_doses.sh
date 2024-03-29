#!/bin/bash
# @Author: Jose Tascon
# @Date:   2020-04-17 15:58:54
# @Last Modified by:   Jose Tascon
# @Last Modified time: 2021-10-12 23:04:37

sum_doses ()
{
    # Argument 1: input folder
    # Argument 2: warp folder
    # Argument 3: output folder
    # Argument 4: debug
    # Argument 5: verbose

    echo; echo "Sum of dose images"
    echo;

    opt=""
    if [ $4 = true ]; then
        opt="-d ${opt}"
    fi

    if [ $5 = true  ]; then
        opt="-v ${opt}"
    fi

    cmd="python sum_images.py ${opt} $1$2 $1$3"
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
    echo "Sum of dose images."
    echo
    echo "Syntax: sum_doses.sh [-h|v|d] -i input -r warp_folder -o output"
    echo "options:"
    echo "i     Input folder with interfraction doses"
    echo "r     Warp folder"
    echo "o     Output folder with accumulation"
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
warp=""
verbose=false
debug=false

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hvdi:o:r:" option; do
    case $option in
    h) # display Help
        usage
        exit;;
    i) # Input
        input=$OPTARG;;
    o) # Output
        output=$OPTARG;;
    r) # Warp
        warp=$OPTARG;;
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

# transforms=/mnt/data/radiotherapy/liver/transforms

# python sum_images.py -v $2/$1/$3 $2/$1/$4

# sum_doses "patient06" ${transforms} "affine_doses_ants" "sum_affine"
# sum_doses "patient06" ${transforms} "warped_doses_ants" "sum_ants"
# sum_doses "patient06" ${transforms} "warped_doses_elastix" "sum_elastix"


# Run all
for pt in $(ls ${input})
do
    sum_doses "${input}/${pt}/" ${warp} ${output} ${debug} ${verbose}
done 


