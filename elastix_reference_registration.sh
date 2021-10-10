#!/bin/bash
# @Author: Jose Tascon
# @Date:   2020-04-17 15:58:54
# @Last Modified by:   jose
# @Last Modified time: 2021-06-01 10:35:24

register_refenced ()
{
    # Argument 1: patient name
    # Argument 2: images folder
    # Argument 3: transform folder
    echo; echo "Referenced Registration with Elastix"
    echo;
    nthreads=nthreads.txt;
    echo "mkdir -p $3/$1/"
    mkdir -p $3/$1/
    echo "python register_referenced_elastix.py -v $2/$1/fractions/ $3/$1/ -n $nthreads"
    echo;
    python register_referenced_elastix.py -v $2/$1/fractions/ $3/$1/ -n $nthreads
}

input=/mnt/data/radiotherapy/liver/images/
output=/mnt/data/radiotherapy/liver/transforms/

# Run all
for i in {00..10} # works in bash>=4.1
do
   echo "patient$i"
   register_refenced "patient$i" ${input} ${output}
done

# Individual call
# register_refenced "patient01" ${input} ${output}
# register_refenced "patient02" ${input} ${output}
# register_refenced "patient03" ${input} ${output}
# register_refenced "patient04" ${input} ${output}
# register_refenced "patient05" ${input} ${output}

# register_refenced "patient06" ${input} ${output}
# register_refenced "patient07" ${input} ${output}
# register_refenced "patient08" ${input} ${output}
# register_refenced "patient09" ${input} ${output}
# register_refenced "patient10" ${input} ${output}