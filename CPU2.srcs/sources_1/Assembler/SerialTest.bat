customasm.exe SerialTest.asm -f binary -o SerialTest.bin -- -f hexstr -o SerialTest.hex -- -f mif -o SerialTest.mif -- -f addrspan -o SerialTest.addr -- -f annotated,base:16,group:2 -o SerialTest.lst -- -f symbols -o SerialTest.sym
ConvertBinToCoeMif SerialTest.bin
:: ([0-9a-f]{8}) $1, 
pause