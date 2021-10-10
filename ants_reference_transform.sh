#!/bin/bash
# @Author: Jose Tascon
# @Date:   2020-04-17 15:58:54
# @Last Modified by:   jose
# @Last Modified time: 2021-06-01 10:36:35

transform_refenced ()
{
    # Argument 1: patient name
    # Argument 2: images folder
    # Argument 3: transform folder
    echo; echo "Transform with ANTS"
    echo;
    echo "python transform_referenced_ants.py -v $2/$1/fractions/$1_fraction00.nrrd \
        $2/$1/doses/ $3/$1/ants/ $3/$1/"
    echo;
    python transform_referenced_ants.py -v $2/$1/fractions/$1_fraction00.nrrd \
        $2/$1/doses $3/$1/ants/ $3/$1
}

images=/mnt/data/radiotherapy/liver/images
transforms=/mnt/data/radiotherapy/liver/transforms

# Run all
for i in {00..10} # work in bash>=4.1
do
   echo "patient$i"
   transform_refenced "patient$i" ${images} ${transforms}
done

# Individual call
# transform_refenced "patient01" ${images} ${transforms}
# transform_refenced "patient02" ${images} ${transforms}
# transform_refenced "patient03" ${images} ${transforms}
# transform_refenced "patient04" ${images} ${transforms}
# transform_refenced "patient05" ${images} ${transforms}

# transform_refenced "patient06" ${images} ${transforms}
# transform_refenced "patient07" ${images} ${transforms}
# transform_refenced "patient08" ${images} ${transforms}
# transform_refenced "patient09" ${images} ${transforms}
# transform_refenced "patient10" ${images} ${transforms}
