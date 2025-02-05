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

set_operating_conditions -design_power_budget 10.0





create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list SYS_CLK_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 64 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {cpu1/alu_entity/product[0]} {cpu1/alu_entity/product[1]} {cpu1/alu_entity/product[2]} {cpu1/alu_entity/product[3]} {cpu1/alu_entity/product[4]} {cpu1/alu_entity/product[5]} {cpu1/alu_entity/product[6]} {cpu1/alu_entity/product[7]} {cpu1/alu_entity/product[8]} {cpu1/alu_entity/product[9]} {cpu1/alu_entity/product[10]} {cpu1/alu_entity/product[11]} {cpu1/alu_entity/product[12]} {cpu1/alu_entity/product[13]} {cpu1/alu_entity/product[14]} {cpu1/alu_entity/product[15]} {cpu1/alu_entity/product[16]} {cpu1/alu_entity/product[17]} {cpu1/alu_entity/product[18]} {cpu1/alu_entity/product[19]} {cpu1/alu_entity/product[20]} {cpu1/alu_entity/product[21]} {cpu1/alu_entity/product[22]} {cpu1/alu_entity/product[23]} {cpu1/alu_entity/product[24]} {cpu1/alu_entity/product[25]} {cpu1/alu_entity/product[26]} {cpu1/alu_entity/product[27]} {cpu1/alu_entity/product[28]} {cpu1/alu_entity/product[29]} {cpu1/alu_entity/product[30]} {cpu1/alu_entity/product[31]} {cpu1/alu_entity/product[32]} {cpu1/alu_entity/product[33]} {cpu1/alu_entity/product[34]} {cpu1/alu_entity/product[35]} {cpu1/alu_entity/product[36]} {cpu1/alu_entity/product[37]} {cpu1/alu_entity/product[38]} {cpu1/alu_entity/product[39]} {cpu1/alu_entity/product[40]} {cpu1/alu_entity/product[41]} {cpu1/alu_entity/product[42]} {cpu1/alu_entity/product[43]} {cpu1/alu_entity/product[44]} {cpu1/alu_entity/product[45]} {cpu1/alu_entity/product[46]} {cpu1/alu_entity/product[47]} {cpu1/alu_entity/product[48]} {cpu1/alu_entity/product[49]} {cpu1/alu_entity/product[50]} {cpu1/alu_entity/product[51]} {cpu1/alu_entity/product[52]} {cpu1/alu_entity/product[53]} {cpu1/alu_entity/product[54]} {cpu1/alu_entity/product[55]} {cpu1/alu_entity/product[56]} {cpu1/alu_entity/product[57]} {cpu1/alu_entity/product[58]} {cpu1/alu_entity/product[59]} {cpu1/alu_entity/product[60]} {cpu1/alu_entity/product[61]} {cpu1/alu_entity/product[62]} {cpu1/alu_entity/product[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {cpu1/cpuRegs[14][Countdown][0]} {cpu1/cpuRegs[14][Countdown][1]} {cpu1/cpuRegs[14][Countdown][2]} {cpu1/cpuRegs[14][Countdown][3]} {cpu1/cpuRegs[14][Countdown][4]} {cpu1/cpuRegs[14][Countdown][5]} {cpu1/cpuRegs[14][Countdown][6]} {cpu1/cpuRegs[14][Countdown][7]} {cpu1/cpuRegs[14][Countdown][8]} {cpu1/cpuRegs[14][Countdown][9]} {cpu1/cpuRegs[14][Countdown][10]} {cpu1/cpuRegs[14][Countdown][11]} {cpu1/cpuRegs[14][Countdown][12]} {cpu1/cpuRegs[14][Countdown][13]} {cpu1/cpuRegs[14][Countdown][14]} {cpu1/cpuRegs[14][Countdown][15]} {cpu1/cpuRegs[14][Countdown][16]} {cpu1/cpuRegs[14][Countdown][17]} {cpu1/cpuRegs[14][Countdown][18]} {cpu1/cpuRegs[14][Countdown][19]} {cpu1/cpuRegs[14][Countdown][20]} {cpu1/cpuRegs[14][Countdown][21]} {cpu1/cpuRegs[14][Countdown][22]} {cpu1/cpuRegs[14][Countdown][23]} {cpu1/cpuRegs[14][Countdown][24]} {cpu1/cpuRegs[14][Countdown][25]} {cpu1/cpuRegs[14][Countdown][26]} {cpu1/cpuRegs[14][Countdown][27]} {cpu1/cpuRegs[14][Countdown][28]} {cpu1/cpuRegs[14][Countdown][29]} {cpu1/cpuRegs[14][Countdown][30]} {cpu1/cpuRegs[14][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe2]
set_property port_width 5 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {cpu1/cpuRegs[8][OpCode][0]} {cpu1/cpuRegs[8][OpCode][1]} {cpu1/cpuRegs[8][OpCode][2]} {cpu1/cpuRegs[8][OpCode][3]} {cpu1/cpuRegs[8][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe3]
set_property port_width 5 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {cpu1/cpuRegs[0][OpCode][0]} {cpu1/cpuRegs[0][OpCode][1]} {cpu1/cpuRegs[0][OpCode][2]} {cpu1/cpuRegs[0][OpCode][3]} {cpu1/cpuRegs[0][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe4]
set_property port_width 5 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {cpu1/cpuRegs[13][OpCode][0]} {cpu1/cpuRegs[13][OpCode][1]} {cpu1/cpuRegs[13][OpCode][2]} {cpu1/cpuRegs[13][OpCode][3]} {cpu1/cpuRegs[13][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe5]
set_property port_width 5 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {cpu1/cpuRegs[15][OpCode][0]} {cpu1/cpuRegs[15][OpCode][1]} {cpu1/cpuRegs[15][OpCode][2]} {cpu1/cpuRegs[15][OpCode][3]} {cpu1/cpuRegs[15][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {cpu1/cpuRegs[8][Value][0]} {cpu1/cpuRegs[8][Value][1]} {cpu1/cpuRegs[8][Value][2]} {cpu1/cpuRegs[8][Value][3]} {cpu1/cpuRegs[8][Value][4]} {cpu1/cpuRegs[8][Value][5]} {cpu1/cpuRegs[8][Value][6]} {cpu1/cpuRegs[8][Value][7]} {cpu1/cpuRegs[8][Value][8]} {cpu1/cpuRegs[8][Value][9]} {cpu1/cpuRegs[8][Value][10]} {cpu1/cpuRegs[8][Value][11]} {cpu1/cpuRegs[8][Value][12]} {cpu1/cpuRegs[8][Value][13]} {cpu1/cpuRegs[8][Value][14]} {cpu1/cpuRegs[8][Value][15]} {cpu1/cpuRegs[8][Value][16]} {cpu1/cpuRegs[8][Value][17]} {cpu1/cpuRegs[8][Value][18]} {cpu1/cpuRegs[8][Value][19]} {cpu1/cpuRegs[8][Value][20]} {cpu1/cpuRegs[8][Value][21]} {cpu1/cpuRegs[8][Value][22]} {cpu1/cpuRegs[8][Value][23]} {cpu1/cpuRegs[8][Value][24]} {cpu1/cpuRegs[8][Value][25]} {cpu1/cpuRegs[8][Value][26]} {cpu1/cpuRegs[8][Value][27]} {cpu1/cpuRegs[8][Value][28]} {cpu1/cpuRegs[8][Value][29]} {cpu1/cpuRegs[8][Value][30]} {cpu1/cpuRegs[8][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {cpu1/cpuRegs[15][Countdown][0]} {cpu1/cpuRegs[15][Countdown][1]} {cpu1/cpuRegs[15][Countdown][2]} {cpu1/cpuRegs[15][Countdown][3]} {cpu1/cpuRegs[15][Countdown][4]} {cpu1/cpuRegs[15][Countdown][5]} {cpu1/cpuRegs[15][Countdown][6]} {cpu1/cpuRegs[15][Countdown][7]} {cpu1/cpuRegs[15][Countdown][8]} {cpu1/cpuRegs[15][Countdown][9]} {cpu1/cpuRegs[15][Countdown][10]} {cpu1/cpuRegs[15][Countdown][11]} {cpu1/cpuRegs[15][Countdown][12]} {cpu1/cpuRegs[15][Countdown][13]} {cpu1/cpuRegs[15][Countdown][14]} {cpu1/cpuRegs[15][Countdown][15]} {cpu1/cpuRegs[15][Countdown][16]} {cpu1/cpuRegs[15][Countdown][17]} {cpu1/cpuRegs[15][Countdown][18]} {cpu1/cpuRegs[15][Countdown][19]} {cpu1/cpuRegs[15][Countdown][20]} {cpu1/cpuRegs[15][Countdown][21]} {cpu1/cpuRegs[15][Countdown][22]} {cpu1/cpuRegs[15][Countdown][23]} {cpu1/cpuRegs[15][Countdown][24]} {cpu1/cpuRegs[15][Countdown][25]} {cpu1/cpuRegs[15][Countdown][26]} {cpu1/cpuRegs[15][Countdown][27]} {cpu1/cpuRegs[15][Countdown][28]} {cpu1/cpuRegs[15][Countdown][29]} {cpu1/cpuRegs[15][Countdown][30]} {cpu1/cpuRegs[15][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {cpu1/cpuRegs[0][Countdown][0]} {cpu1/cpuRegs[0][Countdown][1]} {cpu1/cpuRegs[0][Countdown][2]} {cpu1/cpuRegs[0][Countdown][3]} {cpu1/cpuRegs[0][Countdown][4]} {cpu1/cpuRegs[0][Countdown][5]} {cpu1/cpuRegs[0][Countdown][6]} {cpu1/cpuRegs[0][Countdown][7]} {cpu1/cpuRegs[0][Countdown][8]} {cpu1/cpuRegs[0][Countdown][9]} {cpu1/cpuRegs[0][Countdown][10]} {cpu1/cpuRegs[0][Countdown][11]} {cpu1/cpuRegs[0][Countdown][12]} {cpu1/cpuRegs[0][Countdown][13]} {cpu1/cpuRegs[0][Countdown][14]} {cpu1/cpuRegs[0][Countdown][15]} {cpu1/cpuRegs[0][Countdown][16]} {cpu1/cpuRegs[0][Countdown][17]} {cpu1/cpuRegs[0][Countdown][18]} {cpu1/cpuRegs[0][Countdown][19]} {cpu1/cpuRegs[0][Countdown][20]} {cpu1/cpuRegs[0][Countdown][21]} {cpu1/cpuRegs[0][Countdown][22]} {cpu1/cpuRegs[0][Countdown][23]} {cpu1/cpuRegs[0][Countdown][24]} {cpu1/cpuRegs[0][Countdown][25]} {cpu1/cpuRegs[0][Countdown][26]} {cpu1/cpuRegs[0][Countdown][27]} {cpu1/cpuRegs[0][Countdown][28]} {cpu1/cpuRegs[0][Countdown][29]} {cpu1/cpuRegs[0][Countdown][30]} {cpu1/cpuRegs[0][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe9]
set_property port_width 32 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {cpu1/cpuRegs[11][Value][0]} {cpu1/cpuRegs[11][Value][1]} {cpu1/cpuRegs[11][Value][2]} {cpu1/cpuRegs[11][Value][3]} {cpu1/cpuRegs[11][Value][4]} {cpu1/cpuRegs[11][Value][5]} {cpu1/cpuRegs[11][Value][6]} {cpu1/cpuRegs[11][Value][7]} {cpu1/cpuRegs[11][Value][8]} {cpu1/cpuRegs[11][Value][9]} {cpu1/cpuRegs[11][Value][10]} {cpu1/cpuRegs[11][Value][11]} {cpu1/cpuRegs[11][Value][12]} {cpu1/cpuRegs[11][Value][13]} {cpu1/cpuRegs[11][Value][14]} {cpu1/cpuRegs[11][Value][15]} {cpu1/cpuRegs[11][Value][16]} {cpu1/cpuRegs[11][Value][17]} {cpu1/cpuRegs[11][Value][18]} {cpu1/cpuRegs[11][Value][19]} {cpu1/cpuRegs[11][Value][20]} {cpu1/cpuRegs[11][Value][21]} {cpu1/cpuRegs[11][Value][22]} {cpu1/cpuRegs[11][Value][23]} {cpu1/cpuRegs[11][Value][24]} {cpu1/cpuRegs[11][Value][25]} {cpu1/cpuRegs[11][Value][26]} {cpu1/cpuRegs[11][Value][27]} {cpu1/cpuRegs[11][Value][28]} {cpu1/cpuRegs[11][Value][29]} {cpu1/cpuRegs[11][Value][30]} {cpu1/cpuRegs[11][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe10]
set_property port_width 5 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {cpu1/cpuRegs[1][OpCode][0]} {cpu1/cpuRegs[1][OpCode][1]} {cpu1/cpuRegs[1][OpCode][2]} {cpu1/cpuRegs[1][OpCode][3]} {cpu1/cpuRegs[1][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe11]
set_property port_width 5 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {cpu1/cpuRegs[2][OpCode][0]} {cpu1/cpuRegs[2][OpCode][1]} {cpu1/cpuRegs[2][OpCode][2]} {cpu1/cpuRegs[2][OpCode][3]} {cpu1/cpuRegs[2][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe12]
set_property port_width 32 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {cpu1/cpuRegs[2][Value][0]} {cpu1/cpuRegs[2][Value][1]} {cpu1/cpuRegs[2][Value][2]} {cpu1/cpuRegs[2][Value][3]} {cpu1/cpuRegs[2][Value][4]} {cpu1/cpuRegs[2][Value][5]} {cpu1/cpuRegs[2][Value][6]} {cpu1/cpuRegs[2][Value][7]} {cpu1/cpuRegs[2][Value][8]} {cpu1/cpuRegs[2][Value][9]} {cpu1/cpuRegs[2][Value][10]} {cpu1/cpuRegs[2][Value][11]} {cpu1/cpuRegs[2][Value][12]} {cpu1/cpuRegs[2][Value][13]} {cpu1/cpuRegs[2][Value][14]} {cpu1/cpuRegs[2][Value][15]} {cpu1/cpuRegs[2][Value][16]} {cpu1/cpuRegs[2][Value][17]} {cpu1/cpuRegs[2][Value][18]} {cpu1/cpuRegs[2][Value][19]} {cpu1/cpuRegs[2][Value][20]} {cpu1/cpuRegs[2][Value][21]} {cpu1/cpuRegs[2][Value][22]} {cpu1/cpuRegs[2][Value][23]} {cpu1/cpuRegs[2][Value][24]} {cpu1/cpuRegs[2][Value][25]} {cpu1/cpuRegs[2][Value][26]} {cpu1/cpuRegs[2][Value][27]} {cpu1/cpuRegs[2][Value][28]} {cpu1/cpuRegs[2][Value][29]} {cpu1/cpuRegs[2][Value][30]} {cpu1/cpuRegs[2][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe13]
set_property port_width 32 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {cpu1/cpuRegs[13][Value][0]} {cpu1/cpuRegs[13][Value][1]} {cpu1/cpuRegs[13][Value][2]} {cpu1/cpuRegs[13][Value][3]} {cpu1/cpuRegs[13][Value][4]} {cpu1/cpuRegs[13][Value][5]} {cpu1/cpuRegs[13][Value][6]} {cpu1/cpuRegs[13][Value][7]} {cpu1/cpuRegs[13][Value][8]} {cpu1/cpuRegs[13][Value][9]} {cpu1/cpuRegs[13][Value][10]} {cpu1/cpuRegs[13][Value][11]} {cpu1/cpuRegs[13][Value][12]} {cpu1/cpuRegs[13][Value][13]} {cpu1/cpuRegs[13][Value][14]} {cpu1/cpuRegs[13][Value][15]} {cpu1/cpuRegs[13][Value][16]} {cpu1/cpuRegs[13][Value][17]} {cpu1/cpuRegs[13][Value][18]} {cpu1/cpuRegs[13][Value][19]} {cpu1/cpuRegs[13][Value][20]} {cpu1/cpuRegs[13][Value][21]} {cpu1/cpuRegs[13][Value][22]} {cpu1/cpuRegs[13][Value][23]} {cpu1/cpuRegs[13][Value][24]} {cpu1/cpuRegs[13][Value][25]} {cpu1/cpuRegs[13][Value][26]} {cpu1/cpuRegs[13][Value][27]} {cpu1/cpuRegs[13][Value][28]} {cpu1/cpuRegs[13][Value][29]} {cpu1/cpuRegs[13][Value][30]} {cpu1/cpuRegs[13][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe14]
set_property port_width 32 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {cpu1/cpuRegs[3][Countdown][0]} {cpu1/cpuRegs[3][Countdown][1]} {cpu1/cpuRegs[3][Countdown][2]} {cpu1/cpuRegs[3][Countdown][3]} {cpu1/cpuRegs[3][Countdown][4]} {cpu1/cpuRegs[3][Countdown][5]} {cpu1/cpuRegs[3][Countdown][6]} {cpu1/cpuRegs[3][Countdown][7]} {cpu1/cpuRegs[3][Countdown][8]} {cpu1/cpuRegs[3][Countdown][9]} {cpu1/cpuRegs[3][Countdown][10]} {cpu1/cpuRegs[3][Countdown][11]} {cpu1/cpuRegs[3][Countdown][12]} {cpu1/cpuRegs[3][Countdown][13]} {cpu1/cpuRegs[3][Countdown][14]} {cpu1/cpuRegs[3][Countdown][15]} {cpu1/cpuRegs[3][Countdown][16]} {cpu1/cpuRegs[3][Countdown][17]} {cpu1/cpuRegs[3][Countdown][18]} {cpu1/cpuRegs[3][Countdown][19]} {cpu1/cpuRegs[3][Countdown][20]} {cpu1/cpuRegs[3][Countdown][21]} {cpu1/cpuRegs[3][Countdown][22]} {cpu1/cpuRegs[3][Countdown][23]} {cpu1/cpuRegs[3][Countdown][24]} {cpu1/cpuRegs[3][Countdown][25]} {cpu1/cpuRegs[3][Countdown][26]} {cpu1/cpuRegs[3][Countdown][27]} {cpu1/cpuRegs[3][Countdown][28]} {cpu1/cpuRegs[3][Countdown][29]} {cpu1/cpuRegs[3][Countdown][30]} {cpu1/cpuRegs[3][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe15]
set_property port_width 5 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {cpu1/cpuRegs[10][OpCode][0]} {cpu1/cpuRegs[10][OpCode][1]} {cpu1/cpuRegs[10][OpCode][2]} {cpu1/cpuRegs[10][OpCode][3]} {cpu1/cpuRegs[10][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe16]
set_property port_width 32 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {cpu1/cpuRegs[13][Countdown][0]} {cpu1/cpuRegs[13][Countdown][1]} {cpu1/cpuRegs[13][Countdown][2]} {cpu1/cpuRegs[13][Countdown][3]} {cpu1/cpuRegs[13][Countdown][4]} {cpu1/cpuRegs[13][Countdown][5]} {cpu1/cpuRegs[13][Countdown][6]} {cpu1/cpuRegs[13][Countdown][7]} {cpu1/cpuRegs[13][Countdown][8]} {cpu1/cpuRegs[13][Countdown][9]} {cpu1/cpuRegs[13][Countdown][10]} {cpu1/cpuRegs[13][Countdown][11]} {cpu1/cpuRegs[13][Countdown][12]} {cpu1/cpuRegs[13][Countdown][13]} {cpu1/cpuRegs[13][Countdown][14]} {cpu1/cpuRegs[13][Countdown][15]} {cpu1/cpuRegs[13][Countdown][16]} {cpu1/cpuRegs[13][Countdown][17]} {cpu1/cpuRegs[13][Countdown][18]} {cpu1/cpuRegs[13][Countdown][19]} {cpu1/cpuRegs[13][Countdown][20]} {cpu1/cpuRegs[13][Countdown][21]} {cpu1/cpuRegs[13][Countdown][22]} {cpu1/cpuRegs[13][Countdown][23]} {cpu1/cpuRegs[13][Countdown][24]} {cpu1/cpuRegs[13][Countdown][25]} {cpu1/cpuRegs[13][Countdown][26]} {cpu1/cpuRegs[13][Countdown][27]} {cpu1/cpuRegs[13][Countdown][28]} {cpu1/cpuRegs[13][Countdown][29]} {cpu1/cpuRegs[13][Countdown][30]} {cpu1/cpuRegs[13][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe17]
set_property port_width 32 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {cpu1/cpuRegs[3][Value][0]} {cpu1/cpuRegs[3][Value][1]} {cpu1/cpuRegs[3][Value][2]} {cpu1/cpuRegs[3][Value][3]} {cpu1/cpuRegs[3][Value][4]} {cpu1/cpuRegs[3][Value][5]} {cpu1/cpuRegs[3][Value][6]} {cpu1/cpuRegs[3][Value][7]} {cpu1/cpuRegs[3][Value][8]} {cpu1/cpuRegs[3][Value][9]} {cpu1/cpuRegs[3][Value][10]} {cpu1/cpuRegs[3][Value][11]} {cpu1/cpuRegs[3][Value][12]} {cpu1/cpuRegs[3][Value][13]} {cpu1/cpuRegs[3][Value][14]} {cpu1/cpuRegs[3][Value][15]} {cpu1/cpuRegs[3][Value][16]} {cpu1/cpuRegs[3][Value][17]} {cpu1/cpuRegs[3][Value][18]} {cpu1/cpuRegs[3][Value][19]} {cpu1/cpuRegs[3][Value][20]} {cpu1/cpuRegs[3][Value][21]} {cpu1/cpuRegs[3][Value][22]} {cpu1/cpuRegs[3][Value][23]} {cpu1/cpuRegs[3][Value][24]} {cpu1/cpuRegs[3][Value][25]} {cpu1/cpuRegs[3][Value][26]} {cpu1/cpuRegs[3][Value][27]} {cpu1/cpuRegs[3][Value][28]} {cpu1/cpuRegs[3][Value][29]} {cpu1/cpuRegs[3][Value][30]} {cpu1/cpuRegs[3][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe18]
set_property port_width 32 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {cpu1/cpuRegs[10][Value][0]} {cpu1/cpuRegs[10][Value][1]} {cpu1/cpuRegs[10][Value][2]} {cpu1/cpuRegs[10][Value][3]} {cpu1/cpuRegs[10][Value][4]} {cpu1/cpuRegs[10][Value][5]} {cpu1/cpuRegs[10][Value][6]} {cpu1/cpuRegs[10][Value][7]} {cpu1/cpuRegs[10][Value][8]} {cpu1/cpuRegs[10][Value][9]} {cpu1/cpuRegs[10][Value][10]} {cpu1/cpuRegs[10][Value][11]} {cpu1/cpuRegs[10][Value][12]} {cpu1/cpuRegs[10][Value][13]} {cpu1/cpuRegs[10][Value][14]} {cpu1/cpuRegs[10][Value][15]} {cpu1/cpuRegs[10][Value][16]} {cpu1/cpuRegs[10][Value][17]} {cpu1/cpuRegs[10][Value][18]} {cpu1/cpuRegs[10][Value][19]} {cpu1/cpuRegs[10][Value][20]} {cpu1/cpuRegs[10][Value][21]} {cpu1/cpuRegs[10][Value][22]} {cpu1/cpuRegs[10][Value][23]} {cpu1/cpuRegs[10][Value][24]} {cpu1/cpuRegs[10][Value][25]} {cpu1/cpuRegs[10][Value][26]} {cpu1/cpuRegs[10][Value][27]} {cpu1/cpuRegs[10][Value][28]} {cpu1/cpuRegs[10][Value][29]} {cpu1/cpuRegs[10][Value][30]} {cpu1/cpuRegs[10][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe19]
set_property port_width 32 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {cpu1/cpuRegs[12][Value][0]} {cpu1/cpuRegs[12][Value][1]} {cpu1/cpuRegs[12][Value][2]} {cpu1/cpuRegs[12][Value][3]} {cpu1/cpuRegs[12][Value][4]} {cpu1/cpuRegs[12][Value][5]} {cpu1/cpuRegs[12][Value][6]} {cpu1/cpuRegs[12][Value][7]} {cpu1/cpuRegs[12][Value][8]} {cpu1/cpuRegs[12][Value][9]} {cpu1/cpuRegs[12][Value][10]} {cpu1/cpuRegs[12][Value][11]} {cpu1/cpuRegs[12][Value][12]} {cpu1/cpuRegs[12][Value][13]} {cpu1/cpuRegs[12][Value][14]} {cpu1/cpuRegs[12][Value][15]} {cpu1/cpuRegs[12][Value][16]} {cpu1/cpuRegs[12][Value][17]} {cpu1/cpuRegs[12][Value][18]} {cpu1/cpuRegs[12][Value][19]} {cpu1/cpuRegs[12][Value][20]} {cpu1/cpuRegs[12][Value][21]} {cpu1/cpuRegs[12][Value][22]} {cpu1/cpuRegs[12][Value][23]} {cpu1/cpuRegs[12][Value][24]} {cpu1/cpuRegs[12][Value][25]} {cpu1/cpuRegs[12][Value][26]} {cpu1/cpuRegs[12][Value][27]} {cpu1/cpuRegs[12][Value][28]} {cpu1/cpuRegs[12][Value][29]} {cpu1/cpuRegs[12][Value][30]} {cpu1/cpuRegs[12][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe20]
set_property port_width 32 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {cpu1/cpuRegs[0][Value][0]} {cpu1/cpuRegs[0][Value][1]} {cpu1/cpuRegs[0][Value][2]} {cpu1/cpuRegs[0][Value][3]} {cpu1/cpuRegs[0][Value][4]} {cpu1/cpuRegs[0][Value][5]} {cpu1/cpuRegs[0][Value][6]} {cpu1/cpuRegs[0][Value][7]} {cpu1/cpuRegs[0][Value][8]} {cpu1/cpuRegs[0][Value][9]} {cpu1/cpuRegs[0][Value][10]} {cpu1/cpuRegs[0][Value][11]} {cpu1/cpuRegs[0][Value][12]} {cpu1/cpuRegs[0][Value][13]} {cpu1/cpuRegs[0][Value][14]} {cpu1/cpuRegs[0][Value][15]} {cpu1/cpuRegs[0][Value][16]} {cpu1/cpuRegs[0][Value][17]} {cpu1/cpuRegs[0][Value][18]} {cpu1/cpuRegs[0][Value][19]} {cpu1/cpuRegs[0][Value][20]} {cpu1/cpuRegs[0][Value][21]} {cpu1/cpuRegs[0][Value][22]} {cpu1/cpuRegs[0][Value][23]} {cpu1/cpuRegs[0][Value][24]} {cpu1/cpuRegs[0][Value][25]} {cpu1/cpuRegs[0][Value][26]} {cpu1/cpuRegs[0][Value][27]} {cpu1/cpuRegs[0][Value][28]} {cpu1/cpuRegs[0][Value][29]} {cpu1/cpuRegs[0][Value][30]} {cpu1/cpuRegs[0][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 12 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {cpu1/ProgramCounter[0]} {cpu1/ProgramCounter[1]} {cpu1/ProgramCounter[2]} {cpu1/ProgramCounter[3]} {cpu1/ProgramCounter[4]} {cpu1/ProgramCounter[5]} {cpu1/ProgramCounter[6]} {cpu1/ProgramCounter[7]} {cpu1/ProgramCounter[8]} {cpu1/ProgramCounter[9]} {cpu1/ProgramCounter[10]} {cpu1/ProgramCounter[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe22]
set_property port_width 32 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {cpu1/cpuRegs[11][Countdown][0]} {cpu1/cpuRegs[11][Countdown][1]} {cpu1/cpuRegs[11][Countdown][2]} {cpu1/cpuRegs[11][Countdown][3]} {cpu1/cpuRegs[11][Countdown][4]} {cpu1/cpuRegs[11][Countdown][5]} {cpu1/cpuRegs[11][Countdown][6]} {cpu1/cpuRegs[11][Countdown][7]} {cpu1/cpuRegs[11][Countdown][8]} {cpu1/cpuRegs[11][Countdown][9]} {cpu1/cpuRegs[11][Countdown][10]} {cpu1/cpuRegs[11][Countdown][11]} {cpu1/cpuRegs[11][Countdown][12]} {cpu1/cpuRegs[11][Countdown][13]} {cpu1/cpuRegs[11][Countdown][14]} {cpu1/cpuRegs[11][Countdown][15]} {cpu1/cpuRegs[11][Countdown][16]} {cpu1/cpuRegs[11][Countdown][17]} {cpu1/cpuRegs[11][Countdown][18]} {cpu1/cpuRegs[11][Countdown][19]} {cpu1/cpuRegs[11][Countdown][20]} {cpu1/cpuRegs[11][Countdown][21]} {cpu1/cpuRegs[11][Countdown][22]} {cpu1/cpuRegs[11][Countdown][23]} {cpu1/cpuRegs[11][Countdown][24]} {cpu1/cpuRegs[11][Countdown][25]} {cpu1/cpuRegs[11][Countdown][26]} {cpu1/cpuRegs[11][Countdown][27]} {cpu1/cpuRegs[11][Countdown][28]} {cpu1/cpuRegs[11][Countdown][29]} {cpu1/cpuRegs[11][Countdown][30]} {cpu1/cpuRegs[11][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe23]
set_property port_width 32 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {cpu1/cpuRegs[14][Value][0]} {cpu1/cpuRegs[14][Value][1]} {cpu1/cpuRegs[14][Value][2]} {cpu1/cpuRegs[14][Value][3]} {cpu1/cpuRegs[14][Value][4]} {cpu1/cpuRegs[14][Value][5]} {cpu1/cpuRegs[14][Value][6]} {cpu1/cpuRegs[14][Value][7]} {cpu1/cpuRegs[14][Value][8]} {cpu1/cpuRegs[14][Value][9]} {cpu1/cpuRegs[14][Value][10]} {cpu1/cpuRegs[14][Value][11]} {cpu1/cpuRegs[14][Value][12]} {cpu1/cpuRegs[14][Value][13]} {cpu1/cpuRegs[14][Value][14]} {cpu1/cpuRegs[14][Value][15]} {cpu1/cpuRegs[14][Value][16]} {cpu1/cpuRegs[14][Value][17]} {cpu1/cpuRegs[14][Value][18]} {cpu1/cpuRegs[14][Value][19]} {cpu1/cpuRegs[14][Value][20]} {cpu1/cpuRegs[14][Value][21]} {cpu1/cpuRegs[14][Value][22]} {cpu1/cpuRegs[14][Value][23]} {cpu1/cpuRegs[14][Value][24]} {cpu1/cpuRegs[14][Value][25]} {cpu1/cpuRegs[14][Value][26]} {cpu1/cpuRegs[14][Value][27]} {cpu1/cpuRegs[14][Value][28]} {cpu1/cpuRegs[14][Value][29]} {cpu1/cpuRegs[14][Value][30]} {cpu1/cpuRegs[14][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe24]
set_property port_width 32 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {cpu1/cpuRegs[15][Value][0]} {cpu1/cpuRegs[15][Value][1]} {cpu1/cpuRegs[15][Value][2]} {cpu1/cpuRegs[15][Value][3]} {cpu1/cpuRegs[15][Value][4]} {cpu1/cpuRegs[15][Value][5]} {cpu1/cpuRegs[15][Value][6]} {cpu1/cpuRegs[15][Value][7]} {cpu1/cpuRegs[15][Value][8]} {cpu1/cpuRegs[15][Value][9]} {cpu1/cpuRegs[15][Value][10]} {cpu1/cpuRegs[15][Value][11]} {cpu1/cpuRegs[15][Value][12]} {cpu1/cpuRegs[15][Value][13]} {cpu1/cpuRegs[15][Value][14]} {cpu1/cpuRegs[15][Value][15]} {cpu1/cpuRegs[15][Value][16]} {cpu1/cpuRegs[15][Value][17]} {cpu1/cpuRegs[15][Value][18]} {cpu1/cpuRegs[15][Value][19]} {cpu1/cpuRegs[15][Value][20]} {cpu1/cpuRegs[15][Value][21]} {cpu1/cpuRegs[15][Value][22]} {cpu1/cpuRegs[15][Value][23]} {cpu1/cpuRegs[15][Value][24]} {cpu1/cpuRegs[15][Value][25]} {cpu1/cpuRegs[15][Value][26]} {cpu1/cpuRegs[15][Value][27]} {cpu1/cpuRegs[15][Value][28]} {cpu1/cpuRegs[15][Value][29]} {cpu1/cpuRegs[15][Value][30]} {cpu1/cpuRegs[15][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe25]
set_property port_width 32 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {cpu1/cpuRegs[2][Countdown][0]} {cpu1/cpuRegs[2][Countdown][1]} {cpu1/cpuRegs[2][Countdown][2]} {cpu1/cpuRegs[2][Countdown][3]} {cpu1/cpuRegs[2][Countdown][4]} {cpu1/cpuRegs[2][Countdown][5]} {cpu1/cpuRegs[2][Countdown][6]} {cpu1/cpuRegs[2][Countdown][7]} {cpu1/cpuRegs[2][Countdown][8]} {cpu1/cpuRegs[2][Countdown][9]} {cpu1/cpuRegs[2][Countdown][10]} {cpu1/cpuRegs[2][Countdown][11]} {cpu1/cpuRegs[2][Countdown][12]} {cpu1/cpuRegs[2][Countdown][13]} {cpu1/cpuRegs[2][Countdown][14]} {cpu1/cpuRegs[2][Countdown][15]} {cpu1/cpuRegs[2][Countdown][16]} {cpu1/cpuRegs[2][Countdown][17]} {cpu1/cpuRegs[2][Countdown][18]} {cpu1/cpuRegs[2][Countdown][19]} {cpu1/cpuRegs[2][Countdown][20]} {cpu1/cpuRegs[2][Countdown][21]} {cpu1/cpuRegs[2][Countdown][22]} {cpu1/cpuRegs[2][Countdown][23]} {cpu1/cpuRegs[2][Countdown][24]} {cpu1/cpuRegs[2][Countdown][25]} {cpu1/cpuRegs[2][Countdown][26]} {cpu1/cpuRegs[2][Countdown][27]} {cpu1/cpuRegs[2][Countdown][28]} {cpu1/cpuRegs[2][Countdown][29]} {cpu1/cpuRegs[2][Countdown][30]} {cpu1/cpuRegs[2][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe26]
set_property port_width 5 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {cpu1/cpuRegs[12][OpCode][0]} {cpu1/cpuRegs[12][OpCode][1]} {cpu1/cpuRegs[12][OpCode][2]} {cpu1/cpuRegs[12][OpCode][3]} {cpu1/cpuRegs[12][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe27]
set_property port_width 5 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {cpu1/cpuRegs[3][OpCode][0]} {cpu1/cpuRegs[3][OpCode][1]} {cpu1/cpuRegs[3][OpCode][2]} {cpu1/cpuRegs[3][OpCode][3]} {cpu1/cpuRegs[3][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe28]
set_property port_width 32 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {cpu1/cpuRegs[4][Countdown][0]} {cpu1/cpuRegs[4][Countdown][1]} {cpu1/cpuRegs[4][Countdown][2]} {cpu1/cpuRegs[4][Countdown][3]} {cpu1/cpuRegs[4][Countdown][4]} {cpu1/cpuRegs[4][Countdown][5]} {cpu1/cpuRegs[4][Countdown][6]} {cpu1/cpuRegs[4][Countdown][7]} {cpu1/cpuRegs[4][Countdown][8]} {cpu1/cpuRegs[4][Countdown][9]} {cpu1/cpuRegs[4][Countdown][10]} {cpu1/cpuRegs[4][Countdown][11]} {cpu1/cpuRegs[4][Countdown][12]} {cpu1/cpuRegs[4][Countdown][13]} {cpu1/cpuRegs[4][Countdown][14]} {cpu1/cpuRegs[4][Countdown][15]} {cpu1/cpuRegs[4][Countdown][16]} {cpu1/cpuRegs[4][Countdown][17]} {cpu1/cpuRegs[4][Countdown][18]} {cpu1/cpuRegs[4][Countdown][19]} {cpu1/cpuRegs[4][Countdown][20]} {cpu1/cpuRegs[4][Countdown][21]} {cpu1/cpuRegs[4][Countdown][22]} {cpu1/cpuRegs[4][Countdown][23]} {cpu1/cpuRegs[4][Countdown][24]} {cpu1/cpuRegs[4][Countdown][25]} {cpu1/cpuRegs[4][Countdown][26]} {cpu1/cpuRegs[4][Countdown][27]} {cpu1/cpuRegs[4][Countdown][28]} {cpu1/cpuRegs[4][Countdown][29]} {cpu1/cpuRegs[4][Countdown][30]} {cpu1/cpuRegs[4][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe29]
set_property port_width 32 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {cpu1/cpuRegs[5][Countdown][0]} {cpu1/cpuRegs[5][Countdown][1]} {cpu1/cpuRegs[5][Countdown][2]} {cpu1/cpuRegs[5][Countdown][3]} {cpu1/cpuRegs[5][Countdown][4]} {cpu1/cpuRegs[5][Countdown][5]} {cpu1/cpuRegs[5][Countdown][6]} {cpu1/cpuRegs[5][Countdown][7]} {cpu1/cpuRegs[5][Countdown][8]} {cpu1/cpuRegs[5][Countdown][9]} {cpu1/cpuRegs[5][Countdown][10]} {cpu1/cpuRegs[5][Countdown][11]} {cpu1/cpuRegs[5][Countdown][12]} {cpu1/cpuRegs[5][Countdown][13]} {cpu1/cpuRegs[5][Countdown][14]} {cpu1/cpuRegs[5][Countdown][15]} {cpu1/cpuRegs[5][Countdown][16]} {cpu1/cpuRegs[5][Countdown][17]} {cpu1/cpuRegs[5][Countdown][18]} {cpu1/cpuRegs[5][Countdown][19]} {cpu1/cpuRegs[5][Countdown][20]} {cpu1/cpuRegs[5][Countdown][21]} {cpu1/cpuRegs[5][Countdown][22]} {cpu1/cpuRegs[5][Countdown][23]} {cpu1/cpuRegs[5][Countdown][24]} {cpu1/cpuRegs[5][Countdown][25]} {cpu1/cpuRegs[5][Countdown][26]} {cpu1/cpuRegs[5][Countdown][27]} {cpu1/cpuRegs[5][Countdown][28]} {cpu1/cpuRegs[5][Countdown][29]} {cpu1/cpuRegs[5][Countdown][30]} {cpu1/cpuRegs[5][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe30]
set_property port_width 5 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {cpu1/cpuRegs[6][OpCode][0]} {cpu1/cpuRegs[6][OpCode][1]} {cpu1/cpuRegs[6][OpCode][2]} {cpu1/cpuRegs[6][OpCode][3]} {cpu1/cpuRegs[6][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe31]
set_property port_width 32 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {cpu1/cpuRegs[10][Countdown][0]} {cpu1/cpuRegs[10][Countdown][1]} {cpu1/cpuRegs[10][Countdown][2]} {cpu1/cpuRegs[10][Countdown][3]} {cpu1/cpuRegs[10][Countdown][4]} {cpu1/cpuRegs[10][Countdown][5]} {cpu1/cpuRegs[10][Countdown][6]} {cpu1/cpuRegs[10][Countdown][7]} {cpu1/cpuRegs[10][Countdown][8]} {cpu1/cpuRegs[10][Countdown][9]} {cpu1/cpuRegs[10][Countdown][10]} {cpu1/cpuRegs[10][Countdown][11]} {cpu1/cpuRegs[10][Countdown][12]} {cpu1/cpuRegs[10][Countdown][13]} {cpu1/cpuRegs[10][Countdown][14]} {cpu1/cpuRegs[10][Countdown][15]} {cpu1/cpuRegs[10][Countdown][16]} {cpu1/cpuRegs[10][Countdown][17]} {cpu1/cpuRegs[10][Countdown][18]} {cpu1/cpuRegs[10][Countdown][19]} {cpu1/cpuRegs[10][Countdown][20]} {cpu1/cpuRegs[10][Countdown][21]} {cpu1/cpuRegs[10][Countdown][22]} {cpu1/cpuRegs[10][Countdown][23]} {cpu1/cpuRegs[10][Countdown][24]} {cpu1/cpuRegs[10][Countdown][25]} {cpu1/cpuRegs[10][Countdown][26]} {cpu1/cpuRegs[10][Countdown][27]} {cpu1/cpuRegs[10][Countdown][28]} {cpu1/cpuRegs[10][Countdown][29]} {cpu1/cpuRegs[10][Countdown][30]} {cpu1/cpuRegs[10][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe32]
set_property port_width 5 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list {cpu1/cpuRegs[14][OpCode][0]} {cpu1/cpuRegs[14][OpCode][1]} {cpu1/cpuRegs[14][OpCode][2]} {cpu1/cpuRegs[14][OpCode][3]} {cpu1/cpuRegs[14][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe33]
set_property port_width 32 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list {cpu1/cpuRegs[1][Countdown][0]} {cpu1/cpuRegs[1][Countdown][1]} {cpu1/cpuRegs[1][Countdown][2]} {cpu1/cpuRegs[1][Countdown][3]} {cpu1/cpuRegs[1][Countdown][4]} {cpu1/cpuRegs[1][Countdown][5]} {cpu1/cpuRegs[1][Countdown][6]} {cpu1/cpuRegs[1][Countdown][7]} {cpu1/cpuRegs[1][Countdown][8]} {cpu1/cpuRegs[1][Countdown][9]} {cpu1/cpuRegs[1][Countdown][10]} {cpu1/cpuRegs[1][Countdown][11]} {cpu1/cpuRegs[1][Countdown][12]} {cpu1/cpuRegs[1][Countdown][13]} {cpu1/cpuRegs[1][Countdown][14]} {cpu1/cpuRegs[1][Countdown][15]} {cpu1/cpuRegs[1][Countdown][16]} {cpu1/cpuRegs[1][Countdown][17]} {cpu1/cpuRegs[1][Countdown][18]} {cpu1/cpuRegs[1][Countdown][19]} {cpu1/cpuRegs[1][Countdown][20]} {cpu1/cpuRegs[1][Countdown][21]} {cpu1/cpuRegs[1][Countdown][22]} {cpu1/cpuRegs[1][Countdown][23]} {cpu1/cpuRegs[1][Countdown][24]} {cpu1/cpuRegs[1][Countdown][25]} {cpu1/cpuRegs[1][Countdown][26]} {cpu1/cpuRegs[1][Countdown][27]} {cpu1/cpuRegs[1][Countdown][28]} {cpu1/cpuRegs[1][Countdown][29]} {cpu1/cpuRegs[1][Countdown][30]} {cpu1/cpuRegs[1][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe34]
set_property port_width 32 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list {cpu1/cpuRegs[4][Value][0]} {cpu1/cpuRegs[4][Value][1]} {cpu1/cpuRegs[4][Value][2]} {cpu1/cpuRegs[4][Value][3]} {cpu1/cpuRegs[4][Value][4]} {cpu1/cpuRegs[4][Value][5]} {cpu1/cpuRegs[4][Value][6]} {cpu1/cpuRegs[4][Value][7]} {cpu1/cpuRegs[4][Value][8]} {cpu1/cpuRegs[4][Value][9]} {cpu1/cpuRegs[4][Value][10]} {cpu1/cpuRegs[4][Value][11]} {cpu1/cpuRegs[4][Value][12]} {cpu1/cpuRegs[4][Value][13]} {cpu1/cpuRegs[4][Value][14]} {cpu1/cpuRegs[4][Value][15]} {cpu1/cpuRegs[4][Value][16]} {cpu1/cpuRegs[4][Value][17]} {cpu1/cpuRegs[4][Value][18]} {cpu1/cpuRegs[4][Value][19]} {cpu1/cpuRegs[4][Value][20]} {cpu1/cpuRegs[4][Value][21]} {cpu1/cpuRegs[4][Value][22]} {cpu1/cpuRegs[4][Value][23]} {cpu1/cpuRegs[4][Value][24]} {cpu1/cpuRegs[4][Value][25]} {cpu1/cpuRegs[4][Value][26]} {cpu1/cpuRegs[4][Value][27]} {cpu1/cpuRegs[4][Value][28]} {cpu1/cpuRegs[4][Value][29]} {cpu1/cpuRegs[4][Value][30]} {cpu1/cpuRegs[4][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe35]
set_property port_width 5 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list {cpu1/cpuRegs[11][OpCode][0]} {cpu1/cpuRegs[11][OpCode][1]} {cpu1/cpuRegs[11][OpCode][2]} {cpu1/cpuRegs[11][OpCode][3]} {cpu1/cpuRegs[11][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe36]
set_property port_width 32 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list {cpu1/cpuRegs[5][Value][0]} {cpu1/cpuRegs[5][Value][1]} {cpu1/cpuRegs[5][Value][2]} {cpu1/cpuRegs[5][Value][3]} {cpu1/cpuRegs[5][Value][4]} {cpu1/cpuRegs[5][Value][5]} {cpu1/cpuRegs[5][Value][6]} {cpu1/cpuRegs[5][Value][7]} {cpu1/cpuRegs[5][Value][8]} {cpu1/cpuRegs[5][Value][9]} {cpu1/cpuRegs[5][Value][10]} {cpu1/cpuRegs[5][Value][11]} {cpu1/cpuRegs[5][Value][12]} {cpu1/cpuRegs[5][Value][13]} {cpu1/cpuRegs[5][Value][14]} {cpu1/cpuRegs[5][Value][15]} {cpu1/cpuRegs[5][Value][16]} {cpu1/cpuRegs[5][Value][17]} {cpu1/cpuRegs[5][Value][18]} {cpu1/cpuRegs[5][Value][19]} {cpu1/cpuRegs[5][Value][20]} {cpu1/cpuRegs[5][Value][21]} {cpu1/cpuRegs[5][Value][22]} {cpu1/cpuRegs[5][Value][23]} {cpu1/cpuRegs[5][Value][24]} {cpu1/cpuRegs[5][Value][25]} {cpu1/cpuRegs[5][Value][26]} {cpu1/cpuRegs[5][Value][27]} {cpu1/cpuRegs[5][Value][28]} {cpu1/cpuRegs[5][Value][29]} {cpu1/cpuRegs[5][Value][30]} {cpu1/cpuRegs[5][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe37]
set_property port_width 32 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list {cpu1/cpuRegs[6][Value][0]} {cpu1/cpuRegs[6][Value][1]} {cpu1/cpuRegs[6][Value][2]} {cpu1/cpuRegs[6][Value][3]} {cpu1/cpuRegs[6][Value][4]} {cpu1/cpuRegs[6][Value][5]} {cpu1/cpuRegs[6][Value][6]} {cpu1/cpuRegs[6][Value][7]} {cpu1/cpuRegs[6][Value][8]} {cpu1/cpuRegs[6][Value][9]} {cpu1/cpuRegs[6][Value][10]} {cpu1/cpuRegs[6][Value][11]} {cpu1/cpuRegs[6][Value][12]} {cpu1/cpuRegs[6][Value][13]} {cpu1/cpuRegs[6][Value][14]} {cpu1/cpuRegs[6][Value][15]} {cpu1/cpuRegs[6][Value][16]} {cpu1/cpuRegs[6][Value][17]} {cpu1/cpuRegs[6][Value][18]} {cpu1/cpuRegs[6][Value][19]} {cpu1/cpuRegs[6][Value][20]} {cpu1/cpuRegs[6][Value][21]} {cpu1/cpuRegs[6][Value][22]} {cpu1/cpuRegs[6][Value][23]} {cpu1/cpuRegs[6][Value][24]} {cpu1/cpuRegs[6][Value][25]} {cpu1/cpuRegs[6][Value][26]} {cpu1/cpuRegs[6][Value][27]} {cpu1/cpuRegs[6][Value][28]} {cpu1/cpuRegs[6][Value][29]} {cpu1/cpuRegs[6][Value][30]} {cpu1/cpuRegs[6][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe38]
set_property port_width 32 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list {cpu1/cpuRegs[7][Countdown][0]} {cpu1/cpuRegs[7][Countdown][1]} {cpu1/cpuRegs[7][Countdown][2]} {cpu1/cpuRegs[7][Countdown][3]} {cpu1/cpuRegs[7][Countdown][4]} {cpu1/cpuRegs[7][Countdown][5]} {cpu1/cpuRegs[7][Countdown][6]} {cpu1/cpuRegs[7][Countdown][7]} {cpu1/cpuRegs[7][Countdown][8]} {cpu1/cpuRegs[7][Countdown][9]} {cpu1/cpuRegs[7][Countdown][10]} {cpu1/cpuRegs[7][Countdown][11]} {cpu1/cpuRegs[7][Countdown][12]} {cpu1/cpuRegs[7][Countdown][13]} {cpu1/cpuRegs[7][Countdown][14]} {cpu1/cpuRegs[7][Countdown][15]} {cpu1/cpuRegs[7][Countdown][16]} {cpu1/cpuRegs[7][Countdown][17]} {cpu1/cpuRegs[7][Countdown][18]} {cpu1/cpuRegs[7][Countdown][19]} {cpu1/cpuRegs[7][Countdown][20]} {cpu1/cpuRegs[7][Countdown][21]} {cpu1/cpuRegs[7][Countdown][22]} {cpu1/cpuRegs[7][Countdown][23]} {cpu1/cpuRegs[7][Countdown][24]} {cpu1/cpuRegs[7][Countdown][25]} {cpu1/cpuRegs[7][Countdown][26]} {cpu1/cpuRegs[7][Countdown][27]} {cpu1/cpuRegs[7][Countdown][28]} {cpu1/cpuRegs[7][Countdown][29]} {cpu1/cpuRegs[7][Countdown][30]} {cpu1/cpuRegs[7][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe39]
set_property port_width 5 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list {cpu1/cpuRegs[7][OpCode][0]} {cpu1/cpuRegs[7][OpCode][1]} {cpu1/cpuRegs[7][OpCode][2]} {cpu1/cpuRegs[7][OpCode][3]} {cpu1/cpuRegs[7][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe40]
set_property port_width 5 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list {cpu1/cpuRegs[4][OpCode][0]} {cpu1/cpuRegs[4][OpCode][1]} {cpu1/cpuRegs[4][OpCode][2]} {cpu1/cpuRegs[4][OpCode][3]} {cpu1/cpuRegs[4][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe41]
set_property port_width 32 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list {cpu1/cpuRegs[12][Countdown][0]} {cpu1/cpuRegs[12][Countdown][1]} {cpu1/cpuRegs[12][Countdown][2]} {cpu1/cpuRegs[12][Countdown][3]} {cpu1/cpuRegs[12][Countdown][4]} {cpu1/cpuRegs[12][Countdown][5]} {cpu1/cpuRegs[12][Countdown][6]} {cpu1/cpuRegs[12][Countdown][7]} {cpu1/cpuRegs[12][Countdown][8]} {cpu1/cpuRegs[12][Countdown][9]} {cpu1/cpuRegs[12][Countdown][10]} {cpu1/cpuRegs[12][Countdown][11]} {cpu1/cpuRegs[12][Countdown][12]} {cpu1/cpuRegs[12][Countdown][13]} {cpu1/cpuRegs[12][Countdown][14]} {cpu1/cpuRegs[12][Countdown][15]} {cpu1/cpuRegs[12][Countdown][16]} {cpu1/cpuRegs[12][Countdown][17]} {cpu1/cpuRegs[12][Countdown][18]} {cpu1/cpuRegs[12][Countdown][19]} {cpu1/cpuRegs[12][Countdown][20]} {cpu1/cpuRegs[12][Countdown][21]} {cpu1/cpuRegs[12][Countdown][22]} {cpu1/cpuRegs[12][Countdown][23]} {cpu1/cpuRegs[12][Countdown][24]} {cpu1/cpuRegs[12][Countdown][25]} {cpu1/cpuRegs[12][Countdown][26]} {cpu1/cpuRegs[12][Countdown][27]} {cpu1/cpuRegs[12][Countdown][28]} {cpu1/cpuRegs[12][Countdown][29]} {cpu1/cpuRegs[12][Countdown][30]} {cpu1/cpuRegs[12][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe42]
set_property port_width 32 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list {cpu1/cpuRegs[6][Countdown][0]} {cpu1/cpuRegs[6][Countdown][1]} {cpu1/cpuRegs[6][Countdown][2]} {cpu1/cpuRegs[6][Countdown][3]} {cpu1/cpuRegs[6][Countdown][4]} {cpu1/cpuRegs[6][Countdown][5]} {cpu1/cpuRegs[6][Countdown][6]} {cpu1/cpuRegs[6][Countdown][7]} {cpu1/cpuRegs[6][Countdown][8]} {cpu1/cpuRegs[6][Countdown][9]} {cpu1/cpuRegs[6][Countdown][10]} {cpu1/cpuRegs[6][Countdown][11]} {cpu1/cpuRegs[6][Countdown][12]} {cpu1/cpuRegs[6][Countdown][13]} {cpu1/cpuRegs[6][Countdown][14]} {cpu1/cpuRegs[6][Countdown][15]} {cpu1/cpuRegs[6][Countdown][16]} {cpu1/cpuRegs[6][Countdown][17]} {cpu1/cpuRegs[6][Countdown][18]} {cpu1/cpuRegs[6][Countdown][19]} {cpu1/cpuRegs[6][Countdown][20]} {cpu1/cpuRegs[6][Countdown][21]} {cpu1/cpuRegs[6][Countdown][22]} {cpu1/cpuRegs[6][Countdown][23]} {cpu1/cpuRegs[6][Countdown][24]} {cpu1/cpuRegs[6][Countdown][25]} {cpu1/cpuRegs[6][Countdown][26]} {cpu1/cpuRegs[6][Countdown][27]} {cpu1/cpuRegs[6][Countdown][28]} {cpu1/cpuRegs[6][Countdown][29]} {cpu1/cpuRegs[6][Countdown][30]} {cpu1/cpuRegs[6][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe43]
set_property port_width 32 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list {cpu1/cpuRegs[1][Value][0]} {cpu1/cpuRegs[1][Value][1]} {cpu1/cpuRegs[1][Value][2]} {cpu1/cpuRegs[1][Value][3]} {cpu1/cpuRegs[1][Value][4]} {cpu1/cpuRegs[1][Value][5]} {cpu1/cpuRegs[1][Value][6]} {cpu1/cpuRegs[1][Value][7]} {cpu1/cpuRegs[1][Value][8]} {cpu1/cpuRegs[1][Value][9]} {cpu1/cpuRegs[1][Value][10]} {cpu1/cpuRegs[1][Value][11]} {cpu1/cpuRegs[1][Value][12]} {cpu1/cpuRegs[1][Value][13]} {cpu1/cpuRegs[1][Value][14]} {cpu1/cpuRegs[1][Value][15]} {cpu1/cpuRegs[1][Value][16]} {cpu1/cpuRegs[1][Value][17]} {cpu1/cpuRegs[1][Value][18]} {cpu1/cpuRegs[1][Value][19]} {cpu1/cpuRegs[1][Value][20]} {cpu1/cpuRegs[1][Value][21]} {cpu1/cpuRegs[1][Value][22]} {cpu1/cpuRegs[1][Value][23]} {cpu1/cpuRegs[1][Value][24]} {cpu1/cpuRegs[1][Value][25]} {cpu1/cpuRegs[1][Value][26]} {cpu1/cpuRegs[1][Value][27]} {cpu1/cpuRegs[1][Value][28]} {cpu1/cpuRegs[1][Value][29]} {cpu1/cpuRegs[1][Value][30]} {cpu1/cpuRegs[1][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe44]
set_property port_width 32 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list {cpu1/cpuRegs[7][Value][0]} {cpu1/cpuRegs[7][Value][1]} {cpu1/cpuRegs[7][Value][2]} {cpu1/cpuRegs[7][Value][3]} {cpu1/cpuRegs[7][Value][4]} {cpu1/cpuRegs[7][Value][5]} {cpu1/cpuRegs[7][Value][6]} {cpu1/cpuRegs[7][Value][7]} {cpu1/cpuRegs[7][Value][8]} {cpu1/cpuRegs[7][Value][9]} {cpu1/cpuRegs[7][Value][10]} {cpu1/cpuRegs[7][Value][11]} {cpu1/cpuRegs[7][Value][12]} {cpu1/cpuRegs[7][Value][13]} {cpu1/cpuRegs[7][Value][14]} {cpu1/cpuRegs[7][Value][15]} {cpu1/cpuRegs[7][Value][16]} {cpu1/cpuRegs[7][Value][17]} {cpu1/cpuRegs[7][Value][18]} {cpu1/cpuRegs[7][Value][19]} {cpu1/cpuRegs[7][Value][20]} {cpu1/cpuRegs[7][Value][21]} {cpu1/cpuRegs[7][Value][22]} {cpu1/cpuRegs[7][Value][23]} {cpu1/cpuRegs[7][Value][24]} {cpu1/cpuRegs[7][Value][25]} {cpu1/cpuRegs[7][Value][26]} {cpu1/cpuRegs[7][Value][27]} {cpu1/cpuRegs[7][Value][28]} {cpu1/cpuRegs[7][Value][29]} {cpu1/cpuRegs[7][Value][30]} {cpu1/cpuRegs[7][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe45]
set_property port_width 32 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list {cpu1/cpuRegs[8][Countdown][0]} {cpu1/cpuRegs[8][Countdown][1]} {cpu1/cpuRegs[8][Countdown][2]} {cpu1/cpuRegs[8][Countdown][3]} {cpu1/cpuRegs[8][Countdown][4]} {cpu1/cpuRegs[8][Countdown][5]} {cpu1/cpuRegs[8][Countdown][6]} {cpu1/cpuRegs[8][Countdown][7]} {cpu1/cpuRegs[8][Countdown][8]} {cpu1/cpuRegs[8][Countdown][9]} {cpu1/cpuRegs[8][Countdown][10]} {cpu1/cpuRegs[8][Countdown][11]} {cpu1/cpuRegs[8][Countdown][12]} {cpu1/cpuRegs[8][Countdown][13]} {cpu1/cpuRegs[8][Countdown][14]} {cpu1/cpuRegs[8][Countdown][15]} {cpu1/cpuRegs[8][Countdown][16]} {cpu1/cpuRegs[8][Countdown][17]} {cpu1/cpuRegs[8][Countdown][18]} {cpu1/cpuRegs[8][Countdown][19]} {cpu1/cpuRegs[8][Countdown][20]} {cpu1/cpuRegs[8][Countdown][21]} {cpu1/cpuRegs[8][Countdown][22]} {cpu1/cpuRegs[8][Countdown][23]} {cpu1/cpuRegs[8][Countdown][24]} {cpu1/cpuRegs[8][Countdown][25]} {cpu1/cpuRegs[8][Countdown][26]} {cpu1/cpuRegs[8][Countdown][27]} {cpu1/cpuRegs[8][Countdown][28]} {cpu1/cpuRegs[8][Countdown][29]} {cpu1/cpuRegs[8][Countdown][30]} {cpu1/cpuRegs[8][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe46]
set_property port_width 5 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list {cpu1/cpuRegs[5][OpCode][0]} {cpu1/cpuRegs[5][OpCode][1]} {cpu1/cpuRegs[5][OpCode][2]} {cpu1/cpuRegs[5][OpCode][3]} {cpu1/cpuRegs[5][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe47]
set_property port_width 32 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list {cpu1/cpuRegs[9][Countdown][0]} {cpu1/cpuRegs[9][Countdown][1]} {cpu1/cpuRegs[9][Countdown][2]} {cpu1/cpuRegs[9][Countdown][3]} {cpu1/cpuRegs[9][Countdown][4]} {cpu1/cpuRegs[9][Countdown][5]} {cpu1/cpuRegs[9][Countdown][6]} {cpu1/cpuRegs[9][Countdown][7]} {cpu1/cpuRegs[9][Countdown][8]} {cpu1/cpuRegs[9][Countdown][9]} {cpu1/cpuRegs[9][Countdown][10]} {cpu1/cpuRegs[9][Countdown][11]} {cpu1/cpuRegs[9][Countdown][12]} {cpu1/cpuRegs[9][Countdown][13]} {cpu1/cpuRegs[9][Countdown][14]} {cpu1/cpuRegs[9][Countdown][15]} {cpu1/cpuRegs[9][Countdown][16]} {cpu1/cpuRegs[9][Countdown][17]} {cpu1/cpuRegs[9][Countdown][18]} {cpu1/cpuRegs[9][Countdown][19]} {cpu1/cpuRegs[9][Countdown][20]} {cpu1/cpuRegs[9][Countdown][21]} {cpu1/cpuRegs[9][Countdown][22]} {cpu1/cpuRegs[9][Countdown][23]} {cpu1/cpuRegs[9][Countdown][24]} {cpu1/cpuRegs[9][Countdown][25]} {cpu1/cpuRegs[9][Countdown][26]} {cpu1/cpuRegs[9][Countdown][27]} {cpu1/cpuRegs[9][Countdown][28]} {cpu1/cpuRegs[9][Countdown][29]} {cpu1/cpuRegs[9][Countdown][30]} {cpu1/cpuRegs[9][Countdown][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe48]
set_property port_width 32 [get_debug_ports u_ila_0/probe48]
connect_debug_port u_ila_0/probe48 [get_nets [list {cpu1/cpuRegs[9][Value][0]} {cpu1/cpuRegs[9][Value][1]} {cpu1/cpuRegs[9][Value][2]} {cpu1/cpuRegs[9][Value][3]} {cpu1/cpuRegs[9][Value][4]} {cpu1/cpuRegs[9][Value][5]} {cpu1/cpuRegs[9][Value][6]} {cpu1/cpuRegs[9][Value][7]} {cpu1/cpuRegs[9][Value][8]} {cpu1/cpuRegs[9][Value][9]} {cpu1/cpuRegs[9][Value][10]} {cpu1/cpuRegs[9][Value][11]} {cpu1/cpuRegs[9][Value][12]} {cpu1/cpuRegs[9][Value][13]} {cpu1/cpuRegs[9][Value][14]} {cpu1/cpuRegs[9][Value][15]} {cpu1/cpuRegs[9][Value][16]} {cpu1/cpuRegs[9][Value][17]} {cpu1/cpuRegs[9][Value][18]} {cpu1/cpuRegs[9][Value][19]} {cpu1/cpuRegs[9][Value][20]} {cpu1/cpuRegs[9][Value][21]} {cpu1/cpuRegs[9][Value][22]} {cpu1/cpuRegs[9][Value][23]} {cpu1/cpuRegs[9][Value][24]} {cpu1/cpuRegs[9][Value][25]} {cpu1/cpuRegs[9][Value][26]} {cpu1/cpuRegs[9][Value][27]} {cpu1/cpuRegs[9][Value][28]} {cpu1/cpuRegs[9][Value][29]} {cpu1/cpuRegs[9][Value][30]} {cpu1/cpuRegs[9][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe49]
set_property port_width 4 [get_debug_ports u_ila_0/probe49]
connect_debug_port u_ila_0/probe49 [get_nets [list {cpu1/fsm_inst_cycle_p[0]} {cpu1/fsm_inst_cycle_p[1]} {cpu1/fsm_inst_cycle_p[2]} {cpu1/fsm_inst_cycle_p[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe50]
set_property port_width 5 [get_debug_ports u_ila_0/probe50]
connect_debug_port u_ila_0/probe50 [get_nets [list {cpu1/cpuRegs[9][OpCode][0]} {cpu1/cpuRegs[9][OpCode][1]} {cpu1/cpuRegs[9][OpCode][2]} {cpu1/cpuRegs[9][OpCode][3]} {cpu1/cpuRegs[9][OpCode][4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe51]
set_property port_width 3 [get_debug_ports u_ila_0/probe51]
connect_debug_port u_ila_0/probe51 [get_nets [list {interrupt[0]} {interrupt[3]} {interrupt[12]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets SYS_CLK_IBUF_BUFG]
