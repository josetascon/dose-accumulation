Dose Accumulation
-----------------

Radiotherapy dose accumulation for interfraction images using deformable image registration. This is an automatic tool that accumulate doses using ANTs or Elastix.

Desing
------

This is a collection of bash and python scripts.


Dependencies
------------

Python:
* SimpleITK >= 2.0

External:
* ANTs [webpage](http://stnava.github.io/ANTs/)\
Note: You require to have ANTs installed in your system with working binary commands 'antsRegistrationSyN' and 'antsApplyTransforms'.
* Elastix [webpage](https://elastix.lumc.nl/)\
Note: You require to have elastix installed in your system with working binary commands 'elastix' and 'transformix'.
---

Run
----------

To run a dose accumulation you require a set of images with the corresponding dose images. Supported image formats: nii, nrrd, mhd, or any single file format compatible with ITK. Create a folder tree structure like the following:

```bash
input/
├── patient01/
│   ├── doses/
│   │   ├── patient01_dose00.nii  (total dose plan)
│   │   ├── patient01_dose01.nii  (treatment dose, fraction 1) 
│   │   ├── patient01_dose02.nii
│   │   └── patient01_dose03.nii
│   └── fractions/
│       ├── patient01_fraction00.nii (baseline or plan image)
│       ├── patient01_fraction01.nii (treatment image, fraction 1)
│       ├── patient01_fraction02.nii
│       └── patient01_fraction03.nii
├── patient02/
│   ├── doses
│   │   ├── patient02_dose00.nii
│   │   ├── patient02_dose01.nii
│   │   ├── patient02_dose02.nii
│   │   └── patient02_dose03.nii
│   └── fractions
│       ├── patient02_fraction00.nii
│       ├── patient02_fraction01.nii
│       ├── patient02_fraction02.nii
│       └── patient02_fraction03.nii
...

```

Then run the command
```bash
./dose-accumulation.sh -i path/input/ -o path/output/ -m [affine|ants|elastix]
```

Citation
--------

To cite when using this toolbox, please reference, as appropriate:\
@inproceedings{2021dose,\
  title={Dose Accumulation in online MR-guided treatment of Prostate},\
  author={},\
  booktitle={},\
  pages={},\
  year={2021},\
  organization={}\
}