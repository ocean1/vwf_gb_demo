echo off
cls
rgbasm -odemo.obj -iinc\ demo.asm
if errorlevel 1 goto exit
xlink -mmap -ndemo.sym link
if errorlevel 1 goto ending
rgbfix -v -p32 demo.gb
echo .......................................
del demo.obj
deltree demo.sym
del map
:exit
echo .......................................