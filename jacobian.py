# -*- coding: utf-8 -*-
# @Author: jose
# @Date:   2019-01-27 17:34:53
# @Last Modified by:   jose
# @Last Modified time: 2021-02-03 18:00:30

import argparse                 # argument parser
import numpy as np              # numpy
import SimpleITK as sitk        # Simple ITK

def jacobian_determinant(image):
    dim = image.GetDimension()
    jac = None

    # Separate displacements
    x = sitk.VectorIndexSelectionCast(image, 0)
    y = sitk.VectorIndexSelectionCast(image, 1)
    # print(image_info(x))
    # print(image_info(y))
    
    # Compute gradients
    gx = sitk.Gradient(x);
    gy = sitk.Gradient(y);
    # print(image_info(gx))

    # Separate gradient components
    gx_x = sitk.VectorIndexSelectionCast(gx, 0)
    gx_y = sitk.VectorIndexSelectionCast(gx, 1)
    gy_x = sitk.VectorIndexSelectionCast(gy, 0)
    gy_y = sitk.VectorIndexSelectionCast(gy, 1)

    # Ensure det = 1 for 0 displacement
    gx_x = gx_x + 1;
    gy_y = gy_y + 1;

    if (dim == 2):
        # Determinant 2D
        jac = gx_x*gy_y - gy_x*gx_y;
    elif (dim == 3):
        z = sitk.VectorIndexSelectionCast(image, 2)
        gz = sitk.Gradient(z)

        # Separate gradient components
        gz_x = sitk.VectorIndexSelectionCast(gz, 0)
        gz_y = sitk.VectorIndexSelectionCast(gz, 1)
        gz_z = sitk.VectorIndexSelectionCast(gz, 2)
        gz_z = gz_z + 1

        gx_z = sitk.VectorIndexSelectionCast(gx, 2)
        gy_z = sitk.VectorIndexSelectionCast(gy, 2)

        # Determinant 3D
        jac = (gx_x * gy_y * gz_z)\
            + (gy_x * gz_y * gx_z)\
            + (gz_x * gx_y * gy_z)\
            - (gz_x * gy_y * gx_z)\
            - (gy_x * gx_y * gz_z)\
            - (gx_x * gz_y * gy_z);

    return jac

def image_info( image, text = 'Image Information' ):
    '''
    Return a string with image information details. Pixel type, dimensions, scale.
    Input: 
        image: sitk.Image
        text: string. Title to the output
    Output: string
    '''
    info = '\n===== '+ text +' ====='
    info += '\nPixel type: \t\t' + str(image.GetPixelIDTypeAsString())
    info += '\nPixel channels: \t' + str(image.GetNumberOfComponentsPerPixel())
    info += '\nDimensions: \t\t' + str(image.GetDimension())
    info += '\nSize: \t\t\t' + str(image.GetSize())
    info += '\nLength (mm): \t\t' + str(image.GetSpacing())
    info += '\nOrigin (mm): \t\t' + str(image.GetOrigin())
    info += '\nTotal Elements: \t' + str(image.GetNumberOfPixels())
    info += '\n'
    return info

def main():
    # Arguments details
    parser = argparse.ArgumentParser(description='Compute the Jacobian determinat for an \
                multichannel image that represents a deformation field')
    parser.add_argument('input', type=str, 
                        help='Input image file with deformation field')
    parser.add_argument('-o','--output', type=str, default='./jac.nrrd',
                        help='Output file to store Jacobian image')
    parser.add_argument('-v','--verbose', action='store_true',
                        help='Enable verbose mode')

    # Parse arguments
    args = parser.parse_args()
    file_input = args.input
    file_output = args.output    

    # Files organized alphabetically
    print('\nRunning script to estimate Jacobian determinant.')
    if args.verbose:    
        print('\nTransform file: \n' + str(file_input))
        
    
    
    # Fixed image path
    dfield = sitk.ReadImage(file_input, sitk.sitkVectorFloat64)
    dim = dfield.GetDimension()
    channels = dfield.GetNumberOfComponentsPerPixel()

    if (channels != dim):
        print('This is not a deformation field image. Image channels have to correspond to image dimension')
        return -1

    print(image_info(dfield, 'Deformation Field Information'))

    jac = jacobian_determinant(dfield)    

    jarray = sitk.GetArrayFromImage(jac)

    print('===== Jacobian Stats =====')
    print('Min:     \t', jarray.min())
    print('Max:     \t', jarray.max())
    print('Mean:    \t', jarray.mean())
    print('Std dev: \t', jarray.std())

    if not (jac == None):
        print('\nOutput file: \n' + str(file_output))
        sitk.WriteImage(jac, file_output)

    return 0
                

if __name__ == "__main__":
    # execute only if run as a script
    main()
