## This file is a general .xdc for the Arty S7-50 Rev. E
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock Signals
#set_property -dict { PACKAGE_PIN F14   IOSTANDARD LVCMOS33 } [get_ports { CLK12MHZ }]; #IO_L13P_T2_MRCC_15 Sch=uclk
#create_clock -add -name sys_clk_pin -period 83.333 -waveform {0 41.667} [get_ports { CLK12MHZ }];
#set_property -dict { PACKAGE_PIN R2    IOSTANDARD SSTL135 } [get_ports { CLK100MHZ }]; #IO_L12P_T1_MRCC_34 Sch=ddr3_clk[200]
#create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5.000}  [get_ports { CLK100MHZ }];
set_property -dict {PACKAGE_PIN R2 IOSTANDARD SSTL135} [get_ports SYS_CLK]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports SYS_CLK]

## Switches
#set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]; #IO_L20N_T3_A19_15 Sch=sw[0]
#set_property -dict { PACKAGE_PIN H18   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]; #IO_L21P_T3_DQS_15 Sch=sw[1]
#set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVCMOS33 } [get_ports { sw[2] }]; #IO_L21N_T3_DQS_A18_15 Sch=sw[2]
#set_property -dict { PACKAGE_PIN M5    IOSTANDARD SSTL135 } [get_ports { sw[3] }]; #IO_L6N_T0_VREF_34 Sch=sw[3]
set_property -dict {PACKAGE_PIN M5 IOSTANDARD SSTL135} [get_ports dmode]

## RGB LEDs
#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { led0_r }]; #IO_L23N_T3_FWE_B_15 Sch=led0_r
#set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { led0_g }]; #IO_L14N_T2_SRCC_15 Sch=led0_g
#set_property -dict { PACKAGE_PIN F15   IOSTANDARD LVCMOS33 } [get_ports { led0_b }]; #IO_L13N_T2_MRCC_15 Sch=led0_b
#set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { led1_r }]; #IO_L15N_T2_DQS_ADV_B_15 Sch=led1_r
#set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVCMOS33 } [get_ports { led1_g }]; #IO_L16P_T2_A28_15 Sch=led1_g
#set_property -dict { PACKAGE_PIN E14   IOSTANDARD LVCMOS33 } [get_ports { led1_b }]; #IO_L15P_T2_DQS_15 Sch=led1_b

#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { rgb[0] }]; #IO_L23N_T3_FWE_B_15 Sch=led0_r
#set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { rgb[1] }]; #IO_L14N_T2_SRCC_15 Sch=led0_g
#set_property -dict { PACKAGE_PIN F15   IOSTANDARD LVCMOS33 } [get_ports { rgb[2] }]; #IO_L13N_T2_MRCC_15 Sch=led0_b
#set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { rgb[3] }]; #IO_L15N_T2_DQS_ADV_B_15 Sch=led1_r
#set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVCMOS33 } [get_ports { rgb[4] }]; #IO_L16P_T2_A28_15 Sch=led1_g
#set_property -dict { PACKAGE_PIN E14   IOSTANDARD LVCMOS33 } [get_ports { rgb[5] }]; #IO_L15P_T2_DQS_15 Sch=led1_b

## LEDs
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports {led[3]}]

## Buttons
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports {{btn[0]} rst}]
#set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { btn[0] }]; #IO_L18N_T2_A23_15 Sch=btn[0]
#set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; #IO_L19P_T3_A22_15 Sch=btn[1]
#set_property -dict { PACKAGE_PIN J16   IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]; #IO_L19N_T3_A21_VREF_15 Sch=btn[2]
#set_property -dict { PACKAGE_PIN H13   IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]; #IO_L20P_T3_A20_15 Sch=btn[3]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports dcont]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports dstep]
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports dbreak]

## Pmod Header JA
#set_property -dict { PACKAGE_PIN L17   IOSTANDARD LVCMOS33 } [get_ports { ja[0] }]; #IO_L4P_T0_D04_14 Sch=ja_p[1]
#set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { ja[1] }]; #IO_L4N_T0_D05_14 Sch=ja_n[1]
#set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { ja[2] }]; #IO_L5P_T0_D06_14 Sch=ja_p[2]
#set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { ja[3] }]; #IO_L5N_T0_D07_14 Sch=ja_n[2]
#set_property -dict { PACKAGE_PIN M16   IOSTANDARD LVCMOS33 } [get_ports { ja[4] }]; #IO_L7P_T1_D09_14 Sch=ja_p[3]
#set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { ja[5] }]; #IO_L7N_T1_D10_14 Sch=ja_n[3]
#set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { ja[6] }]; #IO_L8P_T1_D11_14 Sch=ja_p[4]
#set_property -dict { PACKAGE_PIN N18   IOSTANDARD LVCMOS33 } [get_ports { ja[7] }]; #IO_L8N_T1_D12_14 Sch=ja_n[4]

## Pmod Header JB
#set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { jb[0] }]; #IO_L9P_T1_DQS_14 Sch=jb_p[1]
#set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { jb[1] }]; #IO_L9N_T1_DQS_D13_14 Sch=jb_n[1]
#set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { jb[2] }]; #IO_L10P_T1_D14_14 Sch=jb_p[2]
#set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { jb[3] }]; #IO_L10N_T1_D15_14 Sch=jb_n[2]
#set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { jb[4] }]; #IO_L11P_T1_SRCC_14 Sch=jb_p[3]
#set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { jb[5] }]; #IO_L11N_T1_SRCC_14 Sch=jb_n[3]
#set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { jb[6] }]; #IO_L12P_T1_MRCC_14 Sch=jb_p[4]
#set_property -dict { PACKAGE_PIN P16   IOSTANDARD LVCMOS33 } [get_ports { jb[7] }]; #IO_L12N_T1_MRCC_14 Sch=jb_n[4]

## Pmod Header JC
#set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports { jc[0] }]; #IO_L18P_T2_A12_D28_14 Sch=jc1/ck_io[41]
#set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { jc[1] }]; #IO_L18N_T2_A11_D27_14 Sch=jc2/ck_io[40]
#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { jc[2] }]; #IO_L15P_T2_DQS_RDWR_B_14 Sch=jc3/ck_io[39]
#set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { jc[3] }]; #IO_L15N_T2_DQS_DOUT_CSO_B_14 Sch=jc4/ck_io[38]
#set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { jc[4] }]; #IO_L16P_T2_CSI_B_14 Sch=jc7/ck_io[37]
#set_property -dict { PACKAGE_PIN P13   IOSTANDARD LVCMOS33 } [get_ports { jc[5] }]; #IO_L19P_T3_A10_D26_14 Sch=jc8/ck_io[36]
#set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { jc[6] }]; #IO_L19N_T3_A09_D25_VREF_14 Sch=jc9/ck_io[35]
#set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { jc[7] }]; #IO_L20P_T3_A08_D24_14 Sch=jc10/ck_io[34]

## Pmod Header JD
#set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { jd[0] }]; #IO_L20N_T3_A07_D23_14 Sch=jd1/ck_io[33]
#set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { jd[1] }]; #IO_L21P_T3_DQS_14 Sch=jd2/ck_io[32]
#set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports { jd[2] }]; #IO_L21N_T3_DQS_A06_D22_14 Sch=jd3/ck_io[31]
#set_property -dict { PACKAGE_PIN T12   IOSTANDARD LVCMOS33 } [get_ports { jd[3] }]; #IO_L22P_T3_A05_D21_14 Sch=jd4/ck_io[30]
#set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { jd[4] }]; #IO_L22N_T3_A04_D20_14 Sch=jd7/ck_io[29]
#set_property -dict { PACKAGE_PIN R11   IOSTANDARD LVCMOS33 } [get_ports { jd[5] }]; #IO_L23P_T3_A03_D19_14 Sch=jd8/ck_io[28]
#set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { jd[6] }]; #IO_L23N_T3_A02_D18_14 Sch=jd9/ck_io[27]
#set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { jd[7] }]; #IO_L24P_T3_A01_D17_14 Sch=jd10/ck_io[26]

## USB-UART Interface
# set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports { uart_txd_out }]; #IO_25_14 Sch=uart_rxd_out
# set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_in }]; #IO_L24N_T3_A00_D16_14 Sch=uart_txd_in
set_property -dict {PACKAGE_PIN R12 IOSTANDARD LVCMOS33} [get_ports uart_txd_out]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports uart_rxd_in]

## ChipKit Outer Digital Header
#set_property -dict { PACKAGE_PIN L13   IOSTANDARD LVCMOS33 } [get_ports { ck_io0 }]; #IO_0_14 Sch=ck_io[0]
#set_property -dict { PACKAGE_PIN N13   IOSTANDARD LVCMOS33 } [get_ports { ck_io1 }]; #IO_L6N_T0_D08_VREF_14   Sch=ck_io[1]
#set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { ck_io2 }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=ck_io[2]
#set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { ck_io3 }]; #IO_L13P_T2_MRCC_14      Sch=ck_io[3]
#set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { ck_io4 }]; #IO_L13N_T2_MRCC_14      Sch=ck_io[4]
#set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { ck_io5 }]; #IO_L14P_T2_SRCC_14      Sch=ck_io[5]
#set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { ck_io6 }]; #IO_L14N_T2_SRCC_14      Sch=ck_io[6]
#set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { ck_io7 }]; #IO_L16N_T2_A15_D31_14   Sch=ck_io[7]
#set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { ck_io8 }]; #IO_L17P_T2_A14_D30_14   Sch=ck_io[8]
#set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { ck_io9 }]; #IO_L17N_T2_A13_D29_14   Sch=ck_io[9]

## ChipKit SPI Header
## NOTE: The ChipKit SPI header ports can also be used as digital I/O and share FPGA pins with ck_io10-13. Do not use both at the same time.
#set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { ck_io10_ss   }]; #IO_L22P_T3_A17_15   Sch=ck_io10_ss
#set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { ck_io11_mosi }]; #IO_L22N_T3_A16_15   Sch=ck_io11_mosi
#set_property -dict { PACKAGE_PIN K14   IOSTANDARD LVCMOS33 } [get_ports { ck_io12_miso }]; #IO_L23P_T3_FOE_B_15 Sch=ck_io12_miso
#set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { ck_io13_sck  }]; #IO_L14P_T2_SRCC_15  Sch=ck_io13_sck

## ChipKit Inner Digital Header
## Note: these pins are shared with PMOD Headers JC and JD and cannot be used at the same time as the applicable PMOD interface(s)
#set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { ck_io26 }]; #IO_L24P_T3_A01_D17_14        Sch=jd10/ck_io[26]
#set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { ck_io27 }]; #IO_L23N_T3_A02_D18_14        Sch=jd9/ck_io[27]
#set_property -dict { PACKAGE_PIN R11   IOSTANDARD LVCMOS33 } [get_ports { ck_io28 }]; #IO_L23P_T3_A03_D19_14        Sch=jd8/ck_io[28]
#set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { ck_io29 }]; #IO_L22N_T3_A04_D20_14        Sch=jd7/ck_io[29]
#set_property -dict { PACKAGE_PIN T12   IOSTANDARD LVCMOS33 } [get_ports { ck_io30 }]; #IO_L22P_T3_A05_D21_14        Sch=jd4/ck_io[30]
#set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports { ck_io31 }]; #IO_L21N_T3_DQS_A06_D22_14    Sch=jd3/ck_io[31]
#set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { ck_io32 }]; #IO_L21P_T3_DQS_14            Sch=jd2/ck_io[32]
#set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { ck_io33 }]; #IO_L20N_T3_A07_D23_14        Sch=jd1/ck_io[33]
#set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { ck_io34 }]; #IO_L20P_T3_A08_D24_14        Sch=jc10/ck_io[34]
#set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { ck_io35 }]; #IO_L19N_T3_A09_D25_VREF_14   Sch=jc9/ck_io[35]
#set_property -dict { PACKAGE_PIN P13   IOSTANDARD LVCMOS33 } [get_ports { ck_io36 }]; #IO_L19P_T3_A10_D26_14        Sch=jc8/ck_io[36]
#set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { ck_io37 }]; #IO_L16P_T2_CSI_B_14          Sch=jc7/ck_io[37]
#set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { ck_io38 }]; #IO_L15N_T2_DQS_DOUT_CSO_B_14 Sch=jc4/ck_io[38]
#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { ck_io39 }]; #IO_L15P_T2_DQS_RDWR_B_14     Sch=jc3/ck_io[39]
#set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { ck_io40 }]; #IO_L18N_T2_A11_D27_14        Sch=jc2/ck_io[40]
#set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports { ck_io41 }]; #IO_L18P_T2_A12_D28_14        Sch=jc1/ck_io[41]

## Dedicated Analog Inputs
#set_property -dict { PACKAGE_PIN J10   } [get_ports { vp_in }]; #IO_L1P_T0_AD4P_35 Sch=v_p
#set_property -dict { PACKAGE_PIN K9    } [get_ports { vn_in }]; #IO_L1N_T0_AD4N_35 Sch=v_n

## ChipKit Outer Analog Header - as Single-Ended Analog Inputs
## NOTE: These ports can be used as single-ended analog inputs with voltages from 0-3.3V (ChipKit analog pins A0-A5) or as digital I/O.
## WARNING: Do not use both sets of constraints at the same time!
## NOTE: The following constraints should be used with the XADC IP core when using these ports as analog inputs.
#set_property -dict { PACKAGE_PIN B13   IOSTANDARD LVCMOS33 } [get_ports { vaux0_p  }]; #IO_L1P_T0_AD0P_15     Sch=ck_an_p[0]   ChipKit pin=A0
#set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVCMOS33 } [get_ports { vaux0_n  }]; #IO_L1N_T0_AD0N_15     Sch=ck_an_n[0]   ChipKit pin=A0
#set_property -dict { PACKAGE_PIN B15   IOSTANDARD LVCMOS33 } [get_ports { vaux1_p  }]; #IO_L3P_T0_DQS_AD1P_15 Sch=ck_an_p[1]   ChipKit pin=A1
#set_property -dict { PACKAGE_PIN A15   IOSTANDARD LVCMOS33 } [get_ports { vaux1_n  }]; #IO_L3N_T0_DQS_AD1N_15 Sch=ck_an_n[1]   ChipKit pin=A1
#set_property -dict { PACKAGE_PIN E12   IOSTANDARD LVCMOS33 } [get_ports { vaux9_p  }]; #IO_L5P_T0_AD9P_15     Sch=ck_an_p[2]   ChipKit pin=A2
#set_property -dict { PACKAGE_PIN D12   IOSTANDARD LVCMOS33 } [get_ports { vaux9_n  }]; #IO_L5N_T0_AD9N_15     Sch=ck_an_n[2]   ChipKit pin=A2
#set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33 } [get_ports { vaux2_p  }]; #IO_L7P_T1_AD2P_15     Sch=ck_an_p[3]   ChipKit pin=A3
#set_property -dict { PACKAGE_PIN A17   IOSTANDARD LVCMOS33 } [get_ports { vaux2_n  }]; #IO_L7N_T1_AD2N_15     Sch=ck_an_n[3]   ChipKit pin=A3
#set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports { vaux10_p }]; #IO_L8P_T1_AD10P_15    Sch=ck_an_p[4]   ChipKit pin=A4
#set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports { vaux10_n }]; #IO_L8N_T1_AD10N_15    Sch=ck_an_n[4]   ChipKit pin=A4
#set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { vaux11_p }]; #IO_L10P_T1_AD11P_15   Sch=ck_an_p[5]   ChipKit pin=A5
#set_property -dict { PACKAGE_PIN E17   IOSTANDARD LVCMOS33 } [get_ports { vaux11_n }]; #IO_L10N_T1_AD11N_15   Sch=ck_an_n[5]   ChipKit pin=A5
## ChipKit Outer Analog Header - as Digital I/O
## NOTE: The following constraints should be used when using these ports as digital I/O.
#set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { ck_a0 }]; #IO_0_15            Sch=ck_a[0]
#set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS33 } [get_ports { ck_a1 }]; #IO_L4P_T0_15       Sch=ck_a[1]
#set_property -dict { PACKAGE_PIN A16   IOSTANDARD LVCMOS33 } [get_ports { ck_a2 }]; #IO_L4N_T0_15       Sch=ck_a[2]
#set_property -dict { PACKAGE_PIN C13   IOSTANDARD LVCMOS33 } [get_ports { ck_a3 }]; #IO_L6P_T0_15       Sch=ck_a[3]
#set_property -dict { PACKAGE_PIN C14   IOSTANDARD LVCMOS33 } [get_ports { ck_a4 }]; #IO_L6N_T0_VREF_15  Sch=ck_a[4]
#set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { ck_a5 }]; #IO_L11P_T1_SRCC_15 Sch=ck_a[5]

## ChipKit Inner Analog Header - as Differential Analog Inputs
## NOTE: These ports can be used as differential analog inputs with voltages from 0-1.0V (ChipKit analog pins A6-A11) or as digital I/O.
## WARNING: Do not use both sets of constraints at the same time!
## NOTE: The following constraints should be used with the XADC core when using these ports as analog inputs.
#set_property -dict { PACKAGE_PIN B14   IOSTANDARD LVCMOS33 } [get_ports { vaux8_p }]; #IO_L2P_T0_AD8P_15     Sch=ad_p[8]   ChipKit pin=A6
#set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS33 } [get_ports { vaux8_n }]; #IO_L2N_T0_AD8N_15     Sch=ad_n[8]   ChipKit pin=A7
#set_property -dict { PACKAGE_PIN D16   IOSTANDARD LVCMOS33 } [get_ports { vaux3_p }]; #IO_L9P_T1_DQS_AD3P_15 Sch=ad_p[3]   ChipKit pin=A8
#set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS33 } [get_ports { vaux3_n }]; #IO_L9N_T1_DQS_AD3N_15 Sch=ad_n[3]   ChipKit pin=A9
## ChipKit Inner Analog Header - as Digital I/O
## NOTE: The following constraints should be used when using the inner analog header ports as digital I/O.
#set_property -dict { PACKAGE_PIN B14   IOSTANDARD LVCMOS33 } [get_ports { ck_a6  }]; #IO_L2P_T0_AD8P_15     Sch=ad_p[8]
#set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS33 } [get_ports { ck_a7  }]; #IO_L2N_T0_AD8N_15     Sch=ad_n[8]
#set_property -dict { PACKAGE_PIN D16   IOSTANDARD LVCMOS33 } [get_ports { ck_a8  }]; #IO_L9P_T1_DQS_AD3P_15 Sch=ad_p[3]
#set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS33 } [get_ports { ck_a9  }]; #IO_L9N_T1_DQS_AD3N_15 Sch=ad_n[3]
#set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports { ck_a10 }]; #IO_L12P_T1_MRCC_15    Sch=ck_a10_r   (Cannot be used as an analog input)
#set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { ck_a11 }]; #IO_L12N_T1_MRCC_15    Sch=ck_a11_r   (Cannot be used as an analog input)

## ChipKit I2C
#set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { ck_scl }]; #IO_L24N_T3_RS0_15 Sch=ck_scl
#set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { ck_sda }]; #IO_L24P_T3_RS1_15 Sch=ck_sda

## Misc. ChipKit Ports
#set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { ck_ioa }]; #IO_25_15 Sch=ck_ioa
#set_property -dict { PACKAGE_PIN C18   IOSTANDARD LVCMOS33 } [get_ports { ck_rst }]; #IO_L11N_T1_SRCC_15

## Quad SPI Flash
## Note: the SCK clock signal can be driven using the STARTUPE2 primitive
#set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { qspi_cs }]; #IO_L6P_T0_FCS_B_14 Sch=qspi_cs
#set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[0] }]; #IO_L1P_T0_D00_MOSI_14 Sch=qspi_dq[0]
#set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[1] }]; #IO_L1N_T0_D01_DIN_14 Sch=qspi_dq[1]
#set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[2] }]; #IO_L2P_T0_D02_14 Sch=qspi_dq[2]
#set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[3] }]; #IO_L2N_T0_D03_14 Sch=qspi_dq[3]

## Configuration options, can be used for all designs
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

## SW3 is assigned to a pin M5 in the 1.35v bank. This pin can also be used as
## the VREF for BANK 34. To ensure that SW3 does not define the reference voltage
## and to be able to use this pin as an ordinary I/O the following property must
## be set to enable an internal VREF for BANK 34. Since a 1.35v supply is being
## used the internal reference is set to half that value (i.e. 0.675v). Note that
## this property must be set even if SW3 is not used in the design.
set_property INTERNAL_VREF 0.675 [get_iobanks 34]





connect_debug_port u_ila_0/probe33 [get_nets [list p_0_in]]
connect_debug_port u_ila_0/probe34 [get_nets [list p_8_in]]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list SYS_CLK_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {DebugOut[Regs][1][0]} {DebugOut[Regs][1][1]} {DebugOut[Regs][1][2]} {DebugOut[Regs][1][3]} {DebugOut[Regs][1][4]} {DebugOut[Regs][1][5]} {DebugOut[Regs][1][6]} {DebugOut[Regs][1][7]} {DebugOut[Regs][1][8]} {DebugOut[Regs][1][9]} {DebugOut[Regs][1][10]} {DebugOut[Regs][1][11]} {DebugOut[Regs][1][12]} {DebugOut[Regs][1][13]} {DebugOut[Regs][1][14]} {DebugOut[Regs][1][15]} {DebugOut[Regs][1][16]} {DebugOut[Regs][1][17]} {DebugOut[Regs][1][18]} {DebugOut[Regs][1][19]} {DebugOut[Regs][1][20]} {DebugOut[Regs][1][21]} {DebugOut[Regs][1][22]} {DebugOut[Regs][1][23]} {DebugOut[Regs][1][24]} {DebugOut[Regs][1][25]} {DebugOut[Regs][1][26]} {DebugOut[Regs][1][27]} {DebugOut[Regs][1][28]} {DebugOut[Regs][1][29]} {DebugOut[Regs][1][30]} {DebugOut[Regs][1][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 12 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {DebugIn[BreakPoints][0][0]} {DebugIn[BreakPoints][0][1]} {DebugIn[BreakPoints][0][2]} {DebugIn[BreakPoints][0][3]} {DebugIn[BreakPoints][0][4]} {DebugIn[BreakPoints][0][5]} {DebugIn[BreakPoints][0][6]} {DebugIn[BreakPoints][0][7]} {DebugIn[BreakPoints][0][8]} {DebugIn[BreakPoints][0][9]} {DebugIn[BreakPoints][0][10]} {DebugIn[BreakPoints][0][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {DebugOut[Regs][11][0]} {DebugOut[Regs][11][1]} {DebugOut[Regs][11][2]} {DebugOut[Regs][11][3]} {DebugOut[Regs][11][4]} {DebugOut[Regs][11][5]} {DebugOut[Regs][11][6]} {DebugOut[Regs][11][7]} {DebugOut[Regs][11][8]} {DebugOut[Regs][11][9]} {DebugOut[Regs][11][10]} {DebugOut[Regs][11][11]} {DebugOut[Regs][11][12]} {DebugOut[Regs][11][13]} {DebugOut[Regs][11][14]} {DebugOut[Regs][11][15]} {DebugOut[Regs][11][16]} {DebugOut[Regs][11][17]} {DebugOut[Regs][11][18]} {DebugOut[Regs][11][19]} {DebugOut[Regs][11][20]} {DebugOut[Regs][11][21]} {DebugOut[Regs][11][22]} {DebugOut[Regs][11][23]} {DebugOut[Regs][11][24]} {DebugOut[Regs][11][25]} {DebugOut[Regs][11][26]} {DebugOut[Regs][11][27]} {DebugOut[Regs][11][28]} {DebugOut[Regs][11][29]} {DebugOut[Regs][11][30]} {DebugOut[Regs][11][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {DebugOut[Regs][8][0]} {DebugOut[Regs][8][1]} {DebugOut[Regs][8][2]} {DebugOut[Regs][8][3]} {DebugOut[Regs][8][4]} {DebugOut[Regs][8][5]} {DebugOut[Regs][8][6]} {DebugOut[Regs][8][7]} {DebugOut[Regs][8][8]} {DebugOut[Regs][8][9]} {DebugOut[Regs][8][10]} {DebugOut[Regs][8][11]} {DebugOut[Regs][8][12]} {DebugOut[Regs][8][13]} {DebugOut[Regs][8][14]} {DebugOut[Regs][8][15]} {DebugOut[Regs][8][16]} {DebugOut[Regs][8][17]} {DebugOut[Regs][8][18]} {DebugOut[Regs][8][19]} {DebugOut[Regs][8][20]} {DebugOut[Regs][8][21]} {DebugOut[Regs][8][22]} {DebugOut[Regs][8][23]} {DebugOut[Regs][8][24]} {DebugOut[Regs][8][25]} {DebugOut[Regs][8][26]} {DebugOut[Regs][8][27]} {DebugOut[Regs][8][28]} {DebugOut[Regs][8][29]} {DebugOut[Regs][8][30]} {DebugOut[Regs][8][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {TxStatus[0]} {TxStatus[1]} {TxStatus[2]} {TxStatus[3]} {TxStatus[4]} {TxStatus[5]} {TxStatus[6]} {TxStatus[7]} {TxStatus[8]} {TxStatus[9]} {TxStatus[10]} {TxStatus[11]} {TxStatus[12]} {TxStatus[13]} {TxStatus[14]} {TxStatus[15]} {TxStatus[16]} {TxStatus[17]} {TxStatus[18]} {TxStatus[19]} {TxStatus[20]} {TxStatus[21]} {TxStatus[22]} {TxStatus[23]} {TxStatus[24]} {TxStatus[25]} {TxStatus[26]} {TxStatus[27]} {TxStatus[28]} {TxStatus[29]} {TxStatus[30]} {TxStatus[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {DebugOut[Instruction][0]} {DebugOut[Instruction][1]} {DebugOut[Instruction][2]} {DebugOut[Instruction][3]} {DebugOut[Instruction][4]} {DebugOut[Instruction][5]} {DebugOut[Instruction][6]} {DebugOut[Instruction][7]} {DebugOut[Instruction][8]} {DebugOut[Instruction][9]} {DebugOut[Instruction][10]} {DebugOut[Instruction][11]} {DebugOut[Instruction][12]} {DebugOut[Instruction][13]} {DebugOut[Instruction][14]} {DebugOut[Instruction][15]} {DebugOut[Instruction][16]} {DebugOut[Instruction][17]} {DebugOut[Instruction][18]} {DebugOut[Instruction][19]} {DebugOut[Instruction][20]} {DebugOut[Instruction][21]} {DebugOut[Instruction][22]} {DebugOut[Instruction][23]} {DebugOut[Instruction][24]} {DebugOut[Instruction][25]} {DebugOut[Instruction][26]} {DebugOut[Instruction][27]} {DebugOut[Instruction][28]} {DebugOut[Instruction][29]} {DebugOut[Instruction][30]} {DebugOut[Instruction][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 64 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {DebugOut[CycleCount][0]} {DebugOut[CycleCount][1]} {DebugOut[CycleCount][2]} {DebugOut[CycleCount][3]} {DebugOut[CycleCount][4]} {DebugOut[CycleCount][5]} {DebugOut[CycleCount][6]} {DebugOut[CycleCount][7]} {DebugOut[CycleCount][8]} {DebugOut[CycleCount][9]} {DebugOut[CycleCount][10]} {DebugOut[CycleCount][11]} {DebugOut[CycleCount][12]} {DebugOut[CycleCount][13]} {DebugOut[CycleCount][14]} {DebugOut[CycleCount][15]} {DebugOut[CycleCount][16]} {DebugOut[CycleCount][17]} {DebugOut[CycleCount][18]} {DebugOut[CycleCount][19]} {DebugOut[CycleCount][20]} {DebugOut[CycleCount][21]} {DebugOut[CycleCount][22]} {DebugOut[CycleCount][23]} {DebugOut[CycleCount][24]} {DebugOut[CycleCount][25]} {DebugOut[CycleCount][26]} {DebugOut[CycleCount][27]} {DebugOut[CycleCount][28]} {DebugOut[CycleCount][29]} {DebugOut[CycleCount][30]} {DebugOut[CycleCount][31]} {DebugOut[CycleCount][32]} {DebugOut[CycleCount][33]} {DebugOut[CycleCount][34]} {DebugOut[CycleCount][35]} {DebugOut[CycleCount][36]} {DebugOut[CycleCount][37]} {DebugOut[CycleCount][38]} {DebugOut[CycleCount][39]} {DebugOut[CycleCount][40]} {DebugOut[CycleCount][41]} {DebugOut[CycleCount][42]} {DebugOut[CycleCount][43]} {DebugOut[CycleCount][44]} {DebugOut[CycleCount][45]} {DebugOut[CycleCount][46]} {DebugOut[CycleCount][47]} {DebugOut[CycleCount][48]} {DebugOut[CycleCount][49]} {DebugOut[CycleCount][50]} {DebugOut[CycleCount][51]} {DebugOut[CycleCount][52]} {DebugOut[CycleCount][53]} {DebugOut[CycleCount][54]} {DebugOut[CycleCount][55]} {DebugOut[CycleCount][56]} {DebugOut[CycleCount][57]} {DebugOut[CycleCount][58]} {DebugOut[CycleCount][59]} {DebugOut[CycleCount][60]} {DebugOut[CycleCount][61]} {DebugOut[CycleCount][62]} {DebugOut[CycleCount][63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {DebugOut[Regs][14][0]} {DebugOut[Regs][14][1]} {DebugOut[Regs][14][2]} {DebugOut[Regs][14][3]} {DebugOut[Regs][14][4]} {DebugOut[Regs][14][5]} {DebugOut[Regs][14][6]} {DebugOut[Regs][14][7]} {DebugOut[Regs][14][8]} {DebugOut[Regs][14][9]} {DebugOut[Regs][14][10]} {DebugOut[Regs][14][11]} {DebugOut[Regs][14][12]} {DebugOut[Regs][14][13]} {DebugOut[Regs][14][14]} {DebugOut[Regs][14][15]} {DebugOut[Regs][14][16]} {DebugOut[Regs][14][17]} {DebugOut[Regs][14][18]} {DebugOut[Regs][14][19]} {DebugOut[Regs][14][20]} {DebugOut[Regs][14][21]} {DebugOut[Regs][14][22]} {DebugOut[Regs][14][23]} {DebugOut[Regs][14][24]} {DebugOut[Regs][14][25]} {DebugOut[Regs][14][26]} {DebugOut[Regs][14][27]} {DebugOut[Regs][14][28]} {DebugOut[Regs][14][29]} {DebugOut[Regs][14][30]} {DebugOut[Regs][14][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {DebugOut[Regs][2][0]} {DebugOut[Regs][2][1]} {DebugOut[Regs][2][2]} {DebugOut[Regs][2][3]} {DebugOut[Regs][2][4]} {DebugOut[Regs][2][5]} {DebugOut[Regs][2][6]} {DebugOut[Regs][2][7]} {DebugOut[Regs][2][8]} {DebugOut[Regs][2][9]} {DebugOut[Regs][2][10]} {DebugOut[Regs][2][11]} {DebugOut[Regs][2][12]} {DebugOut[Regs][2][13]} {DebugOut[Regs][2][14]} {DebugOut[Regs][2][15]} {DebugOut[Regs][2][16]} {DebugOut[Regs][2][17]} {DebugOut[Regs][2][18]} {DebugOut[Regs][2][19]} {DebugOut[Regs][2][20]} {DebugOut[Regs][2][21]} {DebugOut[Regs][2][22]} {DebugOut[Regs][2][23]} {DebugOut[Regs][2][24]} {DebugOut[Regs][2][25]} {DebugOut[Regs][2][26]} {DebugOut[Regs][2][27]} {DebugOut[Regs][2][28]} {DebugOut[Regs][2][29]} {DebugOut[Regs][2][30]} {DebugOut[Regs][2][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 32 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {DebugOut[Regs][4][0]} {DebugOut[Regs][4][1]} {DebugOut[Regs][4][2]} {DebugOut[Regs][4][3]} {DebugOut[Regs][4][4]} {DebugOut[Regs][4][5]} {DebugOut[Regs][4][6]} {DebugOut[Regs][4][7]} {DebugOut[Regs][4][8]} {DebugOut[Regs][4][9]} {DebugOut[Regs][4][10]} {DebugOut[Regs][4][11]} {DebugOut[Regs][4][12]} {DebugOut[Regs][4][13]} {DebugOut[Regs][4][14]} {DebugOut[Regs][4][15]} {DebugOut[Regs][4][16]} {DebugOut[Regs][4][17]} {DebugOut[Regs][4][18]} {DebugOut[Regs][4][19]} {DebugOut[Regs][4][20]} {DebugOut[Regs][4][21]} {DebugOut[Regs][4][22]} {DebugOut[Regs][4][23]} {DebugOut[Regs][4][24]} {DebugOut[Regs][4][25]} {DebugOut[Regs][4][26]} {DebugOut[Regs][4][27]} {DebugOut[Regs][4][28]} {DebugOut[Regs][4][29]} {DebugOut[Regs][4][30]} {DebugOut[Regs][4][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 12 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {DebugOut[ProgCounter][0]} {DebugOut[ProgCounter][1]} {DebugOut[ProgCounter][2]} {DebugOut[ProgCounter][3]} {DebugOut[ProgCounter][4]} {DebugOut[ProgCounter][5]} {DebugOut[ProgCounter][6]} {DebugOut[ProgCounter][7]} {DebugOut[ProgCounter][8]} {DebugOut[ProgCounter][9]} {DebugOut[ProgCounter][10]} {DebugOut[ProgCounter][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 32 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {DebugOut[Regs][12][0]} {DebugOut[Regs][12][1]} {DebugOut[Regs][12][2]} {DebugOut[Regs][12][3]} {DebugOut[Regs][12][4]} {DebugOut[Regs][12][5]} {DebugOut[Regs][12][6]} {DebugOut[Regs][12][7]} {DebugOut[Regs][12][8]} {DebugOut[Regs][12][9]} {DebugOut[Regs][12][10]} {DebugOut[Regs][12][11]} {DebugOut[Regs][12][12]} {DebugOut[Regs][12][13]} {DebugOut[Regs][12][14]} {DebugOut[Regs][12][15]} {DebugOut[Regs][12][16]} {DebugOut[Regs][12][17]} {DebugOut[Regs][12][18]} {DebugOut[Regs][12][19]} {DebugOut[Regs][12][20]} {DebugOut[Regs][12][21]} {DebugOut[Regs][12][22]} {DebugOut[Regs][12][23]} {DebugOut[Regs][12][24]} {DebugOut[Regs][12][25]} {DebugOut[Regs][12][26]} {DebugOut[Regs][12][27]} {DebugOut[Regs][12][28]} {DebugOut[Regs][12][29]} {DebugOut[Regs][12][30]} {DebugOut[Regs][12][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 32 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {DebugOut[Regs][5][0]} {DebugOut[Regs][5][1]} {DebugOut[Regs][5][2]} {DebugOut[Regs][5][3]} {DebugOut[Regs][5][4]} {DebugOut[Regs][5][5]} {DebugOut[Regs][5][6]} {DebugOut[Regs][5][7]} {DebugOut[Regs][5][8]} {DebugOut[Regs][5][9]} {DebugOut[Regs][5][10]} {DebugOut[Regs][5][11]} {DebugOut[Regs][5][12]} {DebugOut[Regs][5][13]} {DebugOut[Regs][5][14]} {DebugOut[Regs][5][15]} {DebugOut[Regs][5][16]} {DebugOut[Regs][5][17]} {DebugOut[Regs][5][18]} {DebugOut[Regs][5][19]} {DebugOut[Regs][5][20]} {DebugOut[Regs][5][21]} {DebugOut[Regs][5][22]} {DebugOut[Regs][5][23]} {DebugOut[Regs][5][24]} {DebugOut[Regs][5][25]} {DebugOut[Regs][5][26]} {DebugOut[Regs][5][27]} {DebugOut[Regs][5][28]} {DebugOut[Regs][5][29]} {DebugOut[Regs][5][30]} {DebugOut[Regs][5][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 8 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {TxByte[0]} {TxByte[1]} {TxByte[2]} {TxByte[3]} {TxByte[4]} {TxByte[5]} {TxByte[6]} {TxByte[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 12 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {DebugIn[BreakPoints][1][0]} {DebugIn[BreakPoints][1][1]} {DebugIn[BreakPoints][1][2]} {DebugIn[BreakPoints][1][3]} {DebugIn[BreakPoints][1][4]} {DebugIn[BreakPoints][1][5]} {DebugIn[BreakPoints][1][6]} {DebugIn[BreakPoints][1][7]} {DebugIn[BreakPoints][1][8]} {DebugIn[BreakPoints][1][9]} {DebugIn[BreakPoints][1][10]} {DebugIn[BreakPoints][1][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 12 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {DebugIn[BreakPoints][3][0]} {DebugIn[BreakPoints][3][1]} {DebugIn[BreakPoints][3][2]} {DebugIn[BreakPoints][3][3]} {DebugIn[BreakPoints][3][4]} {DebugIn[BreakPoints][3][5]} {DebugIn[BreakPoints][3][6]} {DebugIn[BreakPoints][3][7]} {DebugIn[BreakPoints][3][8]} {DebugIn[BreakPoints][3][9]} {DebugIn[BreakPoints][3][10]} {DebugIn[BreakPoints][3][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 32 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {DebugOut[Regs][0][0]} {DebugOut[Regs][0][1]} {DebugOut[Regs][0][2]} {DebugOut[Regs][0][3]} {DebugOut[Regs][0][4]} {DebugOut[Regs][0][5]} {DebugOut[Regs][0][6]} {DebugOut[Regs][0][7]} {DebugOut[Regs][0][8]} {DebugOut[Regs][0][9]} {DebugOut[Regs][0][10]} {DebugOut[Regs][0][11]} {DebugOut[Regs][0][12]} {DebugOut[Regs][0][13]} {DebugOut[Regs][0][14]} {DebugOut[Regs][0][15]} {DebugOut[Regs][0][16]} {DebugOut[Regs][0][17]} {DebugOut[Regs][0][18]} {DebugOut[Regs][0][19]} {DebugOut[Regs][0][20]} {DebugOut[Regs][0][21]} {DebugOut[Regs][0][22]} {DebugOut[Regs][0][23]} {DebugOut[Regs][0][24]} {DebugOut[Regs][0][25]} {DebugOut[Regs][0][26]} {DebugOut[Regs][0][27]} {DebugOut[Regs][0][28]} {DebugOut[Regs][0][29]} {DebugOut[Regs][0][30]} {DebugOut[Regs][0][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 32 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {DebugOut[Regs][7][0]} {DebugOut[Regs][7][1]} {DebugOut[Regs][7][2]} {DebugOut[Regs][7][3]} {DebugOut[Regs][7][4]} {DebugOut[Regs][7][5]} {DebugOut[Regs][7][6]} {DebugOut[Regs][7][7]} {DebugOut[Regs][7][8]} {DebugOut[Regs][7][9]} {DebugOut[Regs][7][10]} {DebugOut[Regs][7][11]} {DebugOut[Regs][7][12]} {DebugOut[Regs][7][13]} {DebugOut[Regs][7][14]} {DebugOut[Regs][7][15]} {DebugOut[Regs][7][16]} {DebugOut[Regs][7][17]} {DebugOut[Regs][7][18]} {DebugOut[Regs][7][19]} {DebugOut[Regs][7][20]} {DebugOut[Regs][7][21]} {DebugOut[Regs][7][22]} {DebugOut[Regs][7][23]} {DebugOut[Regs][7][24]} {DebugOut[Regs][7][25]} {DebugOut[Regs][7][26]} {DebugOut[Regs][7][27]} {DebugOut[Regs][7][28]} {DebugOut[Regs][7][29]} {DebugOut[Regs][7][30]} {DebugOut[Regs][7][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 32 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {DebugOut[Regs][13][0]} {DebugOut[Regs][13][1]} {DebugOut[Regs][13][2]} {DebugOut[Regs][13][3]} {DebugOut[Regs][13][4]} {DebugOut[Regs][13][5]} {DebugOut[Regs][13][6]} {DebugOut[Regs][13][7]} {DebugOut[Regs][13][8]} {DebugOut[Regs][13][9]} {DebugOut[Regs][13][10]} {DebugOut[Regs][13][11]} {DebugOut[Regs][13][12]} {DebugOut[Regs][13][13]} {DebugOut[Regs][13][14]} {DebugOut[Regs][13][15]} {DebugOut[Regs][13][16]} {DebugOut[Regs][13][17]} {DebugOut[Regs][13][18]} {DebugOut[Regs][13][19]} {DebugOut[Regs][13][20]} {DebugOut[Regs][13][21]} {DebugOut[Regs][13][22]} {DebugOut[Regs][13][23]} {DebugOut[Regs][13][24]} {DebugOut[Regs][13][25]} {DebugOut[Regs][13][26]} {DebugOut[Regs][13][27]} {DebugOut[Regs][13][28]} {DebugOut[Regs][13][29]} {DebugOut[Regs][13][30]} {DebugOut[Regs][13][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 32 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {DebugOut[Regs][15][0]} {DebugOut[Regs][15][1]} {DebugOut[Regs][15][2]} {DebugOut[Regs][15][3]} {DebugOut[Regs][15][4]} {DebugOut[Regs][15][5]} {DebugOut[Regs][15][6]} {DebugOut[Regs][15][7]} {DebugOut[Regs][15][8]} {DebugOut[Regs][15][9]} {DebugOut[Regs][15][10]} {DebugOut[Regs][15][11]} {DebugOut[Regs][15][12]} {DebugOut[Regs][15][13]} {DebugOut[Regs][15][14]} {DebugOut[Regs][15][15]} {DebugOut[Regs][15][16]} {DebugOut[Regs][15][17]} {DebugOut[Regs][15][18]} {DebugOut[Regs][15][19]} {DebugOut[Regs][15][20]} {DebugOut[Regs][15][21]} {DebugOut[Regs][15][22]} {DebugOut[Regs][15][23]} {DebugOut[Regs][15][24]} {DebugOut[Regs][15][25]} {DebugOut[Regs][15][26]} {DebugOut[Regs][15][27]} {DebugOut[Regs][15][28]} {DebugOut[Regs][15][29]} {DebugOut[Regs][15][30]} {DebugOut[Regs][15][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 32 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {DebugOut[Regs][6][0]} {DebugOut[Regs][6][1]} {DebugOut[Regs][6][2]} {DebugOut[Regs][6][3]} {DebugOut[Regs][6][4]} {DebugOut[Regs][6][5]} {DebugOut[Regs][6][6]} {DebugOut[Regs][6][7]} {DebugOut[Regs][6][8]} {DebugOut[Regs][6][9]} {DebugOut[Regs][6][10]} {DebugOut[Regs][6][11]} {DebugOut[Regs][6][12]} {DebugOut[Regs][6][13]} {DebugOut[Regs][6][14]} {DebugOut[Regs][6][15]} {DebugOut[Regs][6][16]} {DebugOut[Regs][6][17]} {DebugOut[Regs][6][18]} {DebugOut[Regs][6][19]} {DebugOut[Regs][6][20]} {DebugOut[Regs][6][21]} {DebugOut[Regs][6][22]} {DebugOut[Regs][6][23]} {DebugOut[Regs][6][24]} {DebugOut[Regs][6][25]} {DebugOut[Regs][6][26]} {DebugOut[Regs][6][27]} {DebugOut[Regs][6][28]} {DebugOut[Regs][6][29]} {DebugOut[Regs][6][30]} {DebugOut[Regs][6][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 32 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {DebugOut[Regs][3][0]} {DebugOut[Regs][3][1]} {DebugOut[Regs][3][2]} {DebugOut[Regs][3][3]} {DebugOut[Regs][3][4]} {DebugOut[Regs][3][5]} {DebugOut[Regs][3][6]} {DebugOut[Regs][3][7]} {DebugOut[Regs][3][8]} {DebugOut[Regs][3][9]} {DebugOut[Regs][3][10]} {DebugOut[Regs][3][11]} {DebugOut[Regs][3][12]} {DebugOut[Regs][3][13]} {DebugOut[Regs][3][14]} {DebugOut[Regs][3][15]} {DebugOut[Regs][3][16]} {DebugOut[Regs][3][17]} {DebugOut[Regs][3][18]} {DebugOut[Regs][3][19]} {DebugOut[Regs][3][20]} {DebugOut[Regs][3][21]} {DebugOut[Regs][3][22]} {DebugOut[Regs][3][23]} {DebugOut[Regs][3][24]} {DebugOut[Regs][3][25]} {DebugOut[Regs][3][26]} {DebugOut[Regs][3][27]} {DebugOut[Regs][3][28]} {DebugOut[Regs][3][29]} {DebugOut[Regs][3][30]} {DebugOut[Regs][3][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 32 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {DebugOut[Regs][9][0]} {DebugOut[Regs][9][1]} {DebugOut[Regs][9][2]} {DebugOut[Regs][9][3]} {DebugOut[Regs][9][4]} {DebugOut[Regs][9][5]} {DebugOut[Regs][9][6]} {DebugOut[Regs][9][7]} {DebugOut[Regs][9][8]} {DebugOut[Regs][9][9]} {DebugOut[Regs][9][10]} {DebugOut[Regs][9][11]} {DebugOut[Regs][9][12]} {DebugOut[Regs][9][13]} {DebugOut[Regs][9][14]} {DebugOut[Regs][9][15]} {DebugOut[Regs][9][16]} {DebugOut[Regs][9][17]} {DebugOut[Regs][9][18]} {DebugOut[Regs][9][19]} {DebugOut[Regs][9][20]} {DebugOut[Regs][9][21]} {DebugOut[Regs][9][22]} {DebugOut[Regs][9][23]} {DebugOut[Regs][9][24]} {DebugOut[Regs][9][25]} {DebugOut[Regs][9][26]} {DebugOut[Regs][9][27]} {DebugOut[Regs][9][28]} {DebugOut[Regs][9][29]} {DebugOut[Regs][9][30]} {DebugOut[Regs][9][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 32 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {DebugOut[Regs][10][0]} {DebugOut[Regs][10][1]} {DebugOut[Regs][10][2]} {DebugOut[Regs][10][3]} {DebugOut[Regs][10][4]} {DebugOut[Regs][10][5]} {DebugOut[Regs][10][6]} {DebugOut[Regs][10][7]} {DebugOut[Regs][10][8]} {DebugOut[Regs][10][9]} {DebugOut[Regs][10][10]} {DebugOut[Regs][10][11]} {DebugOut[Regs][10][12]} {DebugOut[Regs][10][13]} {DebugOut[Regs][10][14]} {DebugOut[Regs][10][15]} {DebugOut[Regs][10][16]} {DebugOut[Regs][10][17]} {DebugOut[Regs][10][18]} {DebugOut[Regs][10][19]} {DebugOut[Regs][10][20]} {DebugOut[Regs][10][21]} {DebugOut[Regs][10][22]} {DebugOut[Regs][10][23]} {DebugOut[Regs][10][24]} {DebugOut[Regs][10][25]} {DebugOut[Regs][10][26]} {DebugOut[Regs][10][27]} {DebugOut[Regs][10][28]} {DebugOut[Regs][10][29]} {DebugOut[Regs][10][30]} {DebugOut[Regs][10][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 12 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {DebugIn[BreakPoints][2][0]} {DebugIn[BreakPoints][2][1]} {DebugIn[BreakPoints][2][2]} {DebugIn[BreakPoints][2][3]} {DebugIn[BreakPoints][2][4]} {DebugIn[BreakPoints][2][5]} {DebugIn[BreakPoints][2][6]} {DebugIn[BreakPoints][2][7]} {DebugIn[BreakPoints][2][8]} {DebugIn[BreakPoints][2][9]} {DebugIn[BreakPoints][2][10]} {DebugIn[BreakPoints][2][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 3 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {interrupt[0]} {interrupt[2]} {interrupt[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list dbreak_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list dcont_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {DebugIn[Break]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {DebugIn[Continue]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {DebugIn[DebugMode]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {DebugIn[Step]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list {DebugOut[Stopped]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list dstep_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list p_0_in12_in]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list TxAvail]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets SYS_CLK_IBUF_BUFG]
