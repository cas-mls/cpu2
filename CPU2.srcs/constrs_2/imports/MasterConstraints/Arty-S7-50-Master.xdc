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









connect_debug_port u_ila_0/probe1 [get_nets [list {debugger/DebugOut[Regs][11][Countdown][0]} {debugger/DebugOut[Regs][11][Countdown][1]} {debugger/DebugOut[Regs][11][Countdown][2]} {debugger/DebugOut[Regs][11][Countdown][3]} {debugger/DebugOut[Regs][11][Countdown][4]} {debugger/DebugOut[Regs][11][Countdown][5]} {debugger/DebugOut[Regs][11][Countdown][6]} {debugger/DebugOut[Regs][11][Countdown][7]} {debugger/DebugOut[Regs][11][Countdown][8]} {debugger/DebugOut[Regs][11][Countdown][9]} {debugger/DebugOut[Regs][11][Countdown][10]} {debugger/DebugOut[Regs][11][Countdown][11]} {debugger/DebugOut[Regs][11][Countdown][12]} {debugger/DebugOut[Regs][11][Countdown][13]} {debugger/DebugOut[Regs][11][Countdown][14]} {debugger/DebugOut[Regs][11][Countdown][15]} {debugger/DebugOut[Regs][11][Countdown][16]} {debugger/DebugOut[Regs][11][Countdown][17]} {debugger/DebugOut[Regs][11][Countdown][18]} {debugger/DebugOut[Regs][11][Countdown][19]} {debugger/DebugOut[Regs][11][Countdown][20]} {debugger/DebugOut[Regs][11][Countdown][21]} {debugger/DebugOut[Regs][11][Countdown][22]} {debugger/DebugOut[Regs][11][Countdown][23]} {debugger/DebugOut[Regs][11][Countdown][24]} {debugger/DebugOut[Regs][11][Countdown][25]} {debugger/DebugOut[Regs][11][Countdown][26]} {debugger/DebugOut[Regs][11][Countdown][27]} {debugger/DebugOut[Regs][11][Countdown][28]} {debugger/DebugOut[Regs][11][Countdown][29]} {debugger/DebugOut[Regs][11][Countdown][30]} {debugger/DebugOut[Regs][11][Countdown][31]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {debugger/DebugOut[Regs][11][OpCode][0]} {debugger/DebugOut[Regs][11][OpCode][1]} {debugger/DebugOut[Regs][11][OpCode][2]} {debugger/DebugOut[Regs][11][OpCode][3]} {debugger/DebugOut[Regs][11][OpCode][4]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list {debugger/DebugOut[Regs][12][Countdown][0]} {debugger/DebugOut[Regs][12][Countdown][1]} {debugger/DebugOut[Regs][12][Countdown][2]} {debugger/DebugOut[Regs][12][Countdown][3]} {debugger/DebugOut[Regs][12][Countdown][4]} {debugger/DebugOut[Regs][12][Countdown][5]} {debugger/DebugOut[Regs][12][Countdown][6]} {debugger/DebugOut[Regs][12][Countdown][7]} {debugger/DebugOut[Regs][12][Countdown][8]} {debugger/DebugOut[Regs][12][Countdown][9]} {debugger/DebugOut[Regs][12][Countdown][10]} {debugger/DebugOut[Regs][12][Countdown][11]} {debugger/DebugOut[Regs][12][Countdown][12]} {debugger/DebugOut[Regs][12][Countdown][13]} {debugger/DebugOut[Regs][12][Countdown][14]} {debugger/DebugOut[Regs][12][Countdown][15]} {debugger/DebugOut[Regs][12][Countdown][16]} {debugger/DebugOut[Regs][12][Countdown][17]} {debugger/DebugOut[Regs][12][Countdown][18]} {debugger/DebugOut[Regs][12][Countdown][19]} {debugger/DebugOut[Regs][12][Countdown][20]} {debugger/DebugOut[Regs][12][Countdown][21]} {debugger/DebugOut[Regs][12][Countdown][22]} {debugger/DebugOut[Regs][12][Countdown][23]} {debugger/DebugOut[Regs][12][Countdown][24]} {debugger/DebugOut[Regs][12][Countdown][25]} {debugger/DebugOut[Regs][12][Countdown][26]} {debugger/DebugOut[Regs][12][Countdown][27]} {debugger/DebugOut[Regs][12][Countdown][28]} {debugger/DebugOut[Regs][12][Countdown][29]} {debugger/DebugOut[Regs][12][Countdown][30]} {debugger/DebugOut[Regs][12][Countdown][31]}]]
connect_debug_port u_ila_0/probe6 [get_nets [list {debugger/DebugOut[Regs][12][OpCode][0]} {debugger/DebugOut[Regs][12][OpCode][1]} {debugger/DebugOut[Regs][12][OpCode][2]} {debugger/DebugOut[Regs][12][OpCode][3]} {debugger/DebugOut[Regs][12][OpCode][4]}]]
connect_debug_port u_ila_0/probe8 [get_nets [list {debugger/DebugOut[Regs][10][OpCode][0]} {debugger/DebugOut[Regs][10][OpCode][1]} {debugger/DebugOut[Regs][10][OpCode][2]} {debugger/DebugOut[Regs][10][OpCode][3]} {debugger/DebugOut[Regs][10][OpCode][4]}]]
connect_debug_port u_ila_0/probe10 [get_nets [list {debugger/DebugOut[Regs][10][Countdown][0]} {debugger/DebugOut[Regs][10][Countdown][1]} {debugger/DebugOut[Regs][10][Countdown][2]} {debugger/DebugOut[Regs][10][Countdown][3]} {debugger/DebugOut[Regs][10][Countdown][4]} {debugger/DebugOut[Regs][10][Countdown][5]} {debugger/DebugOut[Regs][10][Countdown][6]} {debugger/DebugOut[Regs][10][Countdown][7]} {debugger/DebugOut[Regs][10][Countdown][8]} {debugger/DebugOut[Regs][10][Countdown][9]} {debugger/DebugOut[Regs][10][Countdown][10]} {debugger/DebugOut[Regs][10][Countdown][11]} {debugger/DebugOut[Regs][10][Countdown][12]} {debugger/DebugOut[Regs][10][Countdown][13]} {debugger/DebugOut[Regs][10][Countdown][14]} {debugger/DebugOut[Regs][10][Countdown][15]} {debugger/DebugOut[Regs][10][Countdown][16]} {debugger/DebugOut[Regs][10][Countdown][17]} {debugger/DebugOut[Regs][10][Countdown][18]} {debugger/DebugOut[Regs][10][Countdown][19]} {debugger/DebugOut[Regs][10][Countdown][20]} {debugger/DebugOut[Regs][10][Countdown][21]} {debugger/DebugOut[Regs][10][Countdown][22]} {debugger/DebugOut[Regs][10][Countdown][23]} {debugger/DebugOut[Regs][10][Countdown][24]} {debugger/DebugOut[Regs][10][Countdown][25]} {debugger/DebugOut[Regs][10][Countdown][26]} {debugger/DebugOut[Regs][10][Countdown][27]} {debugger/DebugOut[Regs][10][Countdown][28]} {debugger/DebugOut[Regs][10][Countdown][29]} {debugger/DebugOut[Regs][10][Countdown][30]} {debugger/DebugOut[Regs][10][Countdown][31]}]]
connect_debug_port u_ila_0/probe14 [get_nets [list {debugger/DebugOut[Regs][0][Countdown][0]} {debugger/DebugOut[Regs][0][Countdown][1]} {debugger/DebugOut[Regs][0][Countdown][2]} {debugger/DebugOut[Regs][0][Countdown][3]} {debugger/DebugOut[Regs][0][Countdown][4]} {debugger/DebugOut[Regs][0][Countdown][5]} {debugger/DebugOut[Regs][0][Countdown][6]} {debugger/DebugOut[Regs][0][Countdown][7]} {debugger/DebugOut[Regs][0][Countdown][8]} {debugger/DebugOut[Regs][0][Countdown][9]} {debugger/DebugOut[Regs][0][Countdown][10]} {debugger/DebugOut[Regs][0][Countdown][11]} {debugger/DebugOut[Regs][0][Countdown][12]} {debugger/DebugOut[Regs][0][Countdown][13]} {debugger/DebugOut[Regs][0][Countdown][14]} {debugger/DebugOut[Regs][0][Countdown][15]} {debugger/DebugOut[Regs][0][Countdown][16]} {debugger/DebugOut[Regs][0][Countdown][17]} {debugger/DebugOut[Regs][0][Countdown][18]} {debugger/DebugOut[Regs][0][Countdown][19]} {debugger/DebugOut[Regs][0][Countdown][20]} {debugger/DebugOut[Regs][0][Countdown][21]} {debugger/DebugOut[Regs][0][Countdown][22]} {debugger/DebugOut[Regs][0][Countdown][23]} {debugger/DebugOut[Regs][0][Countdown][24]} {debugger/DebugOut[Regs][0][Countdown][25]} {debugger/DebugOut[Regs][0][Countdown][26]} {debugger/DebugOut[Regs][0][Countdown][27]} {debugger/DebugOut[Regs][0][Countdown][28]} {debugger/DebugOut[Regs][0][Countdown][29]} {debugger/DebugOut[Regs][0][Countdown][30]} {debugger/DebugOut[Regs][0][Countdown][31]}]]
connect_debug_port u_ila_0/probe15 [get_nets [list {debugger/DebugOut[Regs][0][OpCode][0]} {debugger/DebugOut[Regs][0][OpCode][1]} {debugger/DebugOut[Regs][0][OpCode][2]} {debugger/DebugOut[Regs][0][OpCode][3]} {debugger/DebugOut[Regs][0][OpCode][4]}]]
connect_debug_port u_ila_0/probe16 [get_nets [list {debugger/DebugOut[Regs][15][Countdown][0]} {debugger/DebugOut[Regs][15][Countdown][1]} {debugger/DebugOut[Regs][15][Countdown][2]} {debugger/DebugOut[Regs][15][Countdown][3]} {debugger/DebugOut[Regs][15][Countdown][4]} {debugger/DebugOut[Regs][15][Countdown][5]} {debugger/DebugOut[Regs][15][Countdown][6]} {debugger/DebugOut[Regs][15][Countdown][7]} {debugger/DebugOut[Regs][15][Countdown][8]} {debugger/DebugOut[Regs][15][Countdown][9]} {debugger/DebugOut[Regs][15][Countdown][10]} {debugger/DebugOut[Regs][15][Countdown][11]} {debugger/DebugOut[Regs][15][Countdown][12]} {debugger/DebugOut[Regs][15][Countdown][13]} {debugger/DebugOut[Regs][15][Countdown][14]} {debugger/DebugOut[Regs][15][Countdown][15]} {debugger/DebugOut[Regs][15][Countdown][16]} {debugger/DebugOut[Regs][15][Countdown][17]} {debugger/DebugOut[Regs][15][Countdown][18]} {debugger/DebugOut[Regs][15][Countdown][19]} {debugger/DebugOut[Regs][15][Countdown][20]} {debugger/DebugOut[Regs][15][Countdown][21]} {debugger/DebugOut[Regs][15][Countdown][22]} {debugger/DebugOut[Regs][15][Countdown][23]} {debugger/DebugOut[Regs][15][Countdown][24]} {debugger/DebugOut[Regs][15][Countdown][25]} {debugger/DebugOut[Regs][15][Countdown][26]} {debugger/DebugOut[Regs][15][Countdown][27]} {debugger/DebugOut[Regs][15][Countdown][28]} {debugger/DebugOut[Regs][15][Countdown][29]} {debugger/DebugOut[Regs][15][Countdown][30]} {debugger/DebugOut[Regs][15][Countdown][31]}]]
connect_debug_port u_ila_0/probe17 [get_nets [list {debugger/DebugOut[Regs][1][OpCode][0]} {debugger/DebugOut[Regs][1][OpCode][1]} {debugger/DebugOut[Regs][1][OpCode][2]} {debugger/DebugOut[Regs][1][OpCode][3]} {debugger/DebugOut[Regs][1][OpCode][4]}]]
connect_debug_port u_ila_0/probe19 [get_nets [list {debugger/DebugOut[Regs][15][OpCode][0]} {debugger/DebugOut[Regs][15][OpCode][1]} {debugger/DebugOut[Regs][15][OpCode][2]} {debugger/DebugOut[Regs][15][OpCode][3]} {debugger/DebugOut[Regs][15][OpCode][4]}]]
connect_debug_port u_ila_0/probe21 [get_nets [list {debugger/DebugOut[Regs][14][Countdown][0]} {debugger/DebugOut[Regs][14][Countdown][1]} {debugger/DebugOut[Regs][14][Countdown][2]} {debugger/DebugOut[Regs][14][Countdown][3]} {debugger/DebugOut[Regs][14][Countdown][4]} {debugger/DebugOut[Regs][14][Countdown][5]} {debugger/DebugOut[Regs][14][Countdown][6]} {debugger/DebugOut[Regs][14][Countdown][7]} {debugger/DebugOut[Regs][14][Countdown][8]} {debugger/DebugOut[Regs][14][Countdown][9]} {debugger/DebugOut[Regs][14][Countdown][10]} {debugger/DebugOut[Regs][14][Countdown][11]} {debugger/DebugOut[Regs][14][Countdown][12]} {debugger/DebugOut[Regs][14][Countdown][13]} {debugger/DebugOut[Regs][14][Countdown][14]} {debugger/DebugOut[Regs][14][Countdown][15]} {debugger/DebugOut[Regs][14][Countdown][16]} {debugger/DebugOut[Regs][14][Countdown][17]} {debugger/DebugOut[Regs][14][Countdown][18]} {debugger/DebugOut[Regs][14][Countdown][19]} {debugger/DebugOut[Regs][14][Countdown][20]} {debugger/DebugOut[Regs][14][Countdown][21]} {debugger/DebugOut[Regs][14][Countdown][22]} {debugger/DebugOut[Regs][14][Countdown][23]} {debugger/DebugOut[Regs][14][Countdown][24]} {debugger/DebugOut[Regs][14][Countdown][25]} {debugger/DebugOut[Regs][14][Countdown][26]} {debugger/DebugOut[Regs][14][Countdown][27]} {debugger/DebugOut[Regs][14][Countdown][28]} {debugger/DebugOut[Regs][14][Countdown][29]} {debugger/DebugOut[Regs][14][Countdown][30]} {debugger/DebugOut[Regs][14][Countdown][31]}]]
connect_debug_port u_ila_0/probe23 [get_nets [list {debugger/DebugOut[Regs][3][Countdown][0]} {debugger/DebugOut[Regs][3][Countdown][1]} {debugger/DebugOut[Regs][3][Countdown][2]} {debugger/DebugOut[Regs][3][Countdown][3]} {debugger/DebugOut[Regs][3][Countdown][4]} {debugger/DebugOut[Regs][3][Countdown][5]} {debugger/DebugOut[Regs][3][Countdown][6]} {debugger/DebugOut[Regs][3][Countdown][7]} {debugger/DebugOut[Regs][3][Countdown][8]} {debugger/DebugOut[Regs][3][Countdown][9]} {debugger/DebugOut[Regs][3][Countdown][10]} {debugger/DebugOut[Regs][3][Countdown][11]} {debugger/DebugOut[Regs][3][Countdown][12]} {debugger/DebugOut[Regs][3][Countdown][13]} {debugger/DebugOut[Regs][3][Countdown][14]} {debugger/DebugOut[Regs][3][Countdown][15]} {debugger/DebugOut[Regs][3][Countdown][16]} {debugger/DebugOut[Regs][3][Countdown][17]} {debugger/DebugOut[Regs][3][Countdown][18]} {debugger/DebugOut[Regs][3][Countdown][19]} {debugger/DebugOut[Regs][3][Countdown][20]} {debugger/DebugOut[Regs][3][Countdown][21]} {debugger/DebugOut[Regs][3][Countdown][22]} {debugger/DebugOut[Regs][3][Countdown][23]} {debugger/DebugOut[Regs][3][Countdown][24]} {debugger/DebugOut[Regs][3][Countdown][25]} {debugger/DebugOut[Regs][3][Countdown][26]} {debugger/DebugOut[Regs][3][Countdown][27]} {debugger/DebugOut[Regs][3][Countdown][28]} {debugger/DebugOut[Regs][3][Countdown][29]} {debugger/DebugOut[Regs][3][Countdown][30]} {debugger/DebugOut[Regs][3][Countdown][31]}]]
connect_debug_port u_ila_0/probe24 [get_nets [list {debugger/DebugOut[Regs][3][OpCode][0]} {debugger/DebugOut[Regs][3][OpCode][1]} {debugger/DebugOut[Regs][3][OpCode][2]} {debugger/DebugOut[Regs][3][OpCode][3]} {debugger/DebugOut[Regs][3][OpCode][4]}]]
connect_debug_port u_ila_0/probe25 [get_nets [list {debugger/DebugOut[Regs][14][OpCode][0]} {debugger/DebugOut[Regs][14][OpCode][1]} {debugger/DebugOut[Regs][14][OpCode][2]} {debugger/DebugOut[Regs][14][OpCode][3]} {debugger/DebugOut[Regs][14][OpCode][4]}]]
connect_debug_port u_ila_0/probe26 [get_nets [list {debugger/DebugOut[Regs][5][Countdown][0]} {debugger/DebugOut[Regs][5][Countdown][1]} {debugger/DebugOut[Regs][5][Countdown][2]} {debugger/DebugOut[Regs][5][Countdown][3]} {debugger/DebugOut[Regs][5][Countdown][4]} {debugger/DebugOut[Regs][5][Countdown][5]} {debugger/DebugOut[Regs][5][Countdown][6]} {debugger/DebugOut[Regs][5][Countdown][7]} {debugger/DebugOut[Regs][5][Countdown][8]} {debugger/DebugOut[Regs][5][Countdown][9]} {debugger/DebugOut[Regs][5][Countdown][10]} {debugger/DebugOut[Regs][5][Countdown][11]} {debugger/DebugOut[Regs][5][Countdown][12]} {debugger/DebugOut[Regs][5][Countdown][13]} {debugger/DebugOut[Regs][5][Countdown][14]} {debugger/DebugOut[Regs][5][Countdown][15]} {debugger/DebugOut[Regs][5][Countdown][16]} {debugger/DebugOut[Regs][5][Countdown][17]} {debugger/DebugOut[Regs][5][Countdown][18]} {debugger/DebugOut[Regs][5][Countdown][19]} {debugger/DebugOut[Regs][5][Countdown][20]} {debugger/DebugOut[Regs][5][Countdown][21]} {debugger/DebugOut[Regs][5][Countdown][22]} {debugger/DebugOut[Regs][5][Countdown][23]} {debugger/DebugOut[Regs][5][Countdown][24]} {debugger/DebugOut[Regs][5][Countdown][25]} {debugger/DebugOut[Regs][5][Countdown][26]} {debugger/DebugOut[Regs][5][Countdown][27]} {debugger/DebugOut[Regs][5][Countdown][28]} {debugger/DebugOut[Regs][5][Countdown][29]} {debugger/DebugOut[Regs][5][Countdown][30]} {debugger/DebugOut[Regs][5][Countdown][31]}]]
connect_debug_port u_ila_0/probe27 [get_nets [list {debugger/DebugOut[Regs][2][OpCode][0]} {debugger/DebugOut[Regs][2][OpCode][1]} {debugger/DebugOut[Regs][2][OpCode][2]} {debugger/DebugOut[Regs][2][OpCode][3]} {debugger/DebugOut[Regs][2][OpCode][4]}]]
connect_debug_port u_ila_0/probe30 [get_nets [list {debugger/DebugOut[Regs][4][OpCode][0]} {debugger/DebugOut[Regs][4][OpCode][1]} {debugger/DebugOut[Regs][4][OpCode][2]} {debugger/DebugOut[Regs][4][OpCode][3]} {debugger/DebugOut[Regs][4][OpCode][4]}]]
connect_debug_port u_ila_0/probe31 [get_nets [list {debugger/DebugOut[Regs][5][OpCode][0]} {debugger/DebugOut[Regs][5][OpCode][1]} {debugger/DebugOut[Regs][5][OpCode][2]} {debugger/DebugOut[Regs][5][OpCode][3]} {debugger/DebugOut[Regs][5][OpCode][4]}]]
connect_debug_port u_ila_0/probe32 [get_nets [list {debugger/DebugOut[Regs][6][Countdown][0]} {debugger/DebugOut[Regs][6][Countdown][1]} {debugger/DebugOut[Regs][6][Countdown][2]} {debugger/DebugOut[Regs][6][Countdown][3]} {debugger/DebugOut[Regs][6][Countdown][4]} {debugger/DebugOut[Regs][6][Countdown][5]} {debugger/DebugOut[Regs][6][Countdown][6]} {debugger/DebugOut[Regs][6][Countdown][7]} {debugger/DebugOut[Regs][6][Countdown][8]} {debugger/DebugOut[Regs][6][Countdown][9]} {debugger/DebugOut[Regs][6][Countdown][10]} {debugger/DebugOut[Regs][6][Countdown][11]} {debugger/DebugOut[Regs][6][Countdown][12]} {debugger/DebugOut[Regs][6][Countdown][13]} {debugger/DebugOut[Regs][6][Countdown][14]} {debugger/DebugOut[Regs][6][Countdown][15]} {debugger/DebugOut[Regs][6][Countdown][16]} {debugger/DebugOut[Regs][6][Countdown][17]} {debugger/DebugOut[Regs][6][Countdown][18]} {debugger/DebugOut[Regs][6][Countdown][19]} {debugger/DebugOut[Regs][6][Countdown][20]} {debugger/DebugOut[Regs][6][Countdown][21]} {debugger/DebugOut[Regs][6][Countdown][22]} {debugger/DebugOut[Regs][6][Countdown][23]} {debugger/DebugOut[Regs][6][Countdown][24]} {debugger/DebugOut[Regs][6][Countdown][25]} {debugger/DebugOut[Regs][6][Countdown][26]} {debugger/DebugOut[Regs][6][Countdown][27]} {debugger/DebugOut[Regs][6][Countdown][28]} {debugger/DebugOut[Regs][6][Countdown][29]} {debugger/DebugOut[Regs][6][Countdown][30]} {debugger/DebugOut[Regs][6][Countdown][31]}]]
connect_debug_port u_ila_0/probe33 [get_nets [list {debugger/DebugOut[Regs][6][OpCode][0]} {debugger/DebugOut[Regs][6][OpCode][1]} {debugger/DebugOut[Regs][6][OpCode][2]} {debugger/DebugOut[Regs][6][OpCode][3]} {debugger/DebugOut[Regs][6][OpCode][4]}]]
connect_debug_port u_ila_0/probe34 [get_nets [list {debugger/DebugOut[Regs][13][OpCode][0]} {debugger/DebugOut[Regs][13][OpCode][1]} {debugger/DebugOut[Regs][13][OpCode][2]} {debugger/DebugOut[Regs][13][OpCode][3]} {debugger/DebugOut[Regs][13][OpCode][4]}]]
connect_debug_port u_ila_0/probe36 [get_nets [list {debugger/DebugOut[Regs][1][Countdown][0]} {debugger/DebugOut[Regs][1][Countdown][1]} {debugger/DebugOut[Regs][1][Countdown][2]} {debugger/DebugOut[Regs][1][Countdown][3]} {debugger/DebugOut[Regs][1][Countdown][4]} {debugger/DebugOut[Regs][1][Countdown][5]} {debugger/DebugOut[Regs][1][Countdown][6]} {debugger/DebugOut[Regs][1][Countdown][7]} {debugger/DebugOut[Regs][1][Countdown][8]} {debugger/DebugOut[Regs][1][Countdown][9]} {debugger/DebugOut[Regs][1][Countdown][10]} {debugger/DebugOut[Regs][1][Countdown][11]} {debugger/DebugOut[Regs][1][Countdown][12]} {debugger/DebugOut[Regs][1][Countdown][13]} {debugger/DebugOut[Regs][1][Countdown][14]} {debugger/DebugOut[Regs][1][Countdown][15]} {debugger/DebugOut[Regs][1][Countdown][16]} {debugger/DebugOut[Regs][1][Countdown][17]} {debugger/DebugOut[Regs][1][Countdown][18]} {debugger/DebugOut[Regs][1][Countdown][19]} {debugger/DebugOut[Regs][1][Countdown][20]} {debugger/DebugOut[Regs][1][Countdown][21]} {debugger/DebugOut[Regs][1][Countdown][22]} {debugger/DebugOut[Regs][1][Countdown][23]} {debugger/DebugOut[Regs][1][Countdown][24]} {debugger/DebugOut[Regs][1][Countdown][25]} {debugger/DebugOut[Regs][1][Countdown][26]} {debugger/DebugOut[Regs][1][Countdown][27]} {debugger/DebugOut[Regs][1][Countdown][28]} {debugger/DebugOut[Regs][1][Countdown][29]} {debugger/DebugOut[Regs][1][Countdown][30]} {debugger/DebugOut[Regs][1][Countdown][31]}]]
connect_debug_port u_ila_0/probe38 [get_nets [list {debugger/DebugOut[Regs][4][Countdown][0]} {debugger/DebugOut[Regs][4][Countdown][1]} {debugger/DebugOut[Regs][4][Countdown][2]} {debugger/DebugOut[Regs][4][Countdown][3]} {debugger/DebugOut[Regs][4][Countdown][4]} {debugger/DebugOut[Regs][4][Countdown][5]} {debugger/DebugOut[Regs][4][Countdown][6]} {debugger/DebugOut[Regs][4][Countdown][7]} {debugger/DebugOut[Regs][4][Countdown][8]} {debugger/DebugOut[Regs][4][Countdown][9]} {debugger/DebugOut[Regs][4][Countdown][10]} {debugger/DebugOut[Regs][4][Countdown][11]} {debugger/DebugOut[Regs][4][Countdown][12]} {debugger/DebugOut[Regs][4][Countdown][13]} {debugger/DebugOut[Regs][4][Countdown][14]} {debugger/DebugOut[Regs][4][Countdown][15]} {debugger/DebugOut[Regs][4][Countdown][16]} {debugger/DebugOut[Regs][4][Countdown][17]} {debugger/DebugOut[Regs][4][Countdown][18]} {debugger/DebugOut[Regs][4][Countdown][19]} {debugger/DebugOut[Regs][4][Countdown][20]} {debugger/DebugOut[Regs][4][Countdown][21]} {debugger/DebugOut[Regs][4][Countdown][22]} {debugger/DebugOut[Regs][4][Countdown][23]} {debugger/DebugOut[Regs][4][Countdown][24]} {debugger/DebugOut[Regs][4][Countdown][25]} {debugger/DebugOut[Regs][4][Countdown][26]} {debugger/DebugOut[Regs][4][Countdown][27]} {debugger/DebugOut[Regs][4][Countdown][28]} {debugger/DebugOut[Regs][4][Countdown][29]} {debugger/DebugOut[Regs][4][Countdown][30]} {debugger/DebugOut[Regs][4][Countdown][31]}]]
connect_debug_port u_ila_0/probe42 [get_nets [list {debugger/DebugOut[Regs][2][Countdown][0]} {debugger/DebugOut[Regs][2][Countdown][1]} {debugger/DebugOut[Regs][2][Countdown][2]} {debugger/DebugOut[Regs][2][Countdown][3]} {debugger/DebugOut[Regs][2][Countdown][4]} {debugger/DebugOut[Regs][2][Countdown][5]} {debugger/DebugOut[Regs][2][Countdown][6]} {debugger/DebugOut[Regs][2][Countdown][7]} {debugger/DebugOut[Regs][2][Countdown][8]} {debugger/DebugOut[Regs][2][Countdown][9]} {debugger/DebugOut[Regs][2][Countdown][10]} {debugger/DebugOut[Regs][2][Countdown][11]} {debugger/DebugOut[Regs][2][Countdown][12]} {debugger/DebugOut[Regs][2][Countdown][13]} {debugger/DebugOut[Regs][2][Countdown][14]} {debugger/DebugOut[Regs][2][Countdown][15]} {debugger/DebugOut[Regs][2][Countdown][16]} {debugger/DebugOut[Regs][2][Countdown][17]} {debugger/DebugOut[Regs][2][Countdown][18]} {debugger/DebugOut[Regs][2][Countdown][19]} {debugger/DebugOut[Regs][2][Countdown][20]} {debugger/DebugOut[Regs][2][Countdown][21]} {debugger/DebugOut[Regs][2][Countdown][22]} {debugger/DebugOut[Regs][2][Countdown][23]} {debugger/DebugOut[Regs][2][Countdown][24]} {debugger/DebugOut[Regs][2][Countdown][25]} {debugger/DebugOut[Regs][2][Countdown][26]} {debugger/DebugOut[Regs][2][Countdown][27]} {debugger/DebugOut[Regs][2][Countdown][28]} {debugger/DebugOut[Regs][2][Countdown][29]} {debugger/DebugOut[Regs][2][Countdown][30]} {debugger/DebugOut[Regs][2][Countdown][31]}]]
connect_debug_port u_ila_0/probe43 [get_nets [list {debugger/DebugOut[Regs][7][Countdown][0]} {debugger/DebugOut[Regs][7][Countdown][1]} {debugger/DebugOut[Regs][7][Countdown][2]} {debugger/DebugOut[Regs][7][Countdown][3]} {debugger/DebugOut[Regs][7][Countdown][4]} {debugger/DebugOut[Regs][7][Countdown][5]} {debugger/DebugOut[Regs][7][Countdown][6]} {debugger/DebugOut[Regs][7][Countdown][7]} {debugger/DebugOut[Regs][7][Countdown][8]} {debugger/DebugOut[Regs][7][Countdown][9]} {debugger/DebugOut[Regs][7][Countdown][10]} {debugger/DebugOut[Regs][7][Countdown][11]} {debugger/DebugOut[Regs][7][Countdown][12]} {debugger/DebugOut[Regs][7][Countdown][13]} {debugger/DebugOut[Regs][7][Countdown][14]} {debugger/DebugOut[Regs][7][Countdown][15]} {debugger/DebugOut[Regs][7][Countdown][16]} {debugger/DebugOut[Regs][7][Countdown][17]} {debugger/DebugOut[Regs][7][Countdown][18]} {debugger/DebugOut[Regs][7][Countdown][19]} {debugger/DebugOut[Regs][7][Countdown][20]} {debugger/DebugOut[Regs][7][Countdown][21]} {debugger/DebugOut[Regs][7][Countdown][22]} {debugger/DebugOut[Regs][7][Countdown][23]} {debugger/DebugOut[Regs][7][Countdown][24]} {debugger/DebugOut[Regs][7][Countdown][25]} {debugger/DebugOut[Regs][7][Countdown][26]} {debugger/DebugOut[Regs][7][Countdown][27]} {debugger/DebugOut[Regs][7][Countdown][28]} {debugger/DebugOut[Regs][7][Countdown][29]} {debugger/DebugOut[Regs][7][Countdown][30]} {debugger/DebugOut[Regs][7][Countdown][31]}]]
connect_debug_port u_ila_0/probe44 [get_nets [list {debugger/DebugOut[Regs][13][Countdown][0]} {debugger/DebugOut[Regs][13][Countdown][1]} {debugger/DebugOut[Regs][13][Countdown][2]} {debugger/DebugOut[Regs][13][Countdown][3]} {debugger/DebugOut[Regs][13][Countdown][4]} {debugger/DebugOut[Regs][13][Countdown][5]} {debugger/DebugOut[Regs][13][Countdown][6]} {debugger/DebugOut[Regs][13][Countdown][7]} {debugger/DebugOut[Regs][13][Countdown][8]} {debugger/DebugOut[Regs][13][Countdown][9]} {debugger/DebugOut[Regs][13][Countdown][10]} {debugger/DebugOut[Regs][13][Countdown][11]} {debugger/DebugOut[Regs][13][Countdown][12]} {debugger/DebugOut[Regs][13][Countdown][13]} {debugger/DebugOut[Regs][13][Countdown][14]} {debugger/DebugOut[Regs][13][Countdown][15]} {debugger/DebugOut[Regs][13][Countdown][16]} {debugger/DebugOut[Regs][13][Countdown][17]} {debugger/DebugOut[Regs][13][Countdown][18]} {debugger/DebugOut[Regs][13][Countdown][19]} {debugger/DebugOut[Regs][13][Countdown][20]} {debugger/DebugOut[Regs][13][Countdown][21]} {debugger/DebugOut[Regs][13][Countdown][22]} {debugger/DebugOut[Regs][13][Countdown][23]} {debugger/DebugOut[Regs][13][Countdown][24]} {debugger/DebugOut[Regs][13][Countdown][25]} {debugger/DebugOut[Regs][13][Countdown][26]} {debugger/DebugOut[Regs][13][Countdown][27]} {debugger/DebugOut[Regs][13][Countdown][28]} {debugger/DebugOut[Regs][13][Countdown][29]} {debugger/DebugOut[Regs][13][Countdown][30]} {debugger/DebugOut[Regs][13][Countdown][31]}]]
connect_debug_port u_ila_0/probe45 [get_nets [list {debugger/DebugOut[Regs][8][OpCode][0]} {debugger/DebugOut[Regs][8][OpCode][1]} {debugger/DebugOut[Regs][8][OpCode][2]} {debugger/DebugOut[Regs][8][OpCode][3]} {debugger/DebugOut[Regs][8][OpCode][4]}]]
connect_debug_port u_ila_0/probe46 [get_nets [list {debugger/DebugOut[Regs][9][Countdown][0]} {debugger/DebugOut[Regs][9][Countdown][1]} {debugger/DebugOut[Regs][9][Countdown][2]} {debugger/DebugOut[Regs][9][Countdown][3]} {debugger/DebugOut[Regs][9][Countdown][4]} {debugger/DebugOut[Regs][9][Countdown][5]} {debugger/DebugOut[Regs][9][Countdown][6]} {debugger/DebugOut[Regs][9][Countdown][7]} {debugger/DebugOut[Regs][9][Countdown][8]} {debugger/DebugOut[Regs][9][Countdown][9]} {debugger/DebugOut[Regs][9][Countdown][10]} {debugger/DebugOut[Regs][9][Countdown][11]} {debugger/DebugOut[Regs][9][Countdown][12]} {debugger/DebugOut[Regs][9][Countdown][13]} {debugger/DebugOut[Regs][9][Countdown][14]} {debugger/DebugOut[Regs][9][Countdown][15]} {debugger/DebugOut[Regs][9][Countdown][16]} {debugger/DebugOut[Regs][9][Countdown][17]} {debugger/DebugOut[Regs][9][Countdown][18]} {debugger/DebugOut[Regs][9][Countdown][19]} {debugger/DebugOut[Regs][9][Countdown][20]} {debugger/DebugOut[Regs][9][Countdown][21]} {debugger/DebugOut[Regs][9][Countdown][22]} {debugger/DebugOut[Regs][9][Countdown][23]} {debugger/DebugOut[Regs][9][Countdown][24]} {debugger/DebugOut[Regs][9][Countdown][25]} {debugger/DebugOut[Regs][9][Countdown][26]} {debugger/DebugOut[Regs][9][Countdown][27]} {debugger/DebugOut[Regs][9][Countdown][28]} {debugger/DebugOut[Regs][9][Countdown][29]} {debugger/DebugOut[Regs][9][Countdown][30]} {debugger/DebugOut[Regs][9][Countdown][31]}]]
connect_debug_port u_ila_0/probe50 [get_nets [list {debugger/DebugOut[Regs][8][Countdown][0]} {debugger/DebugOut[Regs][8][Countdown][1]} {debugger/DebugOut[Regs][8][Countdown][2]} {debugger/DebugOut[Regs][8][Countdown][3]} {debugger/DebugOut[Regs][8][Countdown][4]} {debugger/DebugOut[Regs][8][Countdown][5]} {debugger/DebugOut[Regs][8][Countdown][6]} {debugger/DebugOut[Regs][8][Countdown][7]} {debugger/DebugOut[Regs][8][Countdown][8]} {debugger/DebugOut[Regs][8][Countdown][9]} {debugger/DebugOut[Regs][8][Countdown][10]} {debugger/DebugOut[Regs][8][Countdown][11]} {debugger/DebugOut[Regs][8][Countdown][12]} {debugger/DebugOut[Regs][8][Countdown][13]} {debugger/DebugOut[Regs][8][Countdown][14]} {debugger/DebugOut[Regs][8][Countdown][15]} {debugger/DebugOut[Regs][8][Countdown][16]} {debugger/DebugOut[Regs][8][Countdown][17]} {debugger/DebugOut[Regs][8][Countdown][18]} {debugger/DebugOut[Regs][8][Countdown][19]} {debugger/DebugOut[Regs][8][Countdown][20]} {debugger/DebugOut[Regs][8][Countdown][21]} {debugger/DebugOut[Regs][8][Countdown][22]} {debugger/DebugOut[Regs][8][Countdown][23]} {debugger/DebugOut[Regs][8][Countdown][24]} {debugger/DebugOut[Regs][8][Countdown][25]} {debugger/DebugOut[Regs][8][Countdown][26]} {debugger/DebugOut[Regs][8][Countdown][27]} {debugger/DebugOut[Regs][8][Countdown][28]} {debugger/DebugOut[Regs][8][Countdown][29]} {debugger/DebugOut[Regs][8][Countdown][30]} {debugger/DebugOut[Regs][8][Countdown][31]}]]
connect_debug_port u_ila_0/probe58 [get_nets [list {debugger/DebugOut[Regs][7][OpCode][0]} {debugger/DebugOut[Regs][7][OpCode][1]} {debugger/DebugOut[Regs][7][OpCode][2]} {debugger/DebugOut[Regs][7][OpCode][3]} {debugger/DebugOut[Regs][7][OpCode][4]}]]
connect_debug_port u_ila_0/probe64 [get_nets [list {debugger/DebugOut[Regs][9][OpCode][0]} {debugger/DebugOut[Regs][9][OpCode][1]} {debugger/DebugOut[Regs][9][OpCode][2]} {debugger/DebugOut[Regs][9][OpCode][3]} {debugger/DebugOut[Regs][9][OpCode][4]}]]
connect_debug_port u_ila_0/probe67 [get_nets [list {debugger/DebugOut[Regs][0][Flag]}]]
connect_debug_port u_ila_0/probe68 [get_nets [list {debugger/DebugOut[Regs][1][Flag]}]]
connect_debug_port u_ila_0/probe69 [get_nets [list {debugger/DebugOut[Regs][2][Flag]}]]
connect_debug_port u_ila_0/probe70 [get_nets [list {debugger/DebugOut[Regs][3][Flag]}]]
connect_debug_port u_ila_0/probe71 [get_nets [list {debugger/DebugOut[Regs][4][Flag]}]]
connect_debug_port u_ila_0/probe72 [get_nets [list {debugger/DebugOut[Regs][5][Flag]}]]
connect_debug_port u_ila_0/probe73 [get_nets [list {debugger/DebugOut[Regs][6][Flag]}]]
connect_debug_port u_ila_0/probe74 [get_nets [list {debugger/DebugOut[Regs][7][Flag]}]]
connect_debug_port u_ila_0/probe75 [get_nets [list {debugger/DebugOut[Regs][8][Flag]}]]
connect_debug_port u_ila_0/probe76 [get_nets [list {debugger/DebugOut[Regs][9][Flag]}]]
connect_debug_port u_ila_0/probe77 [get_nets [list {debugger/DebugOut[Regs][10][Flag]}]]
connect_debug_port u_ila_0/probe78 [get_nets [list {debugger/DebugOut[Regs][11][Flag]}]]
connect_debug_port u_ila_0/probe79 [get_nets [list {debugger/DebugOut[Regs][12][Flag]}]]
connect_debug_port u_ila_0/probe80 [get_nets [list {debugger/DebugOut[Regs][13][Flag]}]]
connect_debug_port u_ila_0/probe81 [get_nets [list {debugger/DebugOut[Regs][14][Flag]}]]
connect_debug_port u_ila_0/probe82 [get_nets [list {debugger/DebugOut[Regs][15][Flag]}]]
connect_debug_port u_ila_0/probe86 [get_nets [list debugger/n_0_0]]
connect_debug_port u_ila_0/probe87 [get_nets [list debugger/n_0_1]]
connect_debug_port u_ila_0/probe88 [get_nets [list debugger/n_0_2]]
connect_debug_port u_ila_0/probe89 [get_nets [list debugger/n_0_3]]
connect_debug_port u_ila_0/probe90 [get_nets [list debugger/n_0_4]]
connect_debug_port u_ila_0/probe91 [get_nets [list debugger/n_0_5]]
connect_debug_port u_ila_0/probe92 [get_nets [list debugger/n_0_6]]
connect_debug_port u_ila_0/probe93 [get_nets [list debugger/n_0_7]]
connect_debug_port u_ila_0/probe94 [get_nets [list debugger/n_0_8]]
connect_debug_port u_ila_0/probe95 [get_nets [list debugger/n_0_9]]
connect_debug_port u_ila_0/probe96 [get_nets [list debugger/n_0_10]]
connect_debug_port u_ila_0/probe97 [get_nets [list debugger/n_0_11]]
connect_debug_port u_ila_0/probe98 [get_nets [list debugger/n_0_12]]
connect_debug_port u_ila_0/probe99 [get_nets [list debugger/n_0_13]]
connect_debug_port u_ila_0/probe100 [get_nets [list debugger/n_0_14]]
connect_debug_port u_ila_0/probe101 [get_nets [list debugger/n_0_15]]
connect_debug_port u_ila_0/probe102 [get_nets [list debugger/n_0_16]]
connect_debug_port u_ila_0/probe103 [get_nets [list debugger/n_0_17]]
connect_debug_port u_ila_0/probe104 [get_nets [list debugger/n_0_18]]
connect_debug_port u_ila_0/probe105 [get_nets [list debugger/n_0_19]]
connect_debug_port u_ila_0/probe106 [get_nets [list debugger/n_0_20]]
connect_debug_port u_ila_0/probe107 [get_nets [list debugger/n_0_21]]
connect_debug_port u_ila_0/probe108 [get_nets [list debugger/n_0_22]]
connect_debug_port u_ila_0/probe109 [get_nets [list debugger/n_0_23]]
connect_debug_port u_ila_0/probe110 [get_nets [list debugger/n_0_24]]
connect_debug_port u_ila_0/probe111 [get_nets [list debugger/n_0_25]]
connect_debug_port u_ila_0/probe112 [get_nets [list debugger/n_0_26]]
connect_debug_port u_ila_0/probe113 [get_nets [list debugger/n_0_27]]
connect_debug_port u_ila_0/probe114 [get_nets [list debugger/n_0_28]]
connect_debug_port u_ila_0/probe115 [get_nets [list debugger/n_0_29]]
connect_debug_port u_ila_0/probe116 [get_nets [list debugger/n_0_30]]
connect_debug_port u_ila_0/probe117 [get_nets [list debugger/n_0_31]]
connect_debug_port u_ila_0/probe118 [get_nets [list debugger/n_0_32]]
connect_debug_port u_ila_0/probe119 [get_nets [list debugger/n_0_33]]
connect_debug_port u_ila_0/probe120 [get_nets [list debugger/n_0_34]]
connect_debug_port u_ila_0/probe121 [get_nets [list debugger/n_0_35]]
connect_debug_port u_ila_0/probe122 [get_nets [list debugger/n_0_36]]
connect_debug_port u_ila_0/probe123 [get_nets [list debugger/n_0_37]]
connect_debug_port u_ila_0/probe124 [get_nets [list debugger/n_0_38]]
connect_debug_port u_ila_0/probe125 [get_nets [list debugger/n_0_39]]
connect_debug_port u_ila_0/probe126 [get_nets [list debugger/n_0_40]]
connect_debug_port u_ila_0/probe127 [get_nets [list debugger/n_0_41]]
connect_debug_port u_ila_0/probe128 [get_nets [list debugger/n_0_42]]
connect_debug_port u_ila_0/probe129 [get_nets [list debugger/n_0_43]]
connect_debug_port u_ila_0/probe130 [get_nets [list debugger/n_0_44]]
connect_debug_port u_ila_0/probe131 [get_nets [list debugger/n_0_45]]
connect_debug_port u_ila_0/probe132 [get_nets [list debugger/n_0_46]]
connect_debug_port u_ila_0/probe133 [get_nets [list debugger/n_0_47]]
connect_debug_port u_ila_0/probe134 [get_nets [list debugger/n_0_48]]
connect_debug_port u_ila_0/probe135 [get_nets [list debugger/n_0_49]]
connect_debug_port u_ila_0/probe136 [get_nets [list debugger/n_0_50]]
connect_debug_port u_ila_0/probe137 [get_nets [list debugger/n_0_51]]
connect_debug_port u_ila_0/probe138 [get_nets [list debugger/n_0_52]]
connect_debug_port u_ila_0/probe139 [get_nets [list debugger/n_0_53]]
connect_debug_port u_ila_0/probe140 [get_nets [list debugger/n_0_54]]
connect_debug_port u_ila_0/probe141 [get_nets [list debugger/n_0_55]]
connect_debug_port u_ila_0/probe142 [get_nets [list debugger/n_0_56]]
connect_debug_port u_ila_0/probe143 [get_nets [list debugger/n_0_57]]
connect_debug_port u_ila_0/probe144 [get_nets [list debugger/n_0_58]]






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
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {debugger/DebugOut[MEMORY_ARG][0]} {debugger/DebugOut[MEMORY_ARG][1]} {debugger/DebugOut[MEMORY_ARG][2]} {debugger/DebugOut[MEMORY_ARG][3]} {debugger/DebugOut[MEMORY_ARG][4]} {debugger/DebugOut[MEMORY_ARG][5]} {debugger/DebugOut[MEMORY_ARG][6]} {debugger/DebugOut[MEMORY_ARG][7]} {debugger/DebugOut[MEMORY_ARG][8]} {debugger/DebugOut[MEMORY_ARG][9]} {debugger/DebugOut[MEMORY_ARG][10]} {debugger/DebugOut[MEMORY_ARG][11]} {debugger/DebugOut[MEMORY_ARG][12]} {debugger/DebugOut[MEMORY_ARG][13]} {debugger/DebugOut[MEMORY_ARG][14]} {debugger/DebugOut[MEMORY_ARG][15]} {debugger/DebugOut[MEMORY_ARG][16]} {debugger/DebugOut[MEMORY_ARG][17]} {debugger/DebugOut[MEMORY_ARG][18]} {debugger/DebugOut[MEMORY_ARG][19]} {debugger/DebugOut[MEMORY_ARG][20]} {debugger/DebugOut[MEMORY_ARG][21]} {debugger/DebugOut[MEMORY_ARG][22]} {debugger/DebugOut[MEMORY_ARG][23]} {debugger/DebugOut[MEMORY_ARG][24]} {debugger/DebugOut[MEMORY_ARG][25]} {debugger/DebugOut[MEMORY_ARG][26]} {debugger/DebugOut[MEMORY_ARG][27]} {debugger/DebugOut[MEMORY_ARG][28]} {debugger/DebugOut[MEMORY_ARG][29]} {debugger/DebugOut[MEMORY_ARG][30]} {debugger/DebugOut[MEMORY_ARG][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {debugger/WB_DOUT[0]} {debugger/WB_DOUT[1]} {debugger/WB_DOUT[2]} {debugger/WB_DOUT[3]} {debugger/WB_DOUT[4]} {debugger/WB_DOUT[5]} {debugger/WB_DOUT[6]} {debugger/WB_DOUT[7]} {debugger/WB_DOUT[8]} {debugger/WB_DOUT[9]} {debugger/WB_DOUT[10]} {debugger/WB_DOUT[11]} {debugger/WB_DOUT[12]} {debugger/WB_DOUT[13]} {debugger/WB_DOUT[14]} {debugger/WB_DOUT[15]} {debugger/WB_DOUT[16]} {debugger/WB_DOUT[17]} {debugger/WB_DOUT[18]} {debugger/WB_DOUT[19]} {debugger/WB_DOUT[20]} {debugger/WB_DOUT[21]} {debugger/WB_DOUT[22]} {debugger/WB_DOUT[23]} {debugger/WB_DOUT[24]} {debugger/WB_DOUT[25]} {debugger/WB_DOUT[26]} {debugger/WB_DOUT[27]} {debugger/WB_DOUT[28]} {debugger/WB_DOUT[29]} {debugger/WB_DOUT[30]} {debugger/WB_DOUT[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 12 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {MEM_ADDRB[0]} {MEM_ADDRB[1]} {MEM_ADDRB[2]} {MEM_ADDRB[3]} {MEM_ADDRB[4]} {MEM_ADDRB[5]} {MEM_ADDRB[6]} {MEM_ADDRB[7]} {MEM_ADDRB[8]} {MEM_ADDRB[9]} {MEM_ADDRB[10]} {MEM_ADDRB[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 16 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {debugger/WB_ADDR[0]} {debugger/WB_ADDR[1]} {debugger/WB_ADDR[2]} {debugger/WB_ADDR[3]} {debugger/WB_ADDR[4]} {debugger/WB_ADDR[5]} {debugger/WB_ADDR[6]} {debugger/WB_ADDR[7]} {debugger/WB_ADDR[8]} {debugger/WB_ADDR[9]} {debugger/WB_ADDR[10]} {debugger/WB_ADDR[11]} {debugger/WB_ADDR[12]} {debugger/WB_ADDR[13]} {debugger/WB_ADDR[14]} {debugger/WB_ADDR[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {MEM_DOUTB[0]} {MEM_DOUTB[1]} {MEM_DOUTB[2]} {MEM_DOUTB[3]} {MEM_DOUTB[4]} {MEM_DOUTB[5]} {MEM_DOUTB[6]} {MEM_DOUTB[7]} {MEM_DOUTB[8]} {MEM_DOUTB[9]} {MEM_DOUTB[10]} {MEM_DOUTB[11]} {MEM_DOUTB[12]} {MEM_DOUTB[13]} {MEM_DOUTB[14]} {MEM_DOUTB[15]} {MEM_DOUTB[16]} {MEM_DOUTB[17]} {MEM_DOUTB[18]} {MEM_DOUTB[19]} {MEM_DOUTB[20]} {MEM_DOUTB[21]} {MEM_DOUTB[22]} {MEM_DOUTB[23]} {MEM_DOUTB[24]} {MEM_DOUTB[25]} {MEM_DOUTB[26]} {MEM_DOUTB[27]} {MEM_DOUTB[28]} {MEM_DOUTB[29]} {MEM_DOUTB[30]} {MEM_DOUTB[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 7 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {debugger/WB_TGA[0]} {debugger/WB_TGA[1]} {debugger/WB_TGA[2]} {debugger/WB_TGA[3]} {debugger/WB_TGA[4]} {debugger/WB_TGA[5]} {debugger/WB_TGA[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {debugger/WB_DIN[0]} {debugger/WB_DIN[1]} {debugger/WB_DIN[2]} {debugger/WB_DIN[3]} {debugger/WB_DIN[4]} {debugger/WB_DIN[5]} {debugger/WB_DIN[6]} {debugger/WB_DIN[7]} {debugger/WB_DIN[8]} {debugger/WB_DIN[9]} {debugger/WB_DIN[10]} {debugger/WB_DIN[11]} {debugger/WB_DIN[12]} {debugger/WB_DIN[13]} {debugger/WB_DIN[14]} {debugger/WB_DIN[15]} {debugger/WB_DIN[16]} {debugger/WB_DIN[17]} {debugger/WB_DIN[18]} {debugger/WB_DIN[19]} {debugger/WB_DIN[20]} {debugger/WB_DIN[21]} {debugger/WB_DIN[22]} {debugger/WB_DIN[23]} {debugger/WB_DIN[24]} {debugger/WB_DIN[25]} {debugger/WB_DIN[26]} {debugger/WB_DIN[27]} {debugger/WB_DIN[28]} {debugger/WB_DIN[29]} {debugger/WB_DIN[30]} {debugger/WB_DIN[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 3 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {interrupt[0]} {interrupt[3]} {interrupt[12]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list debugger/WB_ACK]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list debugger/WB_CYC]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list debugger/WB_WE]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets SYS_CLK_IBUF_BUFG]
