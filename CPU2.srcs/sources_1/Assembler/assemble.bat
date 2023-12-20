customasm.exe fpga.asm -f binary -o fpga.bin -- -f hexstr -o fpga.hex -- -f annotated,base:16,group:2 -o fpga.lst -- -f symbols -o fpga.sym
:: ([0-9a-f]{8}) $1, 
pause