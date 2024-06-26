@echo off
REM ****************************************************************************
REM Vivado (TM) v2023.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : AMD Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Wed Dec 13 17:40:53 -0600 2023
REM SW Build 4029153 on Fri Oct 13 20:14:34 MDT 2023
REM
REM Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
REM Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
REM simulate design
echo "xsim SimCPU_time_synth -key {Post-Synthesis:sim_1:Timing:SimCPU} -tclbatch SimCPU.tcl -view D:/Users/Craig/Documents/000 ArtyS7/CPU2/CPU2.srcs/sim_1/SimCPU_behav.wcfg -log simulate.log"
call xsim  SimCPU_time_synth -key {Post-Synthesis:sim_1:Timing:SimCPU} -tclbatch SimCPU.tcl -view D:/Users/Craig/Documents/000 ArtyS7/CPU2/CPU2.srcs/sim_1/SimCPU_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
