-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
-- Date        : Wed Dec 13 19:06:08 2023
-- Host        : AlienCraig running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file {D:/Users/Craig/Documents/000
--               ArtyS7/CPU2/CPU2.sim/sim_1/synth/func/xsim/SimCPU_func_synth.vhd}
-- Design      : CPU
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7s50csga324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity Registers is
  port (
    regout : out STD_LOGIC_VECTOR ( 3 downto 0 );
    clk_IBUF_BUFG : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \regout_reg[0]_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    ena : in STD_LOGIC;
    we : in STD_LOGIC
  );
end Registers;

architecture STRUCTURE of Registers is
  signal \p_0_in__0\ : STD_LOGIC;
  signal p_0_out : STD_LOGIC;
  signal p_1_out : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute RTL_RAM_BITS : integer;
  attribute RTL_RAM_BITS of regist_reg_0_15_0_0 : label is 512;
  attribute RTL_RAM_NAME : string;
  attribute RTL_RAM_NAME of regist_reg_0_15_0_0 : label is "reg1/regist_reg";
  attribute RTL_RAM_TYPE : string;
  attribute RTL_RAM_TYPE of regist_reg_0_15_0_0 : label is "RAM_SP";
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of regist_reg_0_15_0_0 : label is "RAM16X1S";
  attribute XILINX_TRANSFORM_PINMAP : string;
  attribute XILINX_TRANSFORM_PINMAP of regist_reg_0_15_0_0 : label is "GND:A4";
  attribute ram_addr_begin : integer;
  attribute ram_addr_begin of regist_reg_0_15_0_0 : label is 0;
  attribute ram_addr_end : integer;
  attribute ram_addr_end of regist_reg_0_15_0_0 : label is 15;
  attribute ram_offset : integer;
  attribute ram_offset of regist_reg_0_15_0_0 : label is 0;
  attribute ram_slice_begin : integer;
  attribute ram_slice_begin of regist_reg_0_15_0_0 : label is 0;
  attribute ram_slice_end : integer;
  attribute ram_slice_end of regist_reg_0_15_0_0 : label is 0;
  attribute RTL_RAM_BITS of regist_reg_0_15_1_1 : label is 512;
  attribute RTL_RAM_NAME of regist_reg_0_15_1_1 : label is "reg1/regist_reg";
  attribute RTL_RAM_TYPE of regist_reg_0_15_1_1 : label is "RAM_SP";
  attribute XILINX_LEGACY_PRIM of regist_reg_0_15_1_1 : label is "RAM16X1S";
  attribute XILINX_TRANSFORM_PINMAP of regist_reg_0_15_1_1 : label is "GND:A4";
  attribute ram_addr_begin of regist_reg_0_15_1_1 : label is 0;
  attribute ram_addr_end of regist_reg_0_15_1_1 : label is 15;
  attribute ram_offset of regist_reg_0_15_1_1 : label is 0;
  attribute ram_slice_begin of regist_reg_0_15_1_1 : label is 1;
  attribute ram_slice_end of regist_reg_0_15_1_1 : label is 1;
  attribute RTL_RAM_BITS of regist_reg_0_15_2_2 : label is 512;
  attribute RTL_RAM_NAME of regist_reg_0_15_2_2 : label is "reg1/regist_reg";
  attribute RTL_RAM_TYPE of regist_reg_0_15_2_2 : label is "RAM_SP";
  attribute XILINX_LEGACY_PRIM of regist_reg_0_15_2_2 : label is "RAM16X1S";
  attribute XILINX_TRANSFORM_PINMAP of regist_reg_0_15_2_2 : label is "GND:A4";
  attribute ram_addr_begin of regist_reg_0_15_2_2 : label is 0;
  attribute ram_addr_end of regist_reg_0_15_2_2 : label is 15;
  attribute ram_offset of regist_reg_0_15_2_2 : label is 0;
  attribute ram_slice_begin of regist_reg_0_15_2_2 : label is 2;
  attribute ram_slice_end of regist_reg_0_15_2_2 : label is 2;
  attribute RTL_RAM_BITS of regist_reg_0_15_3_3 : label is 512;
  attribute RTL_RAM_NAME of regist_reg_0_15_3_3 : label is "reg1/regist_reg";
  attribute RTL_RAM_TYPE of regist_reg_0_15_3_3 : label is "RAM_SP";
  attribute XILINX_LEGACY_PRIM of regist_reg_0_15_3_3 : label is "RAM16X1S";
  attribute XILINX_TRANSFORM_PINMAP of regist_reg_0_15_3_3 : label is "GND:A4";
  attribute ram_addr_begin of regist_reg_0_15_3_3 : label is 0;
  attribute ram_addr_end of regist_reg_0_15_3_3 : label is 15;
  attribute ram_offset of regist_reg_0_15_3_3 : label is 0;
  attribute ram_slice_begin of regist_reg_0_15_3_3 : label is 3;
  attribute ram_slice_end of regist_reg_0_15_3_3 : label is 3;
begin
regist_reg_0_15_0_0: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => \regout_reg[0]_0\(0),
      A1 => \regout_reg[0]_0\(1),
      A2 => \regout_reg[0]_0\(2),
      A3 => \regout_reg[0]_0\(3),
      A4 => '0',
      D => Q(0),
      O => p_1_out(0),
      WCLK => clk_IBUF_BUFG,
      WE => \p_0_in__0\
    );
regist_reg_0_15_0_0_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => we,
      I1 => ena,
      O => \p_0_in__0\
    );
regist_reg_0_15_1_1: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => \regout_reg[0]_0\(0),
      A1 => \regout_reg[0]_0\(1),
      A2 => \regout_reg[0]_0\(2),
      A3 => \regout_reg[0]_0\(3),
      A4 => '0',
      D => Q(1),
      O => p_1_out(1),
      WCLK => clk_IBUF_BUFG,
      WE => \p_0_in__0\
    );
regist_reg_0_15_2_2: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => \regout_reg[0]_0\(0),
      A1 => \regout_reg[0]_0\(1),
      A2 => \regout_reg[0]_0\(2),
      A3 => \regout_reg[0]_0\(3),
      A4 => '0',
      D => Q(2),
      O => p_1_out(2),
      WCLK => clk_IBUF_BUFG,
      WE => \p_0_in__0\
    );
regist_reg_0_15_3_3: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => \regout_reg[0]_0\(0),
      A1 => \regout_reg[0]_0\(1),
      A2 => \regout_reg[0]_0\(2),
      A3 => \regout_reg[0]_0\(3),
      A4 => '0',
      D => Q(3),
      O => p_1_out(3),
      WCLK => clk_IBUF_BUFG,
      WE => \p_0_in__0\
    );
\regout[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => ena,
      I1 => we,
      O => p_0_out
    );
\regout_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => p_0_out,
      D => p_1_out(0),
      Q => regout(0),
      R => '0'
    );
\regout_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => p_0_out,
      D => p_1_out(1),
      Q => regout(1),
      R => '0'
    );
\regout_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => p_0_out,
      D => p_1_out(2),
      Q => regout(2),
      R => '0'
    );
\regout_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => p_0_out,
      D => p_1_out(3),
      Q => regout(3),
      R => '0'
    );
end STRUCTURE;
`protect begin_protected
`protect version = 1
`protect encrypt_agent = "XILINX"
`protect encrypt_agent_info = "Xilinx Encryption Tool 2023.2"
`protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`protect key_block
jLV29U0rrfMIZhYJzdoUrPoqB9eHQ5NXmWyCdqnN3Wgm+GU4C3zthrN1m4QGiaj0thPCIynZbX+0
7yjtkv+T5ByJ6NhiofAwWseGLvPXlYu6ERAPvi4SAYpF2VUqQHtPAbPmnPubGdDRgIEpeobF7hsz
rEcpEru1pyiScUriyuo=

`protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
vsoizVrOONWw/DhjRLEYrtRmtji+Ok63CbpSg/l9VnoKAi8tAzqRbQ57atGB2N6IGGbKHkbK2Uzh
EHgWvYZeyt4hE+bpQX91vc9PNxfjQMGzPoFD3jCWk30EmEk+AND39eWx+DhJ8xhFuucoOQ2GwyAk
B+Mjs15naPE7DvlHel8hnD4dfSdYhGKp96oozu8JeBto8aHG6poOuYkxSwaut7NCI+mabCkMxtMp
RrydgmRuTvhRTbJMyx5CxFSZTRDrS5aU1vaRlnMiqKCI7g2KY9pemYaJsFeVodBuo6IyKGynyEhs
wr+VtUhQDtaVhMkwB95WwmMoDk9F2L5Au1I+TQ==

`protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`protect key_block
W081dPMCWhKs5YlQD7n3zvf7+PTcnb8eFWxoVs8+zHLkxDMA1klITbsfztGYvJFce8Yao5XQLLqZ
oUE5Pq2arq+zwICFUcLjdMsmP1WmL82znHOPHm83zNwrxWMloHkySAqzFbgJeHa973uZqj0M8ydc
sYmzCYVlGVjt0QX0xqA=

`protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
Zpc3MmdLWaVOv+S4z2POuoyslYoAbWc+Npxq2UyQRtDwf566IId3uwAetolMAgfLo/G3ezuSOXMn
8NznS37h9XvmVrxA50SAux68P87WgkLtiUYqM3CMBKkxNlZ/TR8WzTuQyFdvzkOE9lp8HC7LXnk5
RDsnOM+su46FW7ysY01COslo9Xc7rhs6WFqx29+Xcqk8+ZMLSzaJfuwZdNmJFS3Q1vhlq3ZeYqMl
wMieB731KsPxjxp7VKNHpTbgFryC2isqc4ohBDOt52M/Bz4B/rIpFeHfZ7X3jWSiKtSuBsDN2NXf
EMjfAT248dlK7NxJ+NBNPhS5sLxTiGyQhta57A==

`protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
rPMYqnkKhJKV1wltOfDrKos9ZbucaoX3WGTuqsdLkGpcKObzslHBwlGrKtWV7bZYmS2SM+QuEMfa
CE+tCUdsSiprp+n5BuSQlJa6BJ8mlqccjoo/JLw2QEmUhyMXQ3TLGomGGoZdeTmMPXhUBAOyLPea
Ddc8mgtTN8Kpy117GOTXDKP+IKJqW01fLrPJpgEhFiJCbyElLgtCRWmI94gX+y4XNVS0Cd1YwNw6
4nHgnEdC7fXARDKcYO3VsWC/pdzPQgursXloNLrVYa6i2xr+8E1V0+nSWwNYQZP7XUIVqXKMU8Ea
bT4acXrRCF/5tJJ5B9JparYI0zxXSbaakn1dIw==

`protect key_keyowner="Xilinx", key_keyname="xilinxt_2022_10", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
mfroTgL8g2pyIXQ/mGO9YHm19cd5mOlJ++qpusOYeVxGmkIhvF4aKx+AyIUz2yGGAeCtOzIasHty
pyqKgZhibSqxcpHgR0m6GOxXXOXJiHaK8NzxUzXeRJovcBI/WjtDhXeb1LRMI1J97jVBtJPJQH0Y
fGOD7jWvkvQwxnrZdyLp6kPWgSIcavHHDbO7iJv4gnyGp6W3/FCDo2RKWNLoW+SNjSdLZ6YRP8a+
ldaGU8TYvJ03KWlmik7repuN6AwxCjg2KeQ+x1sBAEXzROXomuSbvX3ZAo8UiIKAQY1SJumHLG3L
QI/S4Wbl1Hz6LDTsttMwP480gq6+tb6s1E4oWw==

`protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
QJIabgm8dx/gVHbOQFwt8maOKVHFgkpZTPR6dzD8fqoGo9M9oGPTqBqchtPZWgv2UYFF2KEUSlV4
L3SDXBKrLs+NsAVTcICaEMiEi6j82zj/C1LsPkQfS8RLrg0ab8lbDMb5YqJ7lkHs3iM65x2iN1Mf
66cTgCbkAdl3rDpab75btpTQt5ZKiq5CSY3RZfyIW0uWbTGTELm6liuRKM9+K8BQwTU7A+FFFQBA
/9eJwQYzNNA/iwoYJ2WTPd6pBlzXriNLu9M+/2bYicNBSuH1PBR9v2ESrTB6k7EiV1zvBXV9NuG/
sFt4MumWMuSNwP2W38bQATxxW/l0IrmaXGOC/w==

`protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`protect key_block
lhKf/Vgj6pHpme1ji4HVe36BU8pMkam/2I9lFeyOiBnIbzgdEGfLJBcEvkL33A7s0hxa6LFbHnkT
upgMpPjmIghBz3xUQ13vpiY152thFec6qvlcdg1r+GTmnBOSFl6g/OfZ3eFUhfsve6ZjQHpXnKFo
a55hN2+eP1EG9+VxGeM7XkHaeFhEIry52qtnmg072KEFIwRiGs2d/TJ4AqupuIdIiP1kTN9k+oqa
2ta1vdtqPY0dDHqrf+5YSd0CejkhQeCqg/bauLP3755SwdOPRgooG5ANT8hUpTiFMFXtU+GC9NSp
evJtMHUy1NbgMmhFHO+w3URLEdjSaBxZPD7YLdWkF65jY526tJzoek+BzEKoBaGfCaY7O1nHKXm+
89k3rPUy0Xo4/0nHpno+N/Db09heJPbnGsCwN/l+KnR6Lz8kvWziBjZe0ijOkKI+T12y3T1VeOtY
H/aqtNlQt1mhFwrbw6ezaAiDPVbCQXnly6b4tbb8+nFsxWOGIGAfLozB

`protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
PNsQ8uEcQYrl+GaDuBaq1tQ5br5aAdaqHnyrc0NVu/JnQUk53jaiLx8Oz5fNACvWelUUk2/C+P5I
b2rbU1bb/dC6TqC5J1N0yoMYRYw58u4Lrl8Kgqgt9Rlph5Qgzzfxp+oblXF/pO4mRyAXpZhpNkFT
0Ar9BUtPOTOtJ9/g53SRnZ6GjxzfeD+25J4fcXBNo2gCTgUkwiLSsJRwTB/cJmn+dZPwPdIOHEP9
TkfDK+OrbLYO3T+DFBTCMRNH2NB1J9sc5s+nPU8iYnjgPTo6HoGW+LIlCz6yNJMZzJzoeW708utc
0fJXkT7vLDVh7olvy3V9AAY8Do0YR1kiZlhVhQ==

`protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
zAz8RnGHFebkJFAS+gjC+mXHW7m7We+JgSmIz15mS01u/4+9Ng0sJfkeXOClmVPTQ2Mp2Yuv6/6f
ehzUTcANilWsqLM6Q1FToCPNX/NTqodlcHirGM7b5R9yevouNT/aqH12nmbunBQmBHmehNutdCjG
r6Z7kZgeZ2ZE7MMOF0rTy1XHEPkqgMNTRoS8R/pPWPTW4/j+bn3aJj0Q/fTz4Gi3mbSUKWs2fREQ
UKiuolNJkN6DiDvhlVYHUyytXNJG44ikmBXehoQQRLapkYaxnQmMRT1ok9uY6pKoy71CtvJ3Mt2x
EQv1GU2i4qQyAOwa0mkEohWXduicU6tDz3zQwQ==

`protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
TK3eE9V+v1z2P1KjG4GrjhA1n3qDOpNzLGXdtjnjhF0QBFPSuhC+nmNqTPOb3p2a9r5KD0miY3Cd
+KpjH6Ao09E2/LD2Go4aLQh6vP+9BldlSKEwCGfx2NjBQrXWVH21lQR7IRjOvyTOclpd7SgtUJLw
dvebETyLiKr9C6RfnIBeptuCA3iJlXfwkh6I0JfzD5WBizQkotioZmmrXv5105pCXQ4Ta1WThFsA
2ll9dZeSjEDHUxxhfyfjryv9m4VL89ZDU/rGITsdptwB1BC1jLqmPDymY05lyECnjA6NIR5GGfI4
K2y2f4GfikKoN5r9IOvFzw963Wm82ZZPtXOKGg==

`protect data_method = "AES128-CBC"
`protect encoding = (enctype = "BASE64", line_length = 76, bytes = 94928)
`protect data_block
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
e7aUZv7H5w7uK5Z6jQeSOUC53phtfvw=
`protect end_protected
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity cpumemory is
  port (
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 0 to 0 );
    addra : in STD_LOGIC_VECTOR ( 11 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 31 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of cpumemory : entity is "cpumemory,blk_mem_gen_v8_4_7,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of cpumemory : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of cpumemory : entity is "blk_mem_gen_v8_4_7,Vivado 2023.2";
end cpumemory;

architecture STRUCTURE of cpumemory is
  signal NLW_U0_dbiterr_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_rsta_busy_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_rstb_busy_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_arready_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_awready_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_bvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_dbiterr_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_rlast_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_rvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_sbiterr_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_wready_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_sbiterr_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_doutb_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_rdaddrecc_UNCONNECTED : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal NLW_U0_s_axi_bid_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_U0_s_axi_bresp_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_U0_s_axi_rdaddrecc_UNCONNECTED : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal NLW_U0_s_axi_rdata_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_s_axi_rid_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_U0_s_axi_rresp_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute C_ADDRA_WIDTH : integer;
  attribute C_ADDRA_WIDTH of U0 : label is 12;
  attribute C_ADDRB_WIDTH : integer;
  attribute C_ADDRB_WIDTH of U0 : label is 12;
  attribute C_ALGORITHM : integer;
  attribute C_ALGORITHM of U0 : label is 1;
  attribute C_AXI_ID_WIDTH : integer;
  attribute C_AXI_ID_WIDTH of U0 : label is 4;
  attribute C_AXI_SLAVE_TYPE : integer;
  attribute C_AXI_SLAVE_TYPE of U0 : label is 0;
  attribute C_AXI_TYPE : integer;
  attribute C_AXI_TYPE of U0 : label is 1;
  attribute C_BYTE_SIZE : integer;
  attribute C_BYTE_SIZE of U0 : label is 9;
  attribute C_COMMON_CLK : integer;
  attribute C_COMMON_CLK of U0 : label is 0;
  attribute C_COUNT_18K_BRAM : string;
  attribute C_COUNT_18K_BRAM of U0 : label is "0";
  attribute C_COUNT_36K_BRAM : string;
  attribute C_COUNT_36K_BRAM of U0 : label is "4";
  attribute C_CTRL_ECC_ALGO : string;
  attribute C_CTRL_ECC_ALGO of U0 : label is "NONE";
  attribute C_DEFAULT_DATA : string;
  attribute C_DEFAULT_DATA of U0 : label is "5A";
  attribute C_DISABLE_WARN_BHV_COLL : integer;
  attribute C_DISABLE_WARN_BHV_COLL of U0 : label is 0;
  attribute C_DISABLE_WARN_BHV_RANGE : integer;
  attribute C_DISABLE_WARN_BHV_RANGE of U0 : label is 0;
  attribute C_ELABORATION_DIR : string;
  attribute C_ELABORATION_DIR of U0 : label is "./";
  attribute C_ENABLE_32BIT_ADDRESS : integer;
  attribute C_ENABLE_32BIT_ADDRESS of U0 : label is 0;
  attribute C_EN_DEEPSLEEP_PIN : integer;
  attribute C_EN_DEEPSLEEP_PIN of U0 : label is 0;
  attribute C_EN_ECC_PIPE : integer;
  attribute C_EN_ECC_PIPE of U0 : label is 0;
  attribute C_EN_RDADDRA_CHG : integer;
  attribute C_EN_RDADDRA_CHG of U0 : label is 0;
  attribute C_EN_RDADDRB_CHG : integer;
  attribute C_EN_RDADDRB_CHG of U0 : label is 0;
  attribute C_EN_SAFETY_CKT : integer;
  attribute C_EN_SAFETY_CKT of U0 : label is 0;
  attribute C_EN_SHUTDOWN_PIN : integer;
  attribute C_EN_SHUTDOWN_PIN of U0 : label is 0;
  attribute C_EN_SLEEP_PIN : integer;
  attribute C_EN_SLEEP_PIN of U0 : label is 0;
  attribute C_EST_POWER_SUMMARY : string;
  attribute C_EST_POWER_SUMMARY of U0 : label is "Estimated Power for IP     :     10.142799 mW";
  attribute C_FAMILY : string;
  attribute C_FAMILY of U0 : label is "spartan7";
  attribute C_HAS_AXI_ID : integer;
  attribute C_HAS_AXI_ID of U0 : label is 0;
  attribute C_HAS_ENA : integer;
  attribute C_HAS_ENA of U0 : label is 1;
  attribute C_HAS_ENB : integer;
  attribute C_HAS_ENB of U0 : label is 0;
  attribute C_HAS_INJECTERR : integer;
  attribute C_HAS_INJECTERR of U0 : label is 0;
  attribute C_HAS_MEM_OUTPUT_REGS_A : integer;
  attribute C_HAS_MEM_OUTPUT_REGS_A of U0 : label is 1;
  attribute C_HAS_MEM_OUTPUT_REGS_B : integer;
  attribute C_HAS_MEM_OUTPUT_REGS_B of U0 : label is 0;
  attribute C_HAS_MUX_OUTPUT_REGS_A : integer;
  attribute C_HAS_MUX_OUTPUT_REGS_A of U0 : label is 0;
  attribute C_HAS_MUX_OUTPUT_REGS_B : integer;
  attribute C_HAS_MUX_OUTPUT_REGS_B of U0 : label is 0;
  attribute C_HAS_REGCEA : integer;
  attribute C_HAS_REGCEA of U0 : label is 0;
  attribute C_HAS_REGCEB : integer;
  attribute C_HAS_REGCEB of U0 : label is 0;
  attribute C_HAS_RSTA : integer;
  attribute C_HAS_RSTA of U0 : label is 0;
  attribute C_HAS_RSTB : integer;
  attribute C_HAS_RSTB of U0 : label is 0;
  attribute C_HAS_SOFTECC_INPUT_REGS_A : integer;
  attribute C_HAS_SOFTECC_INPUT_REGS_A of U0 : label is 0;
  attribute C_HAS_SOFTECC_OUTPUT_REGS_B : integer;
  attribute C_HAS_SOFTECC_OUTPUT_REGS_B of U0 : label is 0;
  attribute C_INITA_VAL : string;
  attribute C_INITA_VAL of U0 : label is "0";
  attribute C_INITB_VAL : string;
  attribute C_INITB_VAL of U0 : label is "0";
  attribute C_INIT_FILE : string;
  attribute C_INIT_FILE of U0 : label is "cpumemory.mem";
  attribute C_INIT_FILE_NAME : string;
  attribute C_INIT_FILE_NAME of U0 : label is "cpumemory.mif";
  attribute C_INTERFACE_TYPE : integer;
  attribute C_INTERFACE_TYPE of U0 : label is 0;
  attribute C_LOAD_INIT_FILE : integer;
  attribute C_LOAD_INIT_FILE of U0 : label is 1;
  attribute C_MEM_TYPE : integer;
  attribute C_MEM_TYPE of U0 : label is 0;
  attribute C_MUX_PIPELINE_STAGES : integer;
  attribute C_MUX_PIPELINE_STAGES of U0 : label is 0;
  attribute C_PRIM_TYPE : integer;
  attribute C_PRIM_TYPE of U0 : label is 1;
  attribute C_READ_DEPTH_A : integer;
  attribute C_READ_DEPTH_A of U0 : label is 4096;
  attribute C_READ_DEPTH_B : integer;
  attribute C_READ_DEPTH_B of U0 : label is 4096;
  attribute C_READ_LATENCY_A : integer;
  attribute C_READ_LATENCY_A of U0 : label is 1;
  attribute C_READ_LATENCY_B : integer;
  attribute C_READ_LATENCY_B of U0 : label is 1;
  attribute C_READ_WIDTH_A : integer;
  attribute C_READ_WIDTH_A of U0 : label is 32;
  attribute C_READ_WIDTH_B : integer;
  attribute C_READ_WIDTH_B of U0 : label is 32;
  attribute C_RSTRAM_A : integer;
  attribute C_RSTRAM_A of U0 : label is 0;
  attribute C_RSTRAM_B : integer;
  attribute C_RSTRAM_B of U0 : label is 0;
  attribute C_RST_PRIORITY_A : string;
  attribute C_RST_PRIORITY_A of U0 : label is "CE";
  attribute C_RST_PRIORITY_B : string;
  attribute C_RST_PRIORITY_B of U0 : label is "CE";
  attribute C_SIM_COLLISION_CHECK : string;
  attribute C_SIM_COLLISION_CHECK of U0 : label is "ALL";
  attribute C_USE_BRAM_BLOCK : integer;
  attribute C_USE_BRAM_BLOCK of U0 : label is 0;
  attribute C_USE_BYTE_WEA : integer;
  attribute C_USE_BYTE_WEA of U0 : label is 0;
  attribute C_USE_BYTE_WEB : integer;
  attribute C_USE_BYTE_WEB of U0 : label is 0;
  attribute C_USE_DEFAULT_DATA : integer;
  attribute C_USE_DEFAULT_DATA of U0 : label is 1;
  attribute C_USE_ECC : integer;
  attribute C_USE_ECC of U0 : label is 0;
  attribute C_USE_SOFTECC : integer;
  attribute C_USE_SOFTECC of U0 : label is 0;
  attribute C_USE_URAM : integer;
  attribute C_USE_URAM of U0 : label is 0;
  attribute C_WEA_WIDTH : integer;
  attribute C_WEA_WIDTH of U0 : label is 1;
  attribute C_WEB_WIDTH : integer;
  attribute C_WEB_WIDTH of U0 : label is 1;
  attribute C_WRITE_DEPTH_A : integer;
  attribute C_WRITE_DEPTH_A of U0 : label is 4096;
  attribute C_WRITE_DEPTH_B : integer;
  attribute C_WRITE_DEPTH_B of U0 : label is 4096;
  attribute C_WRITE_MODE_A : string;
  attribute C_WRITE_MODE_A of U0 : label is "WRITE_FIRST";
  attribute C_WRITE_MODE_B : string;
  attribute C_WRITE_MODE_B of U0 : label is "WRITE_FIRST";
  attribute C_WRITE_WIDTH_A : integer;
  attribute C_WRITE_WIDTH_A of U0 : label is 32;
  attribute C_WRITE_WIDTH_B : integer;
  attribute C_WRITE_WIDTH_B of U0 : label is 32;
  attribute C_XDEVICEFAMILY : string;
  attribute C_XDEVICEFAMILY of U0 : label is "spartan7";
  attribute downgradeipidentifiedwarnings of U0 : label is "yes";
  attribute is_du_within_envelope : string;
  attribute is_du_within_envelope of U0 : label is "true";
  attribute x_interface_info : string;
  attribute x_interface_info of clka : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of clka : signal is "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1";
  attribute x_interface_info of ena : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA EN";
  attribute x_interface_info of addra : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR";
  attribute x_interface_info of dina : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN";
  attribute x_interface_info of douta : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT";
  attribute x_interface_info of wea : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA WE";
begin
U0: entity work.cpumemory_blk_mem_gen_v8_4_7
     port map (
      addra(11 downto 0) => addra(11 downto 0),
      addrb(11 downto 0) => B"000000000000",
      clka => clka,
      clkb => '0',
      dbiterr => NLW_U0_dbiterr_UNCONNECTED,
      deepsleep => '0',
      dina(31 downto 0) => dina(31 downto 0),
      dinb(31 downto 0) => B"00000000000000000000000000000000",
      douta(31 downto 0) => douta(31 downto 0),
      doutb(31 downto 0) => NLW_U0_doutb_UNCONNECTED(31 downto 0),
      eccpipece => '0',
      ena => ena,
      enb => '0',
      injectdbiterr => '0',
      injectsbiterr => '0',
      rdaddrecc(11 downto 0) => NLW_U0_rdaddrecc_UNCONNECTED(11 downto 0),
      regcea => '0',
      regceb => '0',
      rsta => '0',
      rsta_busy => NLW_U0_rsta_busy_UNCONNECTED,
      rstb => '0',
      rstb_busy => NLW_U0_rstb_busy_UNCONNECTED,
      s_aclk => '0',
      s_aresetn => '0',
      s_axi_araddr(31 downto 0) => B"00000000000000000000000000000000",
      s_axi_arburst(1 downto 0) => B"00",
      s_axi_arid(3 downto 0) => B"0000",
      s_axi_arlen(7 downto 0) => B"00000000",
      s_axi_arready => NLW_U0_s_axi_arready_UNCONNECTED,
      s_axi_arsize(2 downto 0) => B"000",
      s_axi_arvalid => '0',
      s_axi_awaddr(31 downto 0) => B"00000000000000000000000000000000",
      s_axi_awburst(1 downto 0) => B"00",
      s_axi_awid(3 downto 0) => B"0000",
      s_axi_awlen(7 downto 0) => B"00000000",
      s_axi_awready => NLW_U0_s_axi_awready_UNCONNECTED,
      s_axi_awsize(2 downto 0) => B"000",
      s_axi_awvalid => '0',
      s_axi_bid(3 downto 0) => NLW_U0_s_axi_bid_UNCONNECTED(3 downto 0),
      s_axi_bready => '0',
      s_axi_bresp(1 downto 0) => NLW_U0_s_axi_bresp_UNCONNECTED(1 downto 0),
      s_axi_bvalid => NLW_U0_s_axi_bvalid_UNCONNECTED,
      s_axi_dbiterr => NLW_U0_s_axi_dbiterr_UNCONNECTED,
      s_axi_injectdbiterr => '0',
      s_axi_injectsbiterr => '0',
      s_axi_rdaddrecc(11 downto 0) => NLW_U0_s_axi_rdaddrecc_UNCONNECTED(11 downto 0),
      s_axi_rdata(31 downto 0) => NLW_U0_s_axi_rdata_UNCONNECTED(31 downto 0),
      s_axi_rid(3 downto 0) => NLW_U0_s_axi_rid_UNCONNECTED(3 downto 0),
      s_axi_rlast => NLW_U0_s_axi_rlast_UNCONNECTED,
      s_axi_rready => '0',
      s_axi_rresp(1 downto 0) => NLW_U0_s_axi_rresp_UNCONNECTED(1 downto 0),
      s_axi_rvalid => NLW_U0_s_axi_rvalid_UNCONNECTED,
      s_axi_sbiterr => NLW_U0_s_axi_sbiterr_UNCONNECTED,
      s_axi_wdata(31 downto 0) => B"00000000000000000000000000000000",
      s_axi_wlast => '0',
      s_axi_wready => NLW_U0_s_axi_wready_UNCONNECTED,
      s_axi_wstrb(0) => '0',
      s_axi_wvalid => '0',
      sbiterr => NLW_U0_sbiterr_UNCONNECTED,
      shutdown => '0',
      sleep => '0',
      wea(0) => wea(0),
      web(0) => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity Memory is
  port (
    D : out STD_LOGIC_VECTOR ( 19 downto 0 );
    clk_IBUF_BUFG : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 11 downto 0 )
  );
end Memory;

architecture STRUCTURE of Memory is
  signal douta : STD_LOGIC_VECTOR ( 15 downto 4 );
  attribute IMPORTED_FROM : string;
  attribute IMPORTED_FROM of instmemory : label is "d:/Users/Craig/Documents/000 ArtyS7/CPU2/CPU2.gen/sources_1/ip/cpumemory/cpumemory.dcp";
  attribute IMPORTED_TYPE : string;
  attribute IMPORTED_TYPE of instmemory : label is "CHECKPOINT";
  attribute IS_IMPORTED : boolean;
  attribute IS_IMPORTED of instmemory : label is std.standard.true;
  attribute syn_black_box : string;
  attribute syn_black_box of instmemory : label is "TRUE";
  attribute x_core_info : string;
  attribute x_core_info of instmemory : label is "blk_mem_gen_v8_4_7,Vivado 2023.2";
begin
instmemory: entity work.cpumemory
     port map (
      addra(11 downto 0) => Q(11 downto 0),
      clka => clk_IBUF_BUFG,
      dina(31 downto 0) => B"00000000000000000000000000000000",
      douta(31 downto 16) => D(19 downto 4),
      douta(15 downto 4) => douta(15 downto 4),
      douta(3 downto 0) => D(3 downto 0),
      ena => '1',
      wea(0) => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity CPU is
  port (
    rst : in STD_LOGIC;
    clk : in STD_LOGIC;
    led : out STD_LOGIC_VECTOR ( 3 downto 0 );
    rgb : out STD_LOGIC_VECTOR ( 5 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of CPU : entity is true;
end CPU;

architecture STRUCTURE of CPU is
  signal \FSM_onehot_cycle[4]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_cycle[5]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_cycle_reg_n_0_[1]\ : STD_LOGIC;
  signal \FSM_onehot_cycle_reg_n_0_[3]\ : STD_LOGIC;
  signal \FSM_onehot_cycle_reg_n_0_[4]\ : STD_LOGIC;
  signal \FSM_onehot_cycle_reg_n_0_[5]\ : STD_LOGIC;
  signal \FSM_onehot_cycle_reg_n_0_[7]\ : STD_LOGIC;
  signal ProgCounter : STD_LOGIC;
  signal \ProgCounter[0]_i_2_n_0\ : STD_LOGIC;
  signal ProgCounter_reg : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal \ProgCounter_reg[0]_i_1_n_0\ : STD_LOGIC;
  signal \ProgCounter_reg[0]_i_1_n_1\ : STD_LOGIC;
  signal \ProgCounter_reg[0]_i_1_n_2\ : STD_LOGIC;
  signal \ProgCounter_reg[0]_i_1_n_3\ : STD_LOGIC;
  signal \ProgCounter_reg[0]_i_1_n_4\ : STD_LOGIC;
  signal \ProgCounter_reg[0]_i_1_n_5\ : STD_LOGIC;
  signal \ProgCounter_reg[0]_i_1_n_6\ : STD_LOGIC;
  signal \ProgCounter_reg[0]_i_1_n_7\ : STD_LOGIC;
  signal \ProgCounter_reg[4]_i_1_n_0\ : STD_LOGIC;
  signal \ProgCounter_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \ProgCounter_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \ProgCounter_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \ProgCounter_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \ProgCounter_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \ProgCounter_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \ProgCounter_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \ProgCounter_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \ProgCounter_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \ProgCounter_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \ProgCounter_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \ProgCounter_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \ProgCounter_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \ProgCounter_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal addra : STD_LOGIC;
  signal \addra_reg_n_0_[0]\ : STD_LOGIC;
  signal \addra_reg_n_0_[10]\ : STD_LOGIC;
  signal \addra_reg_n_0_[11]\ : STD_LOGIC;
  signal \addra_reg_n_0_[1]\ : STD_LOGIC;
  signal \addra_reg_n_0_[2]\ : STD_LOGIC;
  signal \addra_reg_n_0_[3]\ : STD_LOGIC;
  signal \addra_reg_n_0_[4]\ : STD_LOGIC;
  signal \addra_reg_n_0_[5]\ : STD_LOGIC;
  signal \addra_reg_n_0_[6]\ : STD_LOGIC;
  signal \addra_reg_n_0_[7]\ : STD_LOGIC;
  signal \addra_reg_n_0_[8]\ : STD_LOGIC;
  signal \addra_reg_n_0_[9]\ : STD_LOGIC;
  signal clk_IBUF : STD_LOGIC;
  signal clk_IBUF_BUFG : STD_LOGIC;
  signal douta : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ena : STD_LOGIC;
  signal highlow : STD_LOGIC;
  signal inst : STD_LOGIC_VECTOR ( 31 downto 16 );
  signal instruction : STD_LOGIC;
  signal \instruction_reg_n_0_[0]\ : STD_LOGIC;
  signal \instruction_reg_n_0_[1]\ : STD_LOGIC;
  signal \instruction_reg_n_0_[2]\ : STD_LOGIC;
  signal \instruction_reg_n_0_[3]\ : STD_LOGIC;
  signal led_OBUF : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal p_0_in : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal regena_i_1_n_0 : STD_LOGIC;
  signal regena_i_2_n_0 : STD_LOGIC;
  signal regin : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \regin[3]_i_3_n_0\ : STD_LOGIC;
  signal \regin_reg_n_0_[0]\ : STD_LOGIC;
  signal \regin_reg_n_0_[1]\ : STD_LOGIC;
  signal \regin_reg_n_0_[2]\ : STD_LOGIC;
  signal \regin_reg_n_0_[3]\ : STD_LOGIC;
  signal regnum : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \regnum[3]_i_1_n_0\ : STD_LOGIC;
  signal \regnum_reg_n_0_[0]\ : STD_LOGIC;
  signal \regnum_reg_n_0_[1]\ : STD_LOGIC;
  signal \regnum_reg_n_0_[2]\ : STD_LOGIC;
  signal \regnum_reg_n_0_[3]\ : STD_LOGIC;
  signal regout : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal regtmp : STD_LOGIC;
  signal \regtmp_reg_n_0_[0]\ : STD_LOGIC;
  signal \regtmp_reg_n_0_[1]\ : STD_LOGIC;
  signal \regtmp_reg_n_0_[2]\ : STD_LOGIC;
  signal \regtmp_reg_n_0_[3]\ : STD_LOGIC;
  signal rgb_OBUF : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal rst_IBUF : STD_LOGIC;
  signal we : STD_LOGIC;
  signal \NLW_ProgCounter_reg[8]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_onehot_cycle[4]_i_1\ : label is "soft_lutpair0";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_onehot_cycle_reg[0]\ : label is "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000";
  attribute FSM_ENCODED_STATES of \FSM_onehot_cycle_reg[1]\ : label is "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000";
  attribute FSM_ENCODED_STATES of \FSM_onehot_cycle_reg[2]\ : label is "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000";
  attribute FSM_ENCODED_STATES of \FSM_onehot_cycle_reg[3]\ : label is "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000";
  attribute FSM_ENCODED_STATES of \FSM_onehot_cycle_reg[4]\ : label is "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000";
  attribute FSM_ENCODED_STATES of \FSM_onehot_cycle_reg[5]\ : label is "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000";
  attribute FSM_ENCODED_STATES of \FSM_onehot_cycle_reg[6]\ : label is "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000";
  attribute FSM_ENCODED_STATES of \FSM_onehot_cycle_reg[7]\ : label is "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of \ProgCounter_reg[0]_i_1\ : label is 11;
  attribute ADDER_THRESHOLD of \ProgCounter_reg[4]_i_1\ : label is 11;
  attribute ADDER_THRESHOLD of \ProgCounter_reg[8]_i_1\ : label is 11;
  attribute SOFT_HLUTNM of regena_i_2 : label is "soft_lutpair0";
begin
\FSM_onehot_cycle[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => \FSM_onehot_cycle_reg_n_0_[3]\,
      I1 => inst(25),
      I2 => inst(24),
      O => \FSM_onehot_cycle[4]_i_1_n_0\
    );
\FSM_onehot_cycle[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFA8"
    )
        port map (
      I0 => \FSM_onehot_cycle_reg_n_0_[3]\,
      I1 => inst(24),
      I2 => inst(25),
      I3 => \FSM_onehot_cycle_reg_n_0_[4]\,
      O => \FSM_onehot_cycle[5]_i_1_n_0\
    );
\FSM_onehot_cycle_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \FSM_onehot_cycle_reg_n_0_[7]\,
      Q => addra,
      S => rst_IBUF
    );
\FSM_onehot_cycle_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => addra,
      Q => \FSM_onehot_cycle_reg_n_0_[1]\,
      R => rst_IBUF
    );
\FSM_onehot_cycle_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \FSM_onehot_cycle_reg_n_0_[1]\,
      Q => instruction,
      R => rst_IBUF
    );
\FSM_onehot_cycle_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => instruction,
      Q => \FSM_onehot_cycle_reg_n_0_[3]\,
      R => rst_IBUF
    );
\FSM_onehot_cycle_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \FSM_onehot_cycle[4]_i_1_n_0\,
      Q => \FSM_onehot_cycle_reg_n_0_[4]\,
      R => rst_IBUF
    );
\FSM_onehot_cycle_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \FSM_onehot_cycle[5]_i_1_n_0\,
      Q => \FSM_onehot_cycle_reg_n_0_[5]\,
      R => rst_IBUF
    );
\FSM_onehot_cycle_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \FSM_onehot_cycle_reg_n_0_[5]\,
      Q => ProgCounter,
      R => rst_IBUF
    );
\FSM_onehot_cycle_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => ProgCounter,
      Q => \FSM_onehot_cycle_reg_n_0_[7]\,
      R => rst_IBUF
    );
\ProgCounter[0]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => ProgCounter_reg(0),
      O => \ProgCounter[0]_i_2_n_0\
    );
\ProgCounter_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => ProgCounter,
      D => \ProgCounter_reg[0]_i_1_n_7\,
      Q => ProgCounter_reg(0),
      R => rst_IBUF
    );
\ProgCounter_reg[0]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \ProgCounter_reg[0]_i_1_n_0\,
      CO(2) => \ProgCounter_reg[0]_i_1_n_1\,
      CO(1) => \ProgCounter_reg[0]_i_1_n_2\,
      CO(0) => \ProgCounter_reg[0]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \ProgCounter_reg[0]_i_1_n_4\,
      O(2) => \ProgCounter_reg[0]_i_1_n_5\,
      O(1) => \ProgCounter_reg[0]_i_1_n_6\,
      O(0) => \ProgCounter_reg[0]_i_1_n_7\,
      S(3 downto 1) => ProgCounter_reg(3 downto 1),
      S(0) => \ProgCounter[0]_i_2_n_0\
    );
\ProgCounter_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => ProgCounter,
      D => \ProgCounter_reg[8]_i_1_n_5\,
      Q => ProgCounter_reg(10),
      R => rst_IBUF
    );
\ProgCounter_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => ProgCounter,
      D => \ProgCounter_reg[8]_i_1_n_4\,
      Q => ProgCounter_reg(11),
      R => rst_IBUF
    );
\ProgCounter_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => ProgCounter,
      D => \ProgCounter_reg[0]_i_1_n_6\,
      Q => ProgCounter_reg(1),
      R => rst_IBUF
    );
\ProgCounter_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => ProgCounter,
      D => \ProgCounter_reg[0]_i_1_n_5\,
      Q => ProgCounter_reg(2),
      R => rst_IBUF
    );
\ProgCounter_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => ProgCounter,
      D => \ProgCounter_reg[0]_i_1_n_4\,
      Q => ProgCounter_reg(3),
      R => rst_IBUF
    );
\ProgCounter_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => ProgCounter,
      D => \ProgCounter_reg[4]_i_1_n_7\,
      Q => ProgCounter_reg(4),
      R => rst_IBUF
    );
\ProgCounter_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \ProgCounter_reg[0]_i_1_n_0\,
      CO(3) => \ProgCounter_reg[4]_i_1_n_0\,
      CO(2) => \ProgCounter_reg[4]_i_1_n_1\,
      CO(1) => \ProgCounter_reg[4]_i_1_n_2\,
      CO(0) => \ProgCounter_reg[4]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \ProgCounter_reg[4]_i_1_n_4\,
      O(2) => \ProgCounter_reg[4]_i_1_n_5\,
      O(1) => \ProgCounter_reg[4]_i_1_n_6\,
      O(0) => \ProgCounter_reg[4]_i_1_n_7\,
      S(3 downto 0) => ProgCounter_reg(7 downto 4)
    );
\ProgCounter_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => ProgCounter,
      D => \ProgCounter_reg[4]_i_1_n_6\,
      Q => ProgCounter_reg(5),
      R => rst_IBUF
    );
\ProgCounter_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => ProgCounter,
      D => \ProgCounter_reg[4]_i_1_n_5\,
      Q => ProgCounter_reg(6),
      R => rst_IBUF
    );
\ProgCounter_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => ProgCounter,
      D => \ProgCounter_reg[4]_i_1_n_4\,
      Q => ProgCounter_reg(7),
      R => rst_IBUF
    );
\ProgCounter_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => ProgCounter,
      D => \ProgCounter_reg[8]_i_1_n_7\,
      Q => ProgCounter_reg(8),
      R => rst_IBUF
    );
\ProgCounter_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \ProgCounter_reg[4]_i_1_n_0\,
      CO(3) => \NLW_ProgCounter_reg[8]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \ProgCounter_reg[8]_i_1_n_1\,
      CO(1) => \ProgCounter_reg[8]_i_1_n_2\,
      CO(0) => \ProgCounter_reg[8]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \ProgCounter_reg[8]_i_1_n_4\,
      O(2) => \ProgCounter_reg[8]_i_1_n_5\,
      O(1) => \ProgCounter_reg[8]_i_1_n_6\,
      O(0) => \ProgCounter_reg[8]_i_1_n_7\,
      S(3 downto 0) => ProgCounter_reg(11 downto 8)
    );
\ProgCounter_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => ProgCounter,
      D => \ProgCounter_reg[8]_i_1_n_6\,
      Q => ProgCounter_reg(9),
      R => rst_IBUF
    );
\addra_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => addra,
      D => ProgCounter_reg(0),
      Q => \addra_reg_n_0_[0]\,
      R => rst_IBUF
    );
\addra_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => addra,
      D => ProgCounter_reg(10),
      Q => \addra_reg_n_0_[10]\,
      R => rst_IBUF
    );
\addra_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => addra,
      D => ProgCounter_reg(11),
      Q => \addra_reg_n_0_[11]\,
      R => rst_IBUF
    );
\addra_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => addra,
      D => ProgCounter_reg(1),
      Q => \addra_reg_n_0_[1]\,
      R => rst_IBUF
    );
\addra_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => addra,
      D => ProgCounter_reg(2),
      Q => \addra_reg_n_0_[2]\,
      R => rst_IBUF
    );
\addra_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => addra,
      D => ProgCounter_reg(3),
      Q => \addra_reg_n_0_[3]\,
      R => rst_IBUF
    );
\addra_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => addra,
      D => ProgCounter_reg(4),
      Q => \addra_reg_n_0_[4]\,
      R => rst_IBUF
    );
\addra_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => addra,
      D => ProgCounter_reg(5),
      Q => \addra_reg_n_0_[5]\,
      R => rst_IBUF
    );
\addra_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => addra,
      D => ProgCounter_reg(6),
      Q => \addra_reg_n_0_[6]\,
      R => rst_IBUF
    );
\addra_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => addra,
      D => ProgCounter_reg(7),
      Q => \addra_reg_n_0_[7]\,
      R => rst_IBUF
    );
\addra_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => addra,
      D => ProgCounter_reg(8),
      Q => \addra_reg_n_0_[8]\,
      R => rst_IBUF
    );
\addra_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => addra,
      D => ProgCounter_reg(9),
      Q => \addra_reg_n_0_[9]\,
      R => rst_IBUF
    );
clk_IBUF_BUFG_inst: unisim.vcomponents.BUFG
     port map (
      I => clk_IBUF,
      O => clk_IBUF_BUFG
    );
clk_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => clk,
      O => clk_IBUF
    );
\instruction_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(0),
      Q => \instruction_reg_n_0_[0]\,
      R => rst_IBUF
    );
\instruction_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(16),
      Q => inst(16),
      R => rst_IBUF
    );
\instruction_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(17),
      Q => inst(17),
      R => rst_IBUF
    );
\instruction_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(18),
      Q => inst(18),
      R => rst_IBUF
    );
\instruction_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(19),
      Q => inst(19),
      R => rst_IBUF
    );
\instruction_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(1),
      Q => \instruction_reg_n_0_[1]\,
      R => rst_IBUF
    );
\instruction_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(20),
      Q => inst(20),
      R => rst_IBUF
    );
\instruction_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(21),
      Q => inst(21),
      R => rst_IBUF
    );
\instruction_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(22),
      Q => inst(22),
      R => rst_IBUF
    );
\instruction_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(23),
      Q => inst(23),
      R => rst_IBUF
    );
\instruction_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(24),
      Q => inst(24),
      R => rst_IBUF
    );
\instruction_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(25),
      Q => inst(25),
      R => rst_IBUF
    );
\instruction_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(26),
      Q => highlow,
      R => rst_IBUF
    );
\instruction_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(27),
      Q => inst(27),
      R => rst_IBUF
    );
\instruction_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(28),
      Q => inst(28),
      R => rst_IBUF
    );
\instruction_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(29),
      Q => inst(29),
      R => rst_IBUF
    );
\instruction_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(2),
      Q => \instruction_reg_n_0_[2]\,
      R => rst_IBUF
    );
\instruction_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(30),
      Q => inst(30),
      R => rst_IBUF
    );
\instruction_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(31),
      Q => inst(31),
      R => rst_IBUF
    );
\instruction_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(3),
      Q => \instruction_reg_n_0_[3]\,
      R => rst_IBUF
    );
\led_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => led_OBUF(0),
      O => led(0)
    );
\led_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => led_OBUF(1),
      O => led(1)
    );
\led_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => led_OBUF(2),
      O => led(2)
    );
\led_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => led_OBUF(3),
      O => led(3)
    );
\led_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => regtmp,
      D => \regtmp_reg_n_0_[0]\,
      Q => led_OBUF(0),
      S => rst_IBUF
    );
\led_reg[1]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => regtmp,
      D => \regtmp_reg_n_0_[1]\,
      Q => led_OBUF(1),
      S => rst_IBUF
    );
\led_reg[2]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => regtmp,
      D => \regtmp_reg_n_0_[2]\,
      Q => led_OBUF(2),
      S => rst_IBUF
    );
\led_reg[3]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => regtmp,
      D => \regtmp_reg_n_0_[3]\,
      Q => led_OBUF(3),
      S => rst_IBUF
    );
memory2: entity work.Memory
     port map (
      D(19 downto 4) => douta(31 downto 16),
      D(3 downto 0) => douta(3 downto 0),
      Q(11) => \addra_reg_n_0_[11]\,
      Q(10) => \addra_reg_n_0_[10]\,
      Q(9) => \addra_reg_n_0_[9]\,
      Q(8) => \addra_reg_n_0_[8]\,
      Q(7) => \addra_reg_n_0_[7]\,
      Q(6) => \addra_reg_n_0_[6]\,
      Q(5) => \addra_reg_n_0_[5]\,
      Q(4) => \addra_reg_n_0_[4]\,
      Q(3) => \addra_reg_n_0_[3]\,
      Q(2) => \addra_reg_n_0_[2]\,
      Q(1) => \addra_reg_n_0_[1]\,
      Q(0) => \addra_reg_n_0_[0]\,
      clk_IBUF_BUFG => clk_IBUF_BUFG
    );
reg1: entity work.Registers
     port map (
      Q(3) => \regin_reg_n_0_[3]\,
      Q(2) => \regin_reg_n_0_[2]\,
      Q(1) => \regin_reg_n_0_[1]\,
      Q(0) => \regin_reg_n_0_[0]\,
      clk_IBUF_BUFG => clk_IBUF_BUFG,
      ena => ena,
      regout(3 downto 0) => regout(3 downto 0),
      \regout_reg[0]_0\(3) => \regnum_reg_n_0_[3]\,
      \regout_reg[0]_0\(2) => \regnum_reg_n_0_[2]\,
      \regout_reg[0]_0\(1) => \regnum_reg_n_0_[1]\,
      \regout_reg[0]_0\(0) => \regnum_reg_n_0_[0]\,
      we => we
    );
regena_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EEEFEEE0"
    )
        port map (
      I0 => ProgCounter,
      I1 => \FSM_onehot_cycle_reg_n_0_[3]\,
      I2 => regena_i_2_n_0,
      I3 => addra,
      I4 => ena,
      O => regena_i_1_n_0
    );
regena_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"808F8080"
    )
        port map (
      I0 => \regin[3]_i_3_n_0\,
      I1 => ProgCounter,
      I2 => inst(24),
      I3 => inst(25),
      I4 => \FSM_onehot_cycle_reg_n_0_[3]\,
      O => regena_i_2_n_0
    );
regena_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => regena_i_1_n_0,
      Q => ena,
      R => rst_IBUF
    );
\regin[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"ABA8"
    )
        port map (
      I0 => \instruction_reg_n_0_[0]\,
      I1 => inst(24),
      I2 => inst(25),
      I3 => \regtmp_reg_n_0_[0]\,
      O => p_0_in(0)
    );
\regin[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"ABA8"
    )
        port map (
      I0 => \instruction_reg_n_0_[1]\,
      I1 => inst(24),
      I2 => inst(25),
      I3 => \regtmp_reg_n_0_[1]\,
      O => p_0_in(1)
    );
\regin[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"ABA8"
    )
        port map (
      I0 => \instruction_reg_n_0_[2]\,
      I1 => inst(24),
      I2 => inst(25),
      I3 => \regtmp_reg_n_0_[2]\,
      O => p_0_in(2)
    );
\regin[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0888"
    )
        port map (
      I0 => \regin[3]_i_3_n_0\,
      I1 => ProgCounter,
      I2 => highlow,
      I3 => inst(24),
      O => regin(3)
    );
\regin[3]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"ABA8"
    )
        port map (
      I0 => \instruction_reg_n_0_[3]\,
      I1 => inst(24),
      I2 => inst(25),
      I3 => \regtmp_reg_n_0_[3]\,
      O => p_0_in(3)
    );
\regin[3]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000100"
    )
        port map (
      I0 => inst(29),
      I1 => inst(30),
      I2 => inst(28),
      I3 => inst(27),
      I4 => inst(25),
      I5 => inst(31),
      O => \regin[3]_i_3_n_0\
    );
\regin_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => regin(3),
      D => p_0_in(0),
      Q => \regin_reg_n_0_[0]\,
      R => rst_IBUF
    );
\regin_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => regin(3),
      D => p_0_in(1),
      Q => \regin_reg_n_0_[1]\,
      R => rst_IBUF
    );
\regin_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => regin(3),
      D => p_0_in(2),
      Q => \regin_reg_n_0_[2]\,
      R => rst_IBUF
    );
\regin_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => regin(3),
      D => p_0_in(3),
      Q => \regin_reg_n_0_[3]\,
      R => rst_IBUF
    );
\regnum[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => inst(20),
      I1 => ProgCounter,
      I2 => inst(16),
      I3 => \FSM_onehot_cycle_reg_n_0_[3]\,
      O => regnum(0)
    );
\regnum[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => inst(21),
      I1 => ProgCounter,
      I2 => inst(17),
      I3 => \FSM_onehot_cycle_reg_n_0_[3]\,
      O => regnum(1)
    );
\regnum[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => inst(22),
      I1 => ProgCounter,
      I2 => inst(18),
      I3 => \FSM_onehot_cycle_reg_n_0_[3]\,
      O => regnum(2)
    );
\regnum[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"888808F8"
    )
        port map (
      I0 => \regin[3]_i_3_n_0\,
      I1 => ProgCounter,
      I2 => \FSM_onehot_cycle_reg_n_0_[3]\,
      I3 => inst(25),
      I4 => inst(24),
      O => \regnum[3]_i_1_n_0\
    );
\regnum[3]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => inst(23),
      I1 => ProgCounter,
      I2 => inst(19),
      I3 => \FSM_onehot_cycle_reg_n_0_[3]\,
      O => regnum(3)
    );
\regnum_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \regnum[3]_i_1_n_0\,
      D => regnum(0),
      Q => \regnum_reg_n_0_[0]\,
      R => rst_IBUF
    );
\regnum_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \regnum[3]_i_1_n_0\,
      D => regnum(1),
      Q => \regnum_reg_n_0_[1]\,
      R => rst_IBUF
    );
\regnum_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \regnum[3]_i_1_n_0\,
      D => regnum(2),
      Q => \regnum_reg_n_0_[2]\,
      R => rst_IBUF
    );
\regnum_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \regnum[3]_i_1_n_0\,
      D => regnum(3),
      Q => \regnum_reg_n_0_[3]\,
      R => rst_IBUF
    );
\regtmp[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000FF000000FE"
    )
        port map (
      I0 => ProgCounter,
      I1 => \FSM_onehot_cycle_reg_n_0_[4]\,
      I2 => \FSM_onehot_cycle_reg_n_0_[5]\,
      I3 => inst(25),
      I4 => inst(24),
      I5 => \FSM_onehot_cycle_reg_n_0_[7]\,
      O => regtmp
    );
\regtmp_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => regtmp,
      D => regout(0),
      Q => \regtmp_reg_n_0_[0]\,
      R => rst_IBUF
    );
\regtmp_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => regtmp,
      D => regout(1),
      Q => \regtmp_reg_n_0_[1]\,
      R => rst_IBUF
    );
\regtmp_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => regtmp,
      D => regout(2),
      Q => \regtmp_reg_n_0_[2]\,
      R => rst_IBUF
    );
\regtmp_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => regtmp,
      D => regout(3),
      Q => \regtmp_reg_n_0_[3]\,
      R => rst_IBUF
    );
\rgb_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => rgb_OBUF(0),
      O => rgb(0)
    );
\rgb_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => rgb_OBUF(1),
      O => rgb(1)
    );
\rgb_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => rgb_OBUF(2),
      O => rgb(2)
    );
\rgb_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => rgb_OBUF(3),
      O => rgb(3)
    );
\rgb_OBUF[4]_inst\: unisim.vcomponents.OBUF
     port map (
      I => rgb_OBUF(4),
      O => rgb(4)
    );
\rgb_OBUF[5]_inst\: unisim.vcomponents.OBUF
     port map (
      I => rgb_OBUF(5),
      O => rgb(5)
    );
\rgb_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => inst(27),
      Q => rgb_OBUF(0),
      R => rst_IBUF
    );
\rgb_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => inst(28),
      Q => rgb_OBUF(1),
      R => rst_IBUF
    );
\rgb_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => inst(29),
      Q => rgb_OBUF(2),
      R => rst_IBUF
    );
\rgb_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => inst(30),
      Q => rgb_OBUF(3),
      R => rst_IBUF
    );
\rgb_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => inst(31),
      Q => rgb_OBUF(4),
      R => rst_IBUF
    );
\rgb_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => inst(24),
      Q => rgb_OBUF(5),
      R => rst_IBUF
    );
rst_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => rst,
      O => rst_IBUF
    );
we_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \regnum[3]_i_1_n_0\,
      D => ProgCounter,
      Q => we,
      R => rst_IBUF
    );
end STRUCTURE;
