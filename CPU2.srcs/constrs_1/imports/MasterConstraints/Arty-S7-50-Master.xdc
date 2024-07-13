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
#set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]; #IO_25_14 Sch=uart_rxd_out
#set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]; #IO_L24N_T3_A00_D16_14 Sch=uart_txd_in

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



set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[2]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[0]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[12]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[22]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[4]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[7]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[9]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[16]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[19]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[22]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[28]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[5]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[30]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[12]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[6]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[17]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[20]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[21]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[29]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[7]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[15]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[30]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[6]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[17]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[25]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[26]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[6]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[2]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[3]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[11]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[1]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[19]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[14]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[18]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[21]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[31]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[1]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[22]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[31]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[4]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[10]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[19]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[11]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[0]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[17]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[23]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[12]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[20]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[8]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[9]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[24]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[13]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[14]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[26]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[27]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[31]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[20]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[26]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[14]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[16]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[21]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[0]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[7]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[15]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[24]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[5]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[18]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[13]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[27]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[29]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[4]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[28]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[29]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[1]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[23]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[9]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[10]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[16]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[25]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[28]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[30]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[25]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[8]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[11]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[23]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[27]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[5]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[13]_10[18]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[3]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[8]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[2]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[13]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[14]_6[24]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[3]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[10]}]
set_property MARK_DEBUG true [get_nets {cpu1/regist[15]_2[15]}]
set_property MARK_DEBUG true [get_nets {cpu1/ProgCounter[1]}]
set_property MARK_DEBUG true [get_nets {cpu1/ProgCounter[2]}]
set_property MARK_DEBUG true [get_nets {cpu1/ProgCounter[3]}]
set_property MARK_DEBUG true [get_nets {cpu1/ProgCounter[5]}]
set_property MARK_DEBUG true [get_nets {cpu1/ProgCounter[6]}]
set_property MARK_DEBUG true [get_nets {cpu1/ProgCounter[8]}]
set_property MARK_DEBUG true [get_nets {cpu1/ProgCounter[0]}]
set_property MARK_DEBUG true [get_nets {cpu1/ProgCounter[4]}]
set_property MARK_DEBUG true [get_nets {cpu1/ProgCounter[7]}]
set_property MARK_DEBUG true [get_nets {cpu1/ProgCounter[9]}]
set_property MARK_DEBUG true [get_nets {cpu1/ProgCounter[10]}]
set_property MARK_DEBUG true [get_nets {cpu1/ProgCounter[11]}]
set_property MARK_DEBUG true [get_nets {cpu1/fsm_inst_cycle_p[0]}]
set_property MARK_DEBUG true [get_nets {cpu1/fsm_inst_cycle_p[1]}]
set_property MARK_DEBUG true [get_nets {cpu1/fsm_inst_cycle_p[2]}]
set_property MARK_DEBUG true [get_nets {cpu1/fsm_inst_cycle_p[3]}]
set_property MARK_DEBUG true [get_nets {memory/douta[1]}]
set_property MARK_DEBUG true [get_nets {memory/douta[5]}]
set_property MARK_DEBUG true [get_nets {memory/douta[3]}]
set_property MARK_DEBUG true [get_nets {memory/douta[13]}]
set_property MARK_DEBUG true [get_nets {memory/douta[14]}]
set_property MARK_DEBUG true [get_nets {memory/douta[22]}]
set_property MARK_DEBUG true [get_nets {memory/douta[25]}]
set_property MARK_DEBUG true [get_nets {memory/douta[27]}]
set_property MARK_DEBUG true [get_nets {memory/douta[30]}]
set_property MARK_DEBUG true [get_nets {memory/douta[31]}]
set_property MARK_DEBUG true [get_nets {memory/douta[0]}]
set_property MARK_DEBUG true [get_nets {memory/douta[4]}]
set_property MARK_DEBUG true [get_nets {memory/douta[8]}]
set_property MARK_DEBUG true [get_nets {memory/douta[9]}]
set_property MARK_DEBUG true [get_nets {memory/douta[15]}]
set_property MARK_DEBUG true [get_nets {memory/douta[16]}]
set_property MARK_DEBUG true [get_nets {memory/douta[19]}]
set_property MARK_DEBUG true [get_nets {memory/douta[24]}]
set_property MARK_DEBUG true [get_nets {memory/douta[6]}]
set_property MARK_DEBUG true [get_nets {memory/douta[7]}]
set_property MARK_DEBUG true [get_nets {memory/douta[10]}]
set_property MARK_DEBUG true [get_nets {memory/douta[12]}]
set_property MARK_DEBUG true [get_nets {memory/douta[17]}]
set_property MARK_DEBUG true [get_nets {memory/douta[18]}]
set_property MARK_DEBUG true [get_nets {memory/douta[26]}]
set_property MARK_DEBUG true [get_nets {memory/douta[29]}]
set_property MARK_DEBUG true [get_nets {memory/douta[2]}]
set_property MARK_DEBUG true [get_nets {memory/douta[11]}]
set_property MARK_DEBUG true [get_nets {memory/douta[20]}]
set_property MARK_DEBUG true [get_nets {memory/douta[21]}]
set_property MARK_DEBUG true [get_nets {memory/douta[23]}]
set_property MARK_DEBUG true [get_nets {memory/douta[28]}]
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 1 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list SYS_CLK_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {cpu1/fsm_inst_cycle_p[0]} {cpu1/fsm_inst_cycle_p[1]} {cpu1/fsm_inst_cycle_p[2]} {cpu1/fsm_inst_cycle_p[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 12 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {cpu1/ProgCounter[0]} {cpu1/ProgCounter[1]} {cpu1/ProgCounter[2]} {cpu1/ProgCounter[3]} {cpu1/ProgCounter[4]} {cpu1/ProgCounter[5]} {cpu1/ProgCounter[6]} {cpu1/ProgCounter[7]} {cpu1/ProgCounter[8]} {cpu1/ProgCounter[9]} {cpu1/ProgCounter[10]} {cpu1/ProgCounter[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {cpu1/regist[14]_6[0]} {cpu1/regist[14]_6[1]} {cpu1/regist[14]_6[2]} {cpu1/regist[14]_6[3]} {cpu1/regist[14]_6[4]} {cpu1/regist[14]_6[5]} {cpu1/regist[14]_6[6]} {cpu1/regist[14]_6[7]} {cpu1/regist[14]_6[8]} {cpu1/regist[14]_6[9]} {cpu1/regist[14]_6[10]} {cpu1/regist[14]_6[11]} {cpu1/regist[14]_6[12]} {cpu1/regist[14]_6[13]} {cpu1/regist[14]_6[14]} {cpu1/regist[14]_6[15]} {cpu1/regist[14]_6[16]} {cpu1/regist[14]_6[17]} {cpu1/regist[14]_6[18]} {cpu1/regist[14]_6[19]} {cpu1/regist[14]_6[20]} {cpu1/regist[14]_6[21]} {cpu1/regist[14]_6[22]} {cpu1/regist[14]_6[23]} {cpu1/regist[14]_6[24]} {cpu1/regist[14]_6[25]} {cpu1/regist[14]_6[26]} {cpu1/regist[14]_6[27]} {cpu1/regist[14]_6[28]} {cpu1/regist[14]_6[29]} {cpu1/regist[14]_6[30]} {cpu1/regist[14]_6[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {cpu1/regist[15]_2[0]} {cpu1/regist[15]_2[1]} {cpu1/regist[15]_2[2]} {cpu1/regist[15]_2[3]} {cpu1/regist[15]_2[4]} {cpu1/regist[15]_2[5]} {cpu1/regist[15]_2[6]} {cpu1/regist[15]_2[7]} {cpu1/regist[15]_2[8]} {cpu1/regist[15]_2[9]} {cpu1/regist[15]_2[10]} {cpu1/regist[15]_2[11]} {cpu1/regist[15]_2[12]} {cpu1/regist[15]_2[13]} {cpu1/regist[15]_2[14]} {cpu1/regist[15]_2[15]} {cpu1/regist[15]_2[16]} {cpu1/regist[15]_2[17]} {cpu1/regist[15]_2[18]} {cpu1/regist[15]_2[19]} {cpu1/regist[15]_2[20]} {cpu1/regist[15]_2[21]} {cpu1/regist[15]_2[22]} {cpu1/regist[15]_2[23]} {cpu1/regist[15]_2[24]} {cpu1/regist[15]_2[25]} {cpu1/regist[15]_2[26]} {cpu1/regist[15]_2[27]} {cpu1/regist[15]_2[28]} {cpu1/regist[15]_2[29]} {cpu1/regist[15]_2[30]} {cpu1/regist[15]_2[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {cpu1/regist[13]_10[0]} {cpu1/regist[13]_10[1]} {cpu1/regist[13]_10[2]} {cpu1/regist[13]_10[3]} {cpu1/regist[13]_10[4]} {cpu1/regist[13]_10[5]} {cpu1/regist[13]_10[6]} {cpu1/regist[13]_10[7]} {cpu1/regist[13]_10[8]} {cpu1/regist[13]_10[9]} {cpu1/regist[13]_10[10]} {cpu1/regist[13]_10[11]} {cpu1/regist[13]_10[12]} {cpu1/regist[13]_10[13]} {cpu1/regist[13]_10[14]} {cpu1/regist[13]_10[15]} {cpu1/regist[13]_10[16]} {cpu1/regist[13]_10[17]} {cpu1/regist[13]_10[18]} {cpu1/regist[13]_10[19]} {cpu1/regist[13]_10[20]} {cpu1/regist[13]_10[21]} {cpu1/regist[13]_10[22]} {cpu1/regist[13]_10[23]} {cpu1/regist[13]_10[24]} {cpu1/regist[13]_10[25]} {cpu1/regist[13]_10[26]} {cpu1/regist[13]_10[27]} {cpu1/regist[13]_10[28]} {cpu1/regist[13]_10[29]} {cpu1/regist[13]_10[30]} {cpu1/regist[13]_10[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {memory/douta[0]} {memory/douta[1]} {memory/douta[2]} {memory/douta[3]} {memory/douta[4]} {memory/douta[5]} {memory/douta[6]} {memory/douta[7]} {memory/douta[8]} {memory/douta[9]} {memory/douta[10]} {memory/douta[11]} {memory/douta[12]} {memory/douta[13]} {memory/douta[14]} {memory/douta[15]} {memory/douta[16]} {memory/douta[17]} {memory/douta[18]} {memory/douta[19]} {memory/douta[20]} {memory/douta[21]} {memory/douta[22]} {memory/douta[23]} {memory/douta[24]} {memory/douta[25]} {memory/douta[26]} {memory/douta[27]} {memory/douta[28]} {memory/douta[29]} {memory/douta[30]} {memory/douta[31]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets SYS_CLK_IBUF_BUFG]
