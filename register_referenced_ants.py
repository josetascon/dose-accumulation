# -*- coding: utf-8 -*-
# @Author: jose
# @Date:   2019-01-27 17:34:53
# @Last Modified by:   jose
# @Last Modified time: 2021-02-25 21:10:38

import os                       # os library, used to read files
import argparse                 # argument parser

def main():
    # Arguments details
    parser = argparse.ArgumentParser(description='Register all images in a folder to a single reference image. \
                        Registration with ANTS library')
    parser.add_argument("input_folder", type=str, 
                        help='Input folder with images')
    parser.add_argument("output_folder", type=str,
                        help='Output folder to store transformations')
    parser.add_argument('-r', '--reference', type=int, default=0,
                        help='Reference image')
    parser.add_argument('-m','--list_moving_images', nargs='+', type=int,
                        help= 'List of desired moving images to register')
    parser.add_argument('-n', '--nthreads', type=str, default='',
                        help='File with number of threads')
    parser.add_argument('-w', '--overwrite', action='store_true',
                        help='Overwrite existent registrations')
    parser.add_argument('-l', '--log', action='store_true',
                        help='Log script')
    parser.add_argument('-d','--debug', action='store_true',
                        help='Enable debug mode')
    parser.add_argument('-v','--verbose', action='store_true',
                        help='Enable verbose mode')

    # Parse arguments
    args = parser.parse_args()
    input_folder = args.input_folder
    output_folder = args.output_folder
    reference = args.reference
    overwrite = args.overwrite
    list_moving = args.list_moving_images
    file_nthreads = args.nthreads
    log = args.log

    # Files organized alphabetically
    files = os.listdir(input_folder)
    files.sort()
    print('\nRunning script to register 3d images based in a reference.')
    if args.debug:
        print('[Debug Mode]')
    if args.verbose:    
        print('\nFiles found: \n' + str(files))
    
    # os.system('export ANTSPATH=/usr/bin/')
    
    # Fixed image path
    fixed_image_local = files[reference]    # the reference item is the fixed image for all the registrations
    fixed_image = os.path.join(input_folder,fixed_image_local)
    files.remove(files[reference])          # remove reference item from images

    # Select desired images
    files_to_register = []
    if list_moving is not None:
        for i in list_moving:
            files_to_register.append(files[i])
    else:
        files_to_register = files

    if args.verbose:
        print('\nReference image: \n' + str([fixed_image_local]))
        print('\nImages to register: \n' + str(files_to_register))
    print('\nRegistration\n')
    

    # Create directory to save output
    output_path = os.path.join(output_folder,'ants/')        # output path
    os.system('echo mkdir -p ' + output_path )              # echo mkdir
    if not args.debug: 
        os.system('mkdir -p ' + output_path )               # make directory

    bool_nthreads = True
    nthreads = 24
    if file_nthreads == '': bool_nthreads = False

    write = True
    files_overwrite = []
    # Script loop
    for ff in files_to_register:
        
        # Read number of threads, update each iteration
        if bool_nthreads:
            file_handler = open(file_nthreads)
            nthreads = int(file_handler.readline())
            file_handler.close()

        # Moving image path
        moving_image = os.path.join(input_folder, ff)
        
        # Output file names
        out_prefix = '{}to{}_'.format(os.path.splitext(os.path.basename(fixed_image))[0][-2:], 
                                    os.path.splitext(os.path.basename(moving_image))[0][-2:])
        output = os.path.join(output_path, out_prefix)

        output_already0 = out_prefix + '0InverseWarp.nii.gz'
        output_already1 = out_prefix + '1InverseWarp.nii.gz'

        if overwrite:
            write = True
        else:
            # check if already exist
            try:
                files_overwrite = os.listdir(output_path)
            except:
                pass
            if output_already0 in files_overwrite:
                write = False
                os.system('echo [Warning] Existing registration {}. Continue. Use option -w to overwrite'.format(output_already0))
            elif output_already1 in files_overwrite:
                write = False
                os.system('echo [Warning] Existing registration {}. Continue. Use option -w to overwrite'.format(output_already1))
            else:
                write = True

        # print(out_prefix)

        cmd = 'antsRegistrationSyN.sh -d 3 -t s -n '+ str(nthreads) +' \
        -f {} -m {} -o {}'.format(fixed_image, moving_image, output)

        # Execute the command
        if write:
            print()
            os.system('echo ' + cmd)
            if log: cmd = cmd + '> ' + os.path.dirname(output) + '/ants' + os.path.basename(output)[:-1] + '.log'
            if not args.debug:
                os.system(cmd)
                

if __name__ == "__main__":
    # execute only if run as a script
    main()
