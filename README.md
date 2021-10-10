Dose Accumulation
-----------------

Radiotherapy dose accumulation for interfraction images.

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

To run a dose accumulation you require a set of images with the dose images. Create a tree structure like the following:


Then run the command
  dose-accumulation path/input/ path/output/
 

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