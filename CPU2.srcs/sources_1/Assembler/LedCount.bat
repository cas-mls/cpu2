customasm.exe LedCount.asm -f binary -o LedCount.bin -- -f hexstr -o LedCount.hex -- -f mif -o LedCount.mif -- -f addrspan -o LedCount.addr -- -f annotated,base:16,group:2 -o LedCount.lst -- -f symbols -o LedCount.sym
ConvertBinToCoeMif LedCount.bin
:: ([0-9a-f]{8}) $1, 
pause