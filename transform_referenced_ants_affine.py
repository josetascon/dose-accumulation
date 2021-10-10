# -*- coding: utf-8 -*-
# @Author: jose
# @Date:   2019-01-27 17:34:53
# @Last Modified by:   jose
# @Last Modified time: 2021-03-03 08:16:24

import os                       # os library, used to read files
import argparse                 # argument parser

from folder_utils import *

def main():
    # Arguments details
    parser = argparse.ArgumentParser(description='Transform all dose images in a folder to a single reference image. \
                        Registration with ANTS library')
    parser.add_argument("reference", type=str, 
                        help='Reference image file')
    parser.add_argument("dose_folder", type=str, 
                        help='Dose folder with images')
    parser.add_argument("transform_folder", type=str,
                        help='Folder with computed transformations')
    parser.add_argument("output_folder", type=str, 
                        help='Output folder with images')
    parser.add_argument('-d','--debug', action='store_true',
                        help='Enable debug mode')
    parser.add_argument('-v','--verbose', action='store_true',
                        help='Enable verbose mode')

    # Parse arguments
    args = parser.parse_args()
    dose_folder = args.dose_folder
    transform_folder = args.transform_folder
    output_folder = args.output_folder
    reference = args.reference

    # Files organized alphabetically
    dose_files = os.listdir(dose_folder)
    dose_files.sort()

    # Transforms organized
    transform_files = os.listdir(transform_folder)
    transform_files.sort()

    affine_prefix = ['_0Generic']
    dfield_prefix = ['_1Warp.nii.gz']
    affine_files = filter_folders_prefix(affine_prefix, transform_files)
    # dfield_files = filter_folders_prefix(dfield_prefix, transform_files)

    # Remove reference dose if inside dose files
    numref = os.path.splitext(os.path.basename(reference))[0][-2:] # reference number
    indices = [i for i, s in enumerate(dose_files) if numref in s] # index where numref is in dose file
    for k in indices:
        dose_files.remove(dose_files[k])
    
    print('\nRunning script to transform 3d images based in a reference.')
    if args.debug:
        print('[Debug Mode]')
    if args.verbose:
        print('\nReference file: \n' + str(fullpath_to_localpath([reference])) )
        print('\nFiles found: \n' + str(dose_files))
        print('\nAffine transforms found: \n' + str(affine_files))
        # print('\nField transforms found: \n' + str(dfield_files))

    # assert(len(dfield_files) == len(affine_files) and len(dfield_files) == len(dose_files))
    

    # Create directory to save output
    output_path = os.path.join(output_folder,'affine_doses_ants/')       # output path
    print('\nCreate output folder:')
    os.system('echo mkdir -p ' + output_path )                      # echo mkdir
    if not args.debug: 
        os.system('mkdir -p ' + output_path )                       # make directory


    print('\nTransformations:')
    
    # Script loop
    c = 0
    k = 0
    while c < len(dose_files):
    # for k in range(len(dose_files)):
        num_img = 'dose' + str(k+1).zfill(2) # the files contain the word dose
        doses_to_process = [[i for i, s in enumerate(dose_files) if num_img in s]]
        # print(num_img)
        # print(doses_to_process)

        for d,j in enumerate (doses_to_process[0]):
            # Moving image path
            moving_image = os.path.join(dose_folder, dose_files[j])
            
            # Output file names
            out_prefix = '{}_to_{}.nrrd'.format(os.path.splitext(os.path.basename(dose_files[j]))[0], 
                                        os.path.splitext(os.path.basename(reference))[0][-10:])
            output = os.path.join(output_path, out_prefix)


            affine_transform = os.path.join(transform_folder, affine_files[k])
            # dfield_transform = os.path.join(transform_folder, dfield_files[k])

            cmd = 'antsApplyTransforms -d 3 \
            -i {} -o {} -r {} -t {}'.format( moving_image, output , reference , affine_transform )

            # Execute the command
            
            os.system('echo ' + cmd)
            if not args.debug:
                os.system(cmd)    


        c += len(doses_to_process[0])
        k += 1
        print(k,c)

    return
                

if __name__ == "__main__":
    # execute only if run as a script
    main()
