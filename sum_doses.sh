#!/bin/bash
# @Author: Jose Tascon
# @Date:   2020-04-17 15:58:54
# @Last Modified by:   jose
# @Last Modified time: 2021-06-01 10:37:29

sum_doses ()
{
    # Argument 1: patient name
    # Argument 2: transform folder
    # Argument 3: doses
    # Argument 4: output folder

    echo; echo "Dose summation of images"
    echo;
    echo "python sum_images.py -v $2/$1/$3 $2/$1/$4"
    echo;
    python sum_images.py -v $2/$1/$3 $2/$1/$4
}

transforms=/mnt/data/radiotherapy/liver/transforms

# Individual call
# sum_doses "patient01" ${transforms} "affine_doses_ants" "sum_affine"
# sum_doses "patient02" ${transforms} "affine_doses_ants" "sum_affine"
# sum_doses "patient03" ${transforms} "affine_doses_ants" "sum_affine"
# sum_doses "patient04" ${transforms} "affine_doses_ants" "sum_affine"
# sum_doses "patient05" ${transforms} "affine_doses_ants" "sum_affine"

# sum_doses "patient01" ${transforms} "warped_doses_ants" "sum_ants"
# sum_doses "patient02" ${transforms} "warped_doses_ants" "sum_ants"
# sum_doses "patient03" ${transforms} "warped_doses_ants" "sum_ants"
# sum_doses "patient04" ${transforms} "warped_doses_ants" "sum_ants"
# sum_doses "patient05" ${transforms} "warped_doses_ants" "sum_ants"

# sum_doses "patient01" ${transforms} "warped_doses_elastix" "sum_elastix"
# sum_doses "patient02" ${transforms} "warped_doses_elastix" "sum_elastix"
# sum_doses "patient03" ${transforms} "warped_doses_elastix" "sum_elastix"
# sum_doses "patient04" ${transforms} "warped_doses_elastix" "sum_elastix"
# sum_doses "patient05" ${transforms} "warped_doses_elastix" "sum_elastix"

sum_doses "patient06" ${transforms} "affine_doses_ants" "sum_affine"
sum_doses "patient07" ${transforms} "affine_doses_ants" "sum_affine"
sum_doses "patient08" ${transforms} "affine_doses_ants" "sum_affine"
sum_doses "patient09" ${transforms} "affine_doses_ants" "sum_affine"
sum_doses "patient10" ${transforms} "affine_doses_ants" "sum_affine"

sum_doses "patient06" ${transforms} "warped_doses_ants" "sum_ants"
sum_doses "patient07" ${transforms} "warped_doses_ants" "sum_ants"
sum_doses "patient08" ${transforms} "warped_doses_ants" "sum_ants"
sum_doses "patient09" ${transforms} "warped_doses_ants" "sum_ants"
sum_doses "patient10" ${transforms} "warped_doses_ants" "sum_ants"

sum_doses "patient06" ${transforms} "warped_doses_elastix" "sum_elastix"
sum_doses "patient07" ${transforms} "warped_doses_elastix" "sum_elastix"
sum_doses "patient08" ${transforms} "warped_doses_elastix" "sum_elastix"
sum_doses "patient09" ${transforms} "warped_doses_elastix" "sum_elastix"
sum_doses "patient10" ${transforms} "warped_doses_elastix" "sum_elastix"

