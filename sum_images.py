# -*- coding: utf-8 -*-
# @Author: jose
# @Date:   2019-01-27 17:34:53
# @Last Modified by:   jose
# @Last Modified time: 2021-02-28 20:08:28

import os                       # os library, used to read files
import argparse                 # argument parser
import SimpleITK as sitk        # simpleitk


def main():
    # Arguments details
    parser = argparse.ArgumentParser(description='Sum all dose images in a folder')
    parser.add_argument("input_folder", type=str, 
                        help='Input folder with images')
    parser.add_argument("output_folder", type=str, 
                        help='Output folder to store image summation')
    parser.add_argument('-d','--debug', action='store_true',
                        help='Enable debug mode')
    parser.add_argument('-v','--verbose', action='store_true',
                        help='Enable verbose mode')

    # Parse arguments
    args = parser.parse_args()
    input_folder = args.input_folder
    output_folder = args.output_folder

    # Files organized alphabetically
    files = os.listdir(input_folder)
    files.sort()

    # Output file names
    out_prefix = '{}_sum.nrrd'.format(os.path.splitext(os.path.basename(files[0]))[0][0:9])
    output = os.path.join(output_folder, out_prefix)

    print('\nRunning script to add images.')
    if args.debug:
        print('[Debug Mode]')
    if args.verbose:
        print('\nFiles found: \n' + str(files))
        print('\nFile to create: \n' + str(output))
        
    # Create directory to save output
    print('\nCreate output folder (if does not exist):')
    os.system('echo mkdir -p ' + output_folder )            # echo mkdir
    if not args.debug: 
        os.system('mkdir -p ' + output_folder )             # make directory


    print('\nSummation:')

    filename = os.path.join(input_folder, files[0])
    print('Reading image: ' + filename)
    result = sitk.ReadImage(filename, sitk.sitkFloat32)     # read the first image
    
    # Script loop
    for k in range(1, len(files)):
        # Moving image path
        filename = os.path.join(input_folder, files[k])
        print('Reading image: ' + filename)
        image = sitk.ReadImage(filename, sitk.sitkFloat32)
        result += image
        
    cmd = 'Writing image: ' + output

    # Execute the command    
    os.system('echo ' + cmd)
    if not args.debug:
        sitk.WriteImage(result, output)
    
    return
                

if __name__ == "__main__":
    # execute only if run as a script
    main()
