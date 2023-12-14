-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
-- Date        : Wed Dec 13 18:02:11 2023
-- Host        : AlienCraig running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file {D:/Users/Craig/Documents/000
--               ArtyS7/CPU2/CPU2.sim/sim_1/impl/func/xsim/SimCPU_func_impl.vhd}
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
    we : in STD_LOGIC;
    \regout_reg[0]_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
end Registers;

architecture STRUCTURE of Registers is
  signal p_0_out : STD_LOGIC;
  signal regist_reg_0_15_0_0_n_0 : STD_LOGIC;
  signal regist_reg_0_15_1_1_n_0 : STD_LOGIC;
  signal regist_reg_0_15_2_2_n_0 : STD_LOGIC;
  signal regist_reg_0_15_3_3_n_0 : STD_LOGIC;
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
      O => regist_reg_0_15_0_0_n_0,
      WCLK => clk_IBUF_BUFG,
      WE => we
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
      O => regist_reg_0_15_1_1_n_0,
      WCLK => clk_IBUF_BUFG,
      WE => we
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
      O => regist_reg_0_15_2_2_n_0,
      WCLK => clk_IBUF_BUFG,
      WE => we
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
      O => regist_reg_0_15_3_3_n_0,
      WCLK => clk_IBUF_BUFG,
      WE => we
    );
\regout[3]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => we,
      O => p_0_out
    );
\regout_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => p_0_out,
      D => regist_reg_0_15_0_0_n_0,
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
      D => regist_reg_0_15_1_1_n_0,
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
      D => regist_reg_0_15_2_2_n_0,
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
      D => regist_reg_0_15_3_3_n_0,
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
`protect encoding = (enctype = "BASE64", line_length = 76, bytes = 99888)
`protect data_block
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
bmpIV1gxfYFr0o9EV+034ssri+sNfDYx
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
    douta : out STD_LOGIC_VECTOR ( 31 downto 0 );
    pwropt : in STD_LOGIC;
    pwropt_1 : in STD_LOGIC
  );
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of cpumemory : entity is "cpumemory,blk_mem_gen_v8_4_7,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of cpumemory : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of cpumemory : entity is "blk_mem_gen_v8_4_7,Vivado 2023.2";
end cpumemory;

architecture STRUCTURE of cpumemory is
  signal NLW_U0_clkb_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_dbiterr_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_deepsleep_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_eccpipece_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_enb_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_injectdbiterr_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_injectsbiterr_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_regcea_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_regceb_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_rsta_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_rsta_busy_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_rstb_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_rstb_busy_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_aclk_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_aresetn_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_arready_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_arvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_awready_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_awvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_bready_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_bvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_dbiterr_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_injectdbiterr_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_injectsbiterr_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_rlast_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_rready_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_rvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_sbiterr_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_wlast_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_wready_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_wvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_sbiterr_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_shutdown_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_sleep_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_addrb_UNCONNECTED : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal NLW_U0_dinb_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_douta_UNCONNECTED : STD_LOGIC_VECTOR ( 26 downto 6 );
  signal NLW_U0_doutb_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_rdaddrecc_UNCONNECTED : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal NLW_U0_s_axi_araddr_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_s_axi_arburst_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_U0_s_axi_arid_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_U0_s_axi_arlen_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_U0_s_axi_arsize_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_U0_s_axi_awaddr_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_s_axi_awburst_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_U0_s_axi_awid_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_U0_s_axi_awlen_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_U0_s_axi_awsize_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_U0_s_axi_bid_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_U0_s_axi_bresp_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_U0_s_axi_rdaddrecc_UNCONNECTED : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal NLW_U0_s_axi_rdata_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_s_axi_rid_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_U0_s_axi_rresp_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_U0_s_axi_wdata_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_s_axi_wstrb_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_U0_web_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
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
  attribute C_DEFAULT_DATA of U0 : label is "A5";
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
      addrb(11 downto 0) => NLW_U0_addrb_UNCONNECTED(11 downto 0),
      clka => clka,
      clkb => NLW_U0_clkb_UNCONNECTED,
      dbiterr => NLW_U0_dbiterr_UNCONNECTED,
      deepsleep => NLW_U0_deepsleep_UNCONNECTED,
      dina(31 downto 0) => dina(31 downto 0),
      dinb(31 downto 0) => NLW_U0_dinb_UNCONNECTED(31 downto 0),
      douta(31 downto 27) => douta(31 downto 27),
      douta(26) => NLW_U0_douta_UNCONNECTED(26),
      douta(25 downto 16) => douta(25 downto 16),
      douta(15 downto 6) => NLW_U0_douta_UNCONNECTED(15 downto 6),
      douta(5 downto 0) => douta(5 downto 0),
      doutb(31 downto 0) => NLW_U0_doutb_UNCONNECTED(31 downto 0),
      eccpipece => NLW_U0_eccpipece_UNCONNECTED,
      ena => ena,
      enb => NLW_U0_enb_UNCONNECTED,
      injectdbiterr => NLW_U0_injectdbiterr_UNCONNECTED,
      injectsbiterr => NLW_U0_injectsbiterr_UNCONNECTED,
      pwropt => pwropt,
      pwropt_1 => pwropt_1,
      rdaddrecc(11 downto 0) => NLW_U0_rdaddrecc_UNCONNECTED(11 downto 0),
      regcea => NLW_U0_regcea_UNCONNECTED,
      regceb => NLW_U0_regceb_UNCONNECTED,
      rsta => NLW_U0_rsta_UNCONNECTED,
      rsta_busy => NLW_U0_rsta_busy_UNCONNECTED,
      rstb => NLW_U0_rstb_UNCONNECTED,
      rstb_busy => NLW_U0_rstb_busy_UNCONNECTED,
      s_aclk => NLW_U0_s_aclk_UNCONNECTED,
      s_aresetn => NLW_U0_s_aresetn_UNCONNECTED,
      s_axi_araddr(31 downto 0) => NLW_U0_s_axi_araddr_UNCONNECTED(31 downto 0),
      s_axi_arburst(1 downto 0) => NLW_U0_s_axi_arburst_UNCONNECTED(1 downto 0),
      s_axi_arid(3 downto 0) => NLW_U0_s_axi_arid_UNCONNECTED(3 downto 0),
      s_axi_arlen(7 downto 0) => NLW_U0_s_axi_arlen_UNCONNECTED(7 downto 0),
      s_axi_arready => NLW_U0_s_axi_arready_UNCONNECTED,
      s_axi_arsize(2 downto 0) => NLW_U0_s_axi_arsize_UNCONNECTED(2 downto 0),
      s_axi_arvalid => NLW_U0_s_axi_arvalid_UNCONNECTED,
      s_axi_awaddr(31 downto 0) => NLW_U0_s_axi_awaddr_UNCONNECTED(31 downto 0),
      s_axi_awburst(1 downto 0) => NLW_U0_s_axi_awburst_UNCONNECTED(1 downto 0),
      s_axi_awid(3 downto 0) => NLW_U0_s_axi_awid_UNCONNECTED(3 downto 0),
      s_axi_awlen(7 downto 0) => NLW_U0_s_axi_awlen_UNCONNECTED(7 downto 0),
      s_axi_awready => NLW_U0_s_axi_awready_UNCONNECTED,
      s_axi_awsize(2 downto 0) => NLW_U0_s_axi_awsize_UNCONNECTED(2 downto 0),
      s_axi_awvalid => NLW_U0_s_axi_awvalid_UNCONNECTED,
      s_axi_bid(3 downto 0) => NLW_U0_s_axi_bid_UNCONNECTED(3 downto 0),
      s_axi_bready => NLW_U0_s_axi_bready_UNCONNECTED,
      s_axi_bresp(1 downto 0) => NLW_U0_s_axi_bresp_UNCONNECTED(1 downto 0),
      s_axi_bvalid => NLW_U0_s_axi_bvalid_UNCONNECTED,
      s_axi_dbiterr => NLW_U0_s_axi_dbiterr_UNCONNECTED,
      s_axi_injectdbiterr => NLW_U0_s_axi_injectdbiterr_UNCONNECTED,
      s_axi_injectsbiterr => NLW_U0_s_axi_injectsbiterr_UNCONNECTED,
      s_axi_rdaddrecc(11 downto 0) => NLW_U0_s_axi_rdaddrecc_UNCONNECTED(11 downto 0),
      s_axi_rdata(31 downto 0) => NLW_U0_s_axi_rdata_UNCONNECTED(31 downto 0),
      s_axi_rid(3 downto 0) => NLW_U0_s_axi_rid_UNCONNECTED(3 downto 0),
      s_axi_rlast => NLW_U0_s_axi_rlast_UNCONNECTED,
      s_axi_rready => NLW_U0_s_axi_rready_UNCONNECTED,
      s_axi_rresp(1 downto 0) => NLW_U0_s_axi_rresp_UNCONNECTED(1 downto 0),
      s_axi_rvalid => NLW_U0_s_axi_rvalid_UNCONNECTED,
      s_axi_sbiterr => NLW_U0_s_axi_sbiterr_UNCONNECTED,
      s_axi_wdata(31 downto 0) => NLW_U0_s_axi_wdata_UNCONNECTED(31 downto 0),
      s_axi_wlast => NLW_U0_s_axi_wlast_UNCONNECTED,
      s_axi_wready => NLW_U0_s_axi_wready_UNCONNECTED,
      s_axi_wstrb(0) => NLW_U0_s_axi_wstrb_UNCONNECTED(0),
      s_axi_wvalid => NLW_U0_s_axi_wvalid_UNCONNECTED,
      sbiterr => NLW_U0_sbiterr_UNCONNECTED,
      shutdown => NLW_U0_shutdown_UNCONNECTED,
      sleep => NLW_U0_sleep_UNCONNECTED,
      wea(0) => wea(0),
      web(0) => NLW_U0_web_UNCONNECTED(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity Memory is
  port (
    D : out STD_LOGIC_VECTOR ( 20 downto 0 );
    clk_IBUF_BUFG : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 11 downto 0 );
    pwropt : in STD_LOGIC;
    pwropt_1 : in STD_LOGIC
  );
end Memory;

architecture STRUCTURE of Memory is
  signal NLW_instmemory_douta_UNCONNECTED : STD_LOGIC_VECTOR ( 26 downto 6 );
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
      douta(31 downto 27) => D(20 downto 16),
      douta(26) => NLW_instmemory_douta_UNCONNECTED(26),
      douta(25 downto 16) => D(15 downto 6),
      douta(15 downto 6) => NLW_instmemory_douta_UNCONNECTED(15 downto 6),
      douta(5 downto 0) => D(5 downto 0),
      ena => '1',
      pwropt => pwropt,
      pwropt_1 => pwropt_1,
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
  attribute \DesignAttr:ENABLE_AIE_NETLIST_VIEW\ : boolean;
  attribute \DesignAttr:ENABLE_AIE_NETLIST_VIEW\ of CPU : entity is std.standard.true;
  attribute \DesignAttr:ENABLE_NOC_NETLIST_VIEW\ : boolean;
  attribute \DesignAttr:ENABLE_NOC_NETLIST_VIEW\ of CPU : entity is std.standard.true;
  attribute ECO_CHECKSUM : string;
  attribute ECO_CHECKSUM of CPU : entity is "307bc662";
  attribute POWER_OPT_BRAM_CDC : integer;
  attribute POWER_OPT_BRAM_CDC of CPU : entity is 0;
  attribute POWER_OPT_BRAM_SR_ADDR : integer;
  attribute POWER_OPT_BRAM_SR_ADDR of CPU : entity is 0;
  attribute POWER_OPT_LOOPED_NET_PERCENTAGE : integer;
  attribute POWER_OPT_LOOPED_NET_PERCENTAGE of CPU : entity is 0;
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
  signal \ProgCounter_reg[0]_i_1_n_4\ : STD_LOGIC;
  signal \ProgCounter_reg[0]_i_1_n_5\ : STD_LOGIC;
  signal \ProgCounter_reg[0]_i_1_n_6\ : STD_LOGIC;
  signal \ProgCounter_reg[0]_i_1_n_7\ : STD_LOGIC;
  signal \ProgCounter_reg[4]_i_1_n_0\ : STD_LOGIC;
  signal \ProgCounter_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \ProgCounter_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \ProgCounter_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \ProgCounter_reg[4]_i_1_n_7\ : STD_LOGIC;
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
  signal inst : STD_LOGIC_VECTOR ( 31 downto 16 );
  signal instruction : STD_LOGIC;
  signal \instruction_reg_n_0_[0]\ : STD_LOGIC;
  signal \instruction_reg_n_0_[1]\ : STD_LOGIC;
  signal \instruction_reg_n_0_[2]\ : STD_LOGIC;
  signal \instruction_reg_n_0_[3]\ : STD_LOGIC;
  signal \instruction_reg_n_0_[4]\ : STD_LOGIC;
  signal \instruction_reg_n_0_[5]\ : STD_LOGIC;
  signal led_OBUF : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal p_0_in : STD_LOGIC_VECTOR ( 3 downto 0 );
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
  signal \rgb[5]_i_1_n_0\ : STD_LOGIC;
  signal rgb_OBUF : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal rst_IBUF : STD_LOGIC;
  signal we : STD_LOGIC;
  signal \NLW_ProgCounter_reg[0]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_ProgCounter_reg[4]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_ProgCounter_reg[8]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_onehot_cycle[4]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \FSM_onehot_cycle[5]_i_1\ : label is "soft_lutpair0";
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
  attribute SPLIT_LOADS_ON_BUFG : boolean;
  attribute SPLIT_LOADS_ON_BUFG of clk_IBUF_BUFG_inst : label is std.standard.true;
  attribute SOFT_HLUTNM of \regin[0]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \regin[1]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \regin[2]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \regin[3]_i_2\ : label is "soft_lutpair1";
begin
\FSM_onehot_cycle[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => \FSM_onehot_cycle_reg_n_0_[3]\,
      I1 => inst(24),
      I2 => inst(25),
      O => \FSM_onehot_cycle[4]_i_1_n_0\
    );
\FSM_onehot_cycle[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FEAA"
    )
        port map (
      I0 => \FSM_onehot_cycle_reg_n_0_[4]\,
      I1 => inst(25),
      I2 => inst(24),
      I3 => \FSM_onehot_cycle_reg_n_0_[3]\,
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
      CO(2 downto 0) => \NLW_ProgCounter_reg[0]_i_1_CO_UNCONNECTED\(2 downto 0),
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
      CO(2 downto 0) => \NLW_ProgCounter_reg[4]_i_1_CO_UNCONNECTED\(2 downto 0),
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
      CO(3 downto 0) => \NLW_ProgCounter_reg[8]_i_1_CO_UNCONNECTED\(3 downto 0),
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
\instruction_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(4),
      Q => \instruction_reg_n_0_[4]\,
      R => rst_IBUF
    );
\instruction_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => instruction,
      D => douta(5),
      Q => \instruction_reg_n_0_[5]\,
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
      D(20 downto 16) => douta(31 downto 27),
      D(15 downto 6) => douta(25 downto 16),
      D(5 downto 0) => douta(5 downto 0),
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
      clk_IBUF_BUFG => clk_IBUF_BUFG,
      pwropt => addra,
      pwropt_1 => rst_IBUF
    );
reg1: entity work.Registers
     port map (
      Q(3) => \regin_reg_n_0_[3]\,
      Q(2) => \regin_reg_n_0_[2]\,
      Q(1) => \regin_reg_n_0_[1]\,
      Q(0) => \regin_reg_n_0_[0]\,
      clk_IBUF_BUFG => clk_IBUF_BUFG,
      regout(3 downto 0) => regout(3 downto 0),
      \regout_reg[0]_0\(3) => \regnum_reg_n_0_[3]\,
      \regout_reg[0]_0\(2) => \regnum_reg_n_0_[2]\,
      \regout_reg[0]_0\(1) => \regnum_reg_n_0_[1]\,
      \regout_reg[0]_0\(0) => \regnum_reg_n_0_[0]\,
      we => we
    );
\regin[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E2"
    )
        port map (
      I0 => \regtmp_reg_n_0_[0]\,
      I1 => inst(24),
      I2 => \instruction_reg_n_0_[0]\,
      O => p_0_in(0)
    );
\regin[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E2"
    )
        port map (
      I0 => \regtmp_reg_n_0_[1]\,
      I1 => inst(24),
      I2 => \instruction_reg_n_0_[1]\,
      O => p_0_in(1)
    );
\regin[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E2"
    )
        port map (
      I0 => \regtmp_reg_n_0_[2]\,
      I1 => inst(24),
      I2 => \instruction_reg_n_0_[2]\,
      O => p_0_in(2)
    );
\regin[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => inst(29),
      I1 => inst(30),
      I2 => inst(25),
      I3 => \regin[3]_i_3_n_0\,
      O => regin(3)
    );
\regin[3]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E2"
    )
        port map (
      I0 => \regtmp_reg_n_0_[3]\,
      I1 => inst(24),
      I2 => \instruction_reg_n_0_[3]\,
      O => p_0_in(3)
    );
\regin[3]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFDF"
    )
        port map (
      I0 => inst(27),
      I1 => inst(28),
      I2 => ProgCounter,
      I3 => inst(31),
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
      I0 => inst(16),
      I1 => \FSM_onehot_cycle_reg_n_0_[3]\,
      I2 => inst(20),
      I3 => ProgCounter,
      O => regnum(0)
    );
\regnum[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => inst(17),
      I1 => \FSM_onehot_cycle_reg_n_0_[3]\,
      I2 => inst(21),
      I3 => ProgCounter,
      O => regnum(1)
    );
\regnum[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => inst(18),
      I1 => \FSM_onehot_cycle_reg_n_0_[3]\,
      I2 => inst(22),
      I3 => ProgCounter,
      O => regnum(2)
    );
\regnum[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000100FF00010001"
    )
        port map (
      I0 => \regin[3]_i_3_n_0\,
      I1 => inst(30),
      I2 => inst(29),
      I3 => inst(25),
      I4 => inst(24),
      I5 => \FSM_onehot_cycle_reg_n_0_[3]\,
      O => \regnum[3]_i_1_n_0\
    );
\regnum[3]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => inst(19),
      I1 => \FSM_onehot_cycle_reg_n_0_[3]\,
      I2 => inst(23),
      I3 => ProgCounter,
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
      INIT => X"1111111111111110"
    )
        port map (
      I0 => inst(24),
      I1 => inst(25),
      I2 => ProgCounter,
      I3 => \FSM_onehot_cycle_reg_n_0_[7]\,
      I4 => \FSM_onehot_cycle_reg_n_0_[4]\,
      I5 => \FSM_onehot_cycle_reg_n_0_[5]\,
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
\rgb[5]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => instruction,
      I1 => rst_IBUF,
      O => \rgb[5]_i_1_n_0\
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
      CE => \rgb[5]_i_1_n_0\,
      D => \instruction_reg_n_0_[0]\,
      Q => rgb_OBUF(0),
      R => '0'
    );
\rgb_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \rgb[5]_i_1_n_0\,
      D => \instruction_reg_n_0_[1]\,
      Q => rgb_OBUF(1),
      R => '0'
    );
\rgb_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \rgb[5]_i_1_n_0\,
      D => \instruction_reg_n_0_[2]\,
      Q => rgb_OBUF(2),
      R => '0'
    );
\rgb_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \rgb[5]_i_1_n_0\,
      D => \instruction_reg_n_0_[3]\,
      Q => rgb_OBUF(3),
      R => '0'
    );
\rgb_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \rgb[5]_i_1_n_0\,
      D => \instruction_reg_n_0_[4]\,
      Q => rgb_OBUF(4),
      R => '0'
    );
\rgb_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => \rgb[5]_i_1_n_0\,
      D => \instruction_reg_n_0_[5]\,
      Q => rgb_OBUF(5),
      R => '0'
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
