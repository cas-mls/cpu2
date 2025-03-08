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
set_property port_width 7 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {debugger/WB_TGA[0]} {debugger/WB_TGA[1]} {debugger/WB_TGA[2]} {debugger/WB_TGA[3]} {debugger/WB_TGA[4]} {debugger/WB_TGA[5]} {debugger/WB_TGA[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {debugger/WB_DIN[0]} {debugger/WB_DIN[1]} {debugger/WB_DIN[2]} {debugger/WB_DIN[3]} {debugger/WB_DIN[4]} {debugger/WB_DIN[5]} {debugger/WB_DIN[6]} {debugger/WB_DIN[7]} {debugger/WB_DIN[8]} {debugger/WB_DIN[9]} {debugger/WB_DIN[10]} {debugger/WB_DIN[11]} {debugger/WB_DIN[12]} {debugger/WB_DIN[13]} {debugger/WB_DIN[14]} {debugger/WB_DIN[15]} {debugger/WB_DIN[16]} {debugger/WB_DIN[17]} {debugger/WB_DIN[18]} {debugger/WB_DIN[19]} {debugger/WB_DIN[20]} {debugger/WB_DIN[21]} {debugger/WB_DIN[22]} {debugger/WB_DIN[23]} {debugger/WB_DIN[24]} {debugger/WB_DIN[25]} {debugger/WB_DIN[26]} {debugger/WB_DIN[27]} {debugger/WB_DIN[28]} {debugger/WB_DIN[29]} {debugger/WB_DIN[30]} {debugger/WB_DIN[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {debugger/WB_ADDR[0]} {debugger/WB_ADDR[1]} {debugger/WB_ADDR[2]} {debugger/WB_ADDR[3]} {debugger/WB_ADDR[4]} {debugger/WB_ADDR[5]} {debugger/WB_ADDR[6]} {debugger/WB_ADDR[7]} {debugger/WB_ADDR[8]} {debugger/WB_ADDR[9]} {debugger/WB_ADDR[10]} {debugger/WB_ADDR[11]} {debugger/WB_ADDR[12]} {debugger/WB_ADDR[13]} {debugger/WB_ADDR[14]} {debugger/WB_ADDR[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {debugger/WB_DOUT[0]} {debugger/WB_DOUT[1]} {debugger/WB_DOUT[2]} {debugger/WB_DOUT[3]} {debugger/WB_DOUT[4]} {debugger/WB_DOUT[5]} {debugger/WB_DOUT[6]} {debugger/WB_DOUT[7]} {debugger/WB_DOUT[8]} {debugger/WB_DOUT[9]} {debugger/WB_DOUT[10]} {debugger/WB_DOUT[11]} {debugger/WB_DOUT[12]} {debugger/WB_DOUT[13]} {debugger/WB_DOUT[14]} {debugger/WB_DOUT[15]} {debugger/WB_DOUT[16]} {debugger/WB_DOUT[17]} {debugger/WB_DOUT[18]} {debugger/WB_DOUT[19]} {debugger/WB_DOUT[20]} {debugger/WB_DOUT[21]} {debugger/WB_DOUT[22]} {debugger/WB_DOUT[23]} {debugger/WB_DOUT[24]} {debugger/WB_DOUT[25]} {debugger/WB_DOUT[26]} {debugger/WB_DOUT[27]} {debugger/WB_DOUT[28]} {debugger/WB_DOUT[29]} {debugger/WB_DOUT[30]} {debugger/WB_DOUT[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 12 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {MEM_ADDRA[0]} {MEM_ADDRA[1]} {MEM_ADDRA[2]} {MEM_ADDRA[3]} {MEM_ADDRA[4]} {MEM_ADDRA[5]} {MEM_ADDRA[6]} {MEM_ADDRA[7]} {MEM_ADDRA[8]} {MEM_ADDRA[9]} {MEM_ADDRA[10]} {MEM_ADDRA[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {MEM_DOUTB[0]} {MEM_DOUTB[1]} {MEM_DOUTB[2]} {MEM_DOUTB[3]} {MEM_DOUTB[4]} {MEM_DOUTB[5]} {MEM_DOUTB[6]} {MEM_DOUTB[7]} {MEM_DOUTB[8]} {MEM_DOUTB[9]} {MEM_DOUTB[10]} {MEM_DOUTB[11]} {MEM_DOUTB[12]} {MEM_DOUTB[13]} {MEM_DOUTB[14]} {MEM_DOUTB[15]} {MEM_DOUTB[16]} {MEM_DOUTB[17]} {MEM_DOUTB[18]} {MEM_DOUTB[19]} {MEM_DOUTB[20]} {MEM_DOUTB[21]} {MEM_DOUTB[22]} {MEM_DOUTB[23]} {MEM_DOUTB[24]} {MEM_DOUTB[25]} {MEM_DOUTB[26]} {MEM_DOUTB[27]} {MEM_DOUTB[28]} {MEM_DOUTB[29]} {MEM_DOUTB[30]} {MEM_DOUTB[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 12 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {MEM_ADDRB[0]} {MEM_ADDRB[1]} {MEM_ADDRB[2]} {MEM_ADDRB[3]} {MEM_ADDRB[4]} {MEM_ADDRB[5]} {MEM_ADDRB[6]} {MEM_ADDRB[7]} {MEM_ADDRB[8]} {MEM_ADDRB[9]} {MEM_ADDRB[10]} {MEM_ADDRB[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {MEM_DOUTA[0]} {MEM_DOUTA[1]} {MEM_DOUTA[2]} {MEM_DOUTA[3]} {MEM_DOUTA[4]} {MEM_DOUTA[5]} {MEM_DOUTA[6]} {MEM_DOUTA[7]} {MEM_DOUTA[8]} {MEM_DOUTA[9]} {MEM_DOUTA[10]} {MEM_DOUTA[11]} {MEM_DOUTA[12]} {MEM_DOUTA[13]} {MEM_DOUTA[14]} {MEM_DOUTA[15]} {MEM_DOUTA[16]} {MEM_DOUTA[17]} {MEM_DOUTA[18]} {MEM_DOUTA[19]} {MEM_DOUTA[20]} {MEM_DOUTA[21]} {MEM_DOUTA[22]} {MEM_DOUTA[23]} {MEM_DOUTA[24]} {MEM_DOUTA[25]} {MEM_DOUTA[26]} {MEM_DOUTA[27]} {MEM_DOUTA[28]} {MEM_DOUTA[29]} {MEM_DOUTA[30]} {MEM_DOUTA[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {cpu1/Interrupt_enty/p_0_in[0]} {cpu1/Interrupt_enty/p_0_in[1]} {cpu1/Interrupt_enty/p_0_in[2]} {cpu1/Interrupt_enty/p_0_in[3]} {cpu1/Interrupt_enty/p_0_in[4]} {cpu1/Interrupt_enty/p_0_in[5]} {cpu1/Interrupt_enty/p_0_in[6]} {cpu1/Interrupt_enty/p_0_in[7]} {cpu1/Interrupt_enty/p_0_in[8]} {cpu1/Interrupt_enty/p_0_in[9]} {cpu1/Interrupt_enty/p_0_in[10]} {cpu1/Interrupt_enty/p_0_in[11]} {cpu1/Interrupt_enty/p_0_in[12]} {cpu1/Interrupt_enty/p_0_in[13]} {cpu1/Interrupt_enty/p_0_in[14]} {cpu1/Interrupt_enty/p_0_in[15]} {cpu1/Interrupt_enty/p_0_in[16]} {cpu1/Interrupt_enty/p_0_in[17]} {cpu1/Interrupt_enty/p_0_in[18]} {cpu1/Interrupt_enty/p_0_in[19]} {cpu1/Interrupt_enty/p_0_in[20]} {cpu1/Interrupt_enty/p_0_in[21]} {cpu1/Interrupt_enty/p_0_in[22]} {cpu1/Interrupt_enty/p_0_in[23]} {cpu1/Interrupt_enty/p_0_in[24]} {cpu1/Interrupt_enty/p_0_in[25]} {cpu1/Interrupt_enty/p_0_in[26]} {cpu1/Interrupt_enty/p_0_in[27]} {cpu1/Interrupt_enty/p_0_in[28]} {cpu1/Interrupt_enty/p_0_in[29]} {cpu1/Interrupt_enty/p_0_in[30]} {cpu1/Interrupt_enty/p_0_in[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 4 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {cpu1/Interrupt_enty/fsm_interrupt_cycle_p[0]} {cpu1/Interrupt_enty/fsm_interrupt_cycle_p[1]} {cpu1/Interrupt_enty/fsm_interrupt_cycle_p[2]} {cpu1/Interrupt_enty/fsm_interrupt_cycle_p[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 5 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {cpu1/Interrupt_enty/interruptNum[0]} {cpu1/Interrupt_enty/interruptNum[1]} {cpu1/Interrupt_enty/interruptNum[2]} {cpu1/Interrupt_enty/interruptNum[3]} {cpu1/Interrupt_enty/interruptNum[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 12 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {cpu1/ProgramCounter[0]} {cpu1/ProgramCounter[1]} {cpu1/ProgramCounter[2]} {cpu1/ProgramCounter[3]} {cpu1/ProgramCounter[4]} {cpu1/ProgramCounter[5]} {cpu1/ProgramCounter[6]} {cpu1/ProgramCounter[7]} {cpu1/ProgramCounter[8]} {cpu1/ProgramCounter[9]} {cpu1/ProgramCounter[10]} {cpu1/ProgramCounter[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 4 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {cpu1/fsm_inst_cycle_p[0]} {cpu1/fsm_inst_cycle_p[1]} {cpu1/fsm_inst_cycle_p[2]} {cpu1/fsm_inst_cycle_p[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 12 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {debugger/DebugIn[BreakPoints][0][0]} {debugger/DebugIn[BreakPoints][0][1]} {debugger/DebugIn[BreakPoints][0][2]} {debugger/DebugIn[BreakPoints][0][3]} {debugger/DebugIn[BreakPoints][0][4]} {debugger/DebugIn[BreakPoints][0][5]} {debugger/DebugIn[BreakPoints][0][6]} {debugger/DebugIn[BreakPoints][0][7]} {debugger/DebugIn[BreakPoints][0][8]} {debugger/DebugIn[BreakPoints][0][9]} {debugger/DebugIn[BreakPoints][0][10]} {debugger/DebugIn[BreakPoints][0][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 12 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {debugger/DebugIn[BreakPoints][2][0]} {debugger/DebugIn[BreakPoints][2][1]} {debugger/DebugIn[BreakPoints][2][2]} {debugger/DebugIn[BreakPoints][2][3]} {debugger/DebugIn[BreakPoints][2][4]} {debugger/DebugIn[BreakPoints][2][5]} {debugger/DebugIn[BreakPoints][2][6]} {debugger/DebugIn[BreakPoints][2][7]} {debugger/DebugIn[BreakPoints][2][8]} {debugger/DebugIn[BreakPoints][2][9]} {debugger/DebugIn[BreakPoints][2][10]} {debugger/DebugIn[BreakPoints][2][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 4 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {debugger/DebugIn[UpdateValue][Number][0]} {debugger/DebugIn[UpdateValue][Number][1]} {debugger/DebugIn[UpdateValue][Number][2]} {debugger/DebugIn[UpdateValue][Number][3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 12 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {debugger/DebugIn[BreakPoints][3][0]} {debugger/DebugIn[BreakPoints][3][1]} {debugger/DebugIn[BreakPoints][3][2]} {debugger/DebugIn[BreakPoints][3][3]} {debugger/DebugIn[BreakPoints][3][4]} {debugger/DebugIn[BreakPoints][3][5]} {debugger/DebugIn[BreakPoints][3][6]} {debugger/DebugIn[BreakPoints][3][7]} {debugger/DebugIn[BreakPoints][3][8]} {debugger/DebugIn[BreakPoints][3][9]} {debugger/DebugIn[BreakPoints][3][10]} {debugger/DebugIn[BreakPoints][3][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 32 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {debugger/DebugIn[UpdateValue][Value][0]} {debugger/DebugIn[UpdateValue][Value][1]} {debugger/DebugIn[UpdateValue][Value][2]} {debugger/DebugIn[UpdateValue][Value][3]} {debugger/DebugIn[UpdateValue][Value][4]} {debugger/DebugIn[UpdateValue][Value][5]} {debugger/DebugIn[UpdateValue][Value][6]} {debugger/DebugIn[UpdateValue][Value][7]} {debugger/DebugIn[UpdateValue][Value][8]} {debugger/DebugIn[UpdateValue][Value][9]} {debugger/DebugIn[UpdateValue][Value][10]} {debugger/DebugIn[UpdateValue][Value][11]} {debugger/DebugIn[UpdateValue][Value][12]} {debugger/DebugIn[UpdateValue][Value][13]} {debugger/DebugIn[UpdateValue][Value][14]} {debugger/DebugIn[UpdateValue][Value][15]} {debugger/DebugIn[UpdateValue][Value][16]} {debugger/DebugIn[UpdateValue][Value][17]} {debugger/DebugIn[UpdateValue][Value][18]} {debugger/DebugIn[UpdateValue][Value][19]} {debugger/DebugIn[UpdateValue][Value][20]} {debugger/DebugIn[UpdateValue][Value][21]} {debugger/DebugIn[UpdateValue][Value][22]} {debugger/DebugIn[UpdateValue][Value][23]} {debugger/DebugIn[UpdateValue][Value][24]} {debugger/DebugIn[UpdateValue][Value][25]} {debugger/DebugIn[UpdateValue][Value][26]} {debugger/DebugIn[UpdateValue][Value][27]} {debugger/DebugIn[UpdateValue][Value][28]} {debugger/DebugIn[UpdateValue][Value][29]} {debugger/DebugIn[UpdateValue][Value][30]} {debugger/DebugIn[UpdateValue][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 4 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {debugger/DebugIn[UpdateReg][Number][0]} {debugger/DebugIn[UpdateReg][Number][1]} {debugger/DebugIn[UpdateReg][Number][2]} {debugger/DebugIn[UpdateReg][Number][3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 3 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {debugger/DebugIn[BWhenOp][0]} {debugger/DebugIn[BWhenOp][1]} {debugger/DebugIn[BWhenOp][2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 32 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {debugger/DebugIn[BWhenReg][0]} {debugger/DebugIn[BWhenReg][1]} {debugger/DebugIn[BWhenReg][2]} {debugger/DebugIn[BWhenReg][3]} {debugger/DebugIn[BWhenReg][4]} {debugger/DebugIn[BWhenReg][5]} {debugger/DebugIn[BWhenReg][6]} {debugger/DebugIn[BWhenReg][7]} {debugger/DebugIn[BWhenReg][8]} {debugger/DebugIn[BWhenReg][9]} {debugger/DebugIn[BWhenReg][10]} {debugger/DebugIn[BWhenReg][11]} {debugger/DebugIn[BWhenReg][12]} {debugger/DebugIn[BWhenReg][13]} {debugger/DebugIn[BWhenReg][14]} {debugger/DebugIn[BWhenReg][15]} {debugger/DebugIn[BWhenReg][16]} {debugger/DebugIn[BWhenReg][17]} {debugger/DebugIn[BWhenReg][18]} {debugger/DebugIn[BWhenReg][19]} {debugger/DebugIn[BWhenReg][20]} {debugger/DebugIn[BWhenReg][21]} {debugger/DebugIn[BWhenReg][22]} {debugger/DebugIn[BWhenReg][23]} {debugger/DebugIn[BWhenReg][24]} {debugger/DebugIn[BWhenReg][25]} {debugger/DebugIn[BWhenReg][26]} {debugger/DebugIn[BWhenReg][27]} {debugger/DebugIn[BWhenReg][28]} {debugger/DebugIn[BWhenReg][29]} {debugger/DebugIn[BWhenReg][30]} {debugger/DebugIn[BWhenReg][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 12 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {debugger/DebugIn[BreakPoints][1][0]} {debugger/DebugIn[BreakPoints][1][1]} {debugger/DebugIn[BreakPoints][1][2]} {debugger/DebugIn[BreakPoints][1][3]} {debugger/DebugIn[BreakPoints][1][4]} {debugger/DebugIn[BreakPoints][1][5]} {debugger/DebugIn[BreakPoints][1][6]} {debugger/DebugIn[BreakPoints][1][7]} {debugger/DebugIn[BreakPoints][1][8]} {debugger/DebugIn[BreakPoints][1][9]} {debugger/DebugIn[BreakPoints][1][10]} {debugger/DebugIn[BreakPoints][1][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 32 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {debugger/DebugIn[BWhenValue][0]} {debugger/DebugIn[BWhenValue][1]} {debugger/DebugIn[BWhenValue][2]} {debugger/DebugIn[BWhenValue][3]} {debugger/DebugIn[BWhenValue][4]} {debugger/DebugIn[BWhenValue][5]} {debugger/DebugIn[BWhenValue][6]} {debugger/DebugIn[BWhenValue][7]} {debugger/DebugIn[BWhenValue][8]} {debugger/DebugIn[BWhenValue][9]} {debugger/DebugIn[BWhenValue][10]} {debugger/DebugIn[BWhenValue][11]} {debugger/DebugIn[BWhenValue][12]} {debugger/DebugIn[BWhenValue][13]} {debugger/DebugIn[BWhenValue][14]} {debugger/DebugIn[BWhenValue][15]} {debugger/DebugIn[BWhenValue][16]} {debugger/DebugIn[BWhenValue][17]} {debugger/DebugIn[BWhenValue][18]} {debugger/DebugIn[BWhenValue][19]} {debugger/DebugIn[BWhenValue][20]} {debugger/DebugIn[BWhenValue][21]} {debugger/DebugIn[BWhenValue][22]} {debugger/DebugIn[BWhenValue][23]} {debugger/DebugIn[BWhenValue][24]} {debugger/DebugIn[BWhenValue][25]} {debugger/DebugIn[BWhenValue][26]} {debugger/DebugIn[BWhenValue][27]} {debugger/DebugIn[BWhenValue][28]} {debugger/DebugIn[BWhenValue][29]} {debugger/DebugIn[BWhenValue][30]} {debugger/DebugIn[BWhenValue][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 32 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {debugger/DebugIn[UpdateReg][Value][0]} {debugger/DebugIn[UpdateReg][Value][1]} {debugger/DebugIn[UpdateReg][Value][2]} {debugger/DebugIn[UpdateReg][Value][3]} {debugger/DebugIn[UpdateReg][Value][4]} {debugger/DebugIn[UpdateReg][Value][5]} {debugger/DebugIn[UpdateReg][Value][6]} {debugger/DebugIn[UpdateReg][Value][7]} {debugger/DebugIn[UpdateReg][Value][8]} {debugger/DebugIn[UpdateReg][Value][9]} {debugger/DebugIn[UpdateReg][Value][10]} {debugger/DebugIn[UpdateReg][Value][11]} {debugger/DebugIn[UpdateReg][Value][12]} {debugger/DebugIn[UpdateReg][Value][13]} {debugger/DebugIn[UpdateReg][Value][14]} {debugger/DebugIn[UpdateReg][Value][15]} {debugger/DebugIn[UpdateReg][Value][16]} {debugger/DebugIn[UpdateReg][Value][17]} {debugger/DebugIn[UpdateReg][Value][18]} {debugger/DebugIn[UpdateReg][Value][19]} {debugger/DebugIn[UpdateReg][Value][20]} {debugger/DebugIn[UpdateReg][Value][21]} {debugger/DebugIn[UpdateReg][Value][22]} {debugger/DebugIn[UpdateReg][Value][23]} {debugger/DebugIn[UpdateReg][Value][24]} {debugger/DebugIn[UpdateReg][Value][25]} {debugger/DebugIn[UpdateReg][Value][26]} {debugger/DebugIn[UpdateReg][Value][27]} {debugger/DebugIn[UpdateReg][Value][28]} {debugger/DebugIn[UpdateReg][Value][29]} {debugger/DebugIn[UpdateReg][Value][30]} {debugger/DebugIn[UpdateReg][Value][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {debugger/DebugIn[Break]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {debugger/DebugIn[Continue]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {debugger/DebugIn[DebugMode]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {debugger/DebugIn[Reset]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {debugger/DebugIn[Step]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {debugger/DebugIn[UpdateReg][Valid]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {debugger/DebugIn[UpdateValue][Valid]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list cpu1/DebugStart]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list MEM_ENA]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list MEM_ENB]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list debugger/WB_ACK]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list debugger/WB_CYC]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list debugger/WB_WE]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets SYS_CLK_IBUF_BUFG]
