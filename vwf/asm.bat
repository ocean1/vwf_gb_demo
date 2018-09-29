echo off
cls
rgb\rgbasm -odemo.obj -iinc\ demo.asm
if errorlevel 1 goto exit
rgb\xlink -mmap -ndemo.sym link
if errorlevel 1 goto ending
rgb\rgbfix -v -p32 demo.gb
echo .......................................
del demo.obj
del demo.sym
del map
:exit
echo .......................................
pause