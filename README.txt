-----------------------------------------------------------------------------

     Restoration of JPEG Compressed Image 
     with Narrow Quantization Constraint Set without Parameter Optimization         
 
-----------------------------------------------------------------------------

Written by  : Chihiro Tsutake
Affiliation : Nagoya University
E-mail      : ctsutake@nagoya-u.jp
Created     : Feb. 2020

-----------------------------------------------------------------------------
    Contents
-----------------------------------------------------------------------------

PK99/       : Main algorithm files for the proposed technique 1
ZLXLMG16/   : Main algorithm files for the proposed technique 2
Utilities/  : JPEG algorithm files
Img/        : Original PGM images

-----------------------------------------------------------------------------
    Usage
-----------------------------------------------------------------------------

1) Change the current directory to `PK99' or `ZLXLMG16'.
2) Choose the variable `qf' in `main.m' from the range 1 to 100.
2) Running `main' generates the following images.

    -- jpg.png (decoded image)
    -- res.png (restored image)

-----------------------------------------------------------------------------
    Feedback
-----------------------------------------------------------------------------

If you have any questions, please contact me.
