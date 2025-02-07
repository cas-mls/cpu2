customasm.exe interruptTest.asm -f binary -o interruptTest.bin -- -f hexstr -o interruptTest.hex -- -f mif -o interruptTest.mif -- -f addrspan -o interruptTest.addr -- -f annotated,base:16,group:2 -o interruptTest.lst -- -f symbols -o interruptTest.sym
ConvertBinToCoeMif interruptTest.bin
:: ([0-9a-f]{8}) $1, 
pause