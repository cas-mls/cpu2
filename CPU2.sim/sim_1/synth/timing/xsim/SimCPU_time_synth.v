// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Wed Dec 13 19:05:57 2023
// Host        : AlienCraig running 64-bit major release  (build 9200)
// Command     : write_verilog -mode timesim -nolib -sdf_anno true -force -file {D:/Users/Craig/Documents/000
//               ArtyS7/CPU2/CPU2.sim/sim_1/synth/timing/xsim/SimCPU_time_synth.v}
// Design      : CPU
// Purpose     : This verilog netlist is a timing simulation representation of the design and should not be modified or
//               synthesized. Please ensure that this netlist is used with the corresponding SDF file.
// Device      : xc7s50csga324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps
`define XIL_TIMING

module RAM32X1S_UNIQ_BASE_
   (O,
    A0,
    A1,
    A2,
    A3,
    A4,
    D,
    WCLK,
    WE);
  output O;
  input A0;
  input A1;
  input A2;
  input A3;
  input A4;
  input D;
  input WCLK;
  input WE;

  wire A0;
  wire A1;
  wire A2;
  wire A3;
  wire A4;
  wire D;
  wire O;
  wire WCLK;
  wire WE;

  RAMS32 #(
    .INIT(32'h00000000),
    .IS_CLK_INVERTED(1'b0)) 
    SP
       (.ADR0(A0),
        .ADR1(A1),
        .ADR2(A2),
        .ADR3(A3),
        .ADR4(A4),
        .CLK(WCLK),
        .I(D),
        .O(O),
        .WE(WE));
endmodule

module RAM32X1S_HD19
   (O,
    A0,
    A1,
    A2,
    A3,
    A4,
    D,
    WCLK,
    WE);
  output O;
  input A0;
  input A1;
  input A2;
  input A3;
  input A4;
  input D;
  input WCLK;
  input WE;

  wire A0;
  wire A1;
  wire A2;
  wire A3;
  wire A4;
  wire D;
  wire O;
  wire WCLK;
  wire WE;

  RAMS32 #(
    .INIT(32'h00000000),
    .IS_CLK_INVERTED(1'b0)) 
    SP
       (.ADR0(A0),
        .ADR1(A1),
        .ADR2(A2),
        .ADR3(A3),
        .ADR4(A4),
        .CLK(WCLK),
        .I(D),
        .O(O),
        .WE(WE));
endmodule

module RAM32X1S_HD20
   (O,
    A0,
    A1,
    A2,
    A3,
    A4,
    D,
    WCLK,
    WE);
  output O;
  input A0;
  input A1;
  input A2;
  input A3;
  input A4;
  input D;
  input WCLK;
  input WE;

  wire A0;
  wire A1;
  wire A2;
  wire A3;
  wire A4;
  wire D;
  wire O;
  wire WCLK;
  wire WE;

  RAMS32 #(
    .INIT(32'h00000000),
    .IS_CLK_INVERTED(1'b0)) 
    SP
       (.ADR0(A0),
        .ADR1(A1),
        .ADR2(A2),
        .ADR3(A3),
        .ADR4(A4),
        .CLK(WCLK),
        .I(D),
        .O(O),
        .WE(WE));
endmodule

module RAM32X1S_HD21
   (O,
    A0,
    A1,
    A2,
    A3,
    A4,
    D,
    WCLK,
    WE);
  output O;
  input A0;
  input A1;
  input A2;
  input A3;
  input A4;
  input D;
  input WCLK;
  input WE;

  wire A0;
  wire A1;
  wire A2;
  wire A3;
  wire A4;
  wire D;
  wire O;
  wire WCLK;
  wire WE;

  RAMS32 #(
    .INIT(32'h00000000),
    .IS_CLK_INVERTED(1'b0)) 
    SP
       (.ADR0(A0),
        .ADR1(A1),
        .ADR2(A2),
        .ADR3(A3),
        .ADR4(A4),
        .CLK(WCLK),
        .I(D),
        .O(O),
        .WE(WE));
endmodule

(* NotValidForBitStream *)
module CPU
   (rst,
    clk,
    led,
    rgb);
  input rst;
  input clk;
  output [3:0]led;
  output [5:0]rgb;

  wire \FSM_onehot_cycle[4]_i_1_n_0 ;
  wire \FSM_onehot_cycle[5]_i_1_n_0 ;
  wire \FSM_onehot_cycle_reg_n_0_[1] ;
  wire \FSM_onehot_cycle_reg_n_0_[3] ;
  wire \FSM_onehot_cycle_reg_n_0_[4] ;
  wire \FSM_onehot_cycle_reg_n_0_[5] ;
  wire \FSM_onehot_cycle_reg_n_0_[7] ;
  wire ProgCounter;
  wire \ProgCounter[0]_i_2_n_0 ;
  wire [11:0]ProgCounter_reg;
  wire \ProgCounter_reg[0]_i_1_n_0 ;
  wire \ProgCounter_reg[0]_i_1_n_1 ;
  wire \ProgCounter_reg[0]_i_1_n_2 ;
  wire \ProgCounter_reg[0]_i_1_n_3 ;
  wire \ProgCounter_reg[0]_i_1_n_4 ;
  wire \ProgCounter_reg[0]_i_1_n_5 ;
  wire \ProgCounter_reg[0]_i_1_n_6 ;
  wire \ProgCounter_reg[0]_i_1_n_7 ;
  wire \ProgCounter_reg[4]_i_1_n_0 ;
  wire \ProgCounter_reg[4]_i_1_n_1 ;
  wire \ProgCounter_reg[4]_i_1_n_2 ;
  wire \ProgCounter_reg[4]_i_1_n_3 ;
  wire \ProgCounter_reg[4]_i_1_n_4 ;
  wire \ProgCounter_reg[4]_i_1_n_5 ;
  wire \ProgCounter_reg[4]_i_1_n_6 ;
  wire \ProgCounter_reg[4]_i_1_n_7 ;
  wire \ProgCounter_reg[8]_i_1_n_1 ;
  wire \ProgCounter_reg[8]_i_1_n_2 ;
  wire \ProgCounter_reg[8]_i_1_n_3 ;
  wire \ProgCounter_reg[8]_i_1_n_4 ;
  wire \ProgCounter_reg[8]_i_1_n_5 ;
  wire \ProgCounter_reg[8]_i_1_n_6 ;
  wire \ProgCounter_reg[8]_i_1_n_7 ;
  wire addra;
  wire \addra_reg_n_0_[0] ;
  wire \addra_reg_n_0_[10] ;
  wire \addra_reg_n_0_[11] ;
  wire \addra_reg_n_0_[1] ;
  wire \addra_reg_n_0_[2] ;
  wire \addra_reg_n_0_[3] ;
  wire \addra_reg_n_0_[4] ;
  wire \addra_reg_n_0_[5] ;
  wire \addra_reg_n_0_[6] ;
  wire \addra_reg_n_0_[7] ;
  wire \addra_reg_n_0_[8] ;
  wire \addra_reg_n_0_[9] ;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire [31:0]douta;
  wire ena;
  wire highlow;
  wire [31:16]inst;
  wire instruction;
  wire \instruction_reg_n_0_[0] ;
  wire \instruction_reg_n_0_[1] ;
  wire \instruction_reg_n_0_[2] ;
  wire \instruction_reg_n_0_[3] ;
  wire [3:0]led;
  wire [3:0]led_OBUF;
  wire [3:0]p_0_in;
  wire regena_i_1_n_0;
  wire regena_i_2_n_0;
  wire [3:3]regin;
  wire \regin[3]_i_3_n_0 ;
  wire \regin_reg_n_0_[0] ;
  wire \regin_reg_n_0_[1] ;
  wire \regin_reg_n_0_[2] ;
  wire \regin_reg_n_0_[3] ;
  wire [3:0]regnum;
  wire \regnum[3]_i_1_n_0 ;
  wire \regnum_reg_n_0_[0] ;
  wire \regnum_reg_n_0_[1] ;
  wire \regnum_reg_n_0_[2] ;
  wire \regnum_reg_n_0_[3] ;
  wire [3:0]regout;
  wire regtmp;
  wire \regtmp_reg_n_0_[0] ;
  wire \regtmp_reg_n_0_[1] ;
  wire \regtmp_reg_n_0_[2] ;
  wire \regtmp_reg_n_0_[3] ;
  wire [5:0]rgb;
  wire [5:0]rgb_OBUF;
  wire rst;
  wire rst_IBUF;
  wire we;
  wire [3:3]\NLW_ProgCounter_reg[8]_i_1_CO_UNCONNECTED ;

initial begin
 $sdf_annotate("SimCPU_time_synth.sdf",,,,"tool_control");
end
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \FSM_onehot_cycle[4]_i_1 
       (.I0(\FSM_onehot_cycle_reg_n_0_[3] ),
        .I1(inst[25]),
        .I2(inst[24]),
        .O(\FSM_onehot_cycle[4]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFFA8)) 
    \FSM_onehot_cycle[5]_i_1 
       (.I0(\FSM_onehot_cycle_reg_n_0_[3] ),
        .I1(inst[24]),
        .I2(inst[25]),
        .I3(\FSM_onehot_cycle_reg_n_0_[4] ),
        .O(\FSM_onehot_cycle[5]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_cycle_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\FSM_onehot_cycle_reg_n_0_[7] ),
        .Q(addra),
        .S(rst_IBUF));
  (* FSM_ENCODED_STATES = "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_cycle_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(addra),
        .Q(\FSM_onehot_cycle_reg_n_0_[1] ),
        .R(rst_IBUF));
  (* FSM_ENCODED_STATES = "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_cycle_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\FSM_onehot_cycle_reg_n_0_[1] ),
        .Q(instruction),
        .R(rst_IBUF));
  (* FSM_ENCODED_STATES = "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_cycle_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(instruction),
        .Q(\FSM_onehot_cycle_reg_n_0_[3] ),
        .R(rst_IBUF));
  (* FSM_ENCODED_STATES = "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_cycle_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\FSM_onehot_cycle[4]_i_1_n_0 ),
        .Q(\FSM_onehot_cycle_reg_n_0_[4] ),
        .R(rst_IBUF));
  (* FSM_ENCODED_STATES = "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_cycle_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\FSM_onehot_cycle[5]_i_1_n_0 ),
        .Q(\FSM_onehot_cycle_reg_n_0_[5] ),
        .R(rst_IBUF));
  (* FSM_ENCODED_STATES = "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_cycle_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(\FSM_onehot_cycle_reg_n_0_[5] ),
        .Q(ProgCounter),
        .R(rst_IBUF));
  (* FSM_ENCODED_STATES = "prefetch:00000001,waits:00000010,fetch:00000100,decodes:00001000,execute:01000000,memw:10000000,memr:00100000,memrwait:00010000" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_cycle_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(ProgCounter),
        .Q(\FSM_onehot_cycle_reg_n_0_[7] ),
        .R(rst_IBUF));
  LUT1 #(
    .INIT(2'h1)) 
    \ProgCounter[0]_i_2 
       (.I0(ProgCounter_reg[0]),
        .O(\ProgCounter[0]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ProgCounter_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(ProgCounter),
        .D(\ProgCounter_reg[0]_i_1_n_7 ),
        .Q(ProgCounter_reg[0]),
        .R(rst_IBUF));
  (* ADDER_THRESHOLD = "11" *) 
  CARRY4 \ProgCounter_reg[0]_i_1 
       (.CI(1'b0),
        .CO({\ProgCounter_reg[0]_i_1_n_0 ,\ProgCounter_reg[0]_i_1_n_1 ,\ProgCounter_reg[0]_i_1_n_2 ,\ProgCounter_reg[0]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\ProgCounter_reg[0]_i_1_n_4 ,\ProgCounter_reg[0]_i_1_n_5 ,\ProgCounter_reg[0]_i_1_n_6 ,\ProgCounter_reg[0]_i_1_n_7 }),
        .S({ProgCounter_reg[3:1],\ProgCounter[0]_i_2_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \ProgCounter_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(ProgCounter),
        .D(\ProgCounter_reg[8]_i_1_n_5 ),
        .Q(ProgCounter_reg[10]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ProgCounter_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(ProgCounter),
        .D(\ProgCounter_reg[8]_i_1_n_4 ),
        .Q(ProgCounter_reg[11]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ProgCounter_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(ProgCounter),
        .D(\ProgCounter_reg[0]_i_1_n_6 ),
        .Q(ProgCounter_reg[1]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ProgCounter_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(ProgCounter),
        .D(\ProgCounter_reg[0]_i_1_n_5 ),
        .Q(ProgCounter_reg[2]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ProgCounter_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(ProgCounter),
        .D(\ProgCounter_reg[0]_i_1_n_4 ),
        .Q(ProgCounter_reg[3]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ProgCounter_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(ProgCounter),
        .D(\ProgCounter_reg[4]_i_1_n_7 ),
        .Q(ProgCounter_reg[4]),
        .R(rst_IBUF));
  (* ADDER_THRESHOLD = "11" *) 
  CARRY4 \ProgCounter_reg[4]_i_1 
       (.CI(\ProgCounter_reg[0]_i_1_n_0 ),
        .CO({\ProgCounter_reg[4]_i_1_n_0 ,\ProgCounter_reg[4]_i_1_n_1 ,\ProgCounter_reg[4]_i_1_n_2 ,\ProgCounter_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\ProgCounter_reg[4]_i_1_n_4 ,\ProgCounter_reg[4]_i_1_n_5 ,\ProgCounter_reg[4]_i_1_n_6 ,\ProgCounter_reg[4]_i_1_n_7 }),
        .S(ProgCounter_reg[7:4]));
  FDRE #(
    .INIT(1'b0)) 
    \ProgCounter_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(ProgCounter),
        .D(\ProgCounter_reg[4]_i_1_n_6 ),
        .Q(ProgCounter_reg[5]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ProgCounter_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(ProgCounter),
        .D(\ProgCounter_reg[4]_i_1_n_5 ),
        .Q(ProgCounter_reg[6]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ProgCounter_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(ProgCounter),
        .D(\ProgCounter_reg[4]_i_1_n_4 ),
        .Q(ProgCounter_reg[7]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \ProgCounter_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(ProgCounter),
        .D(\ProgCounter_reg[8]_i_1_n_7 ),
        .Q(ProgCounter_reg[8]),
        .R(rst_IBUF));
  (* ADDER_THRESHOLD = "11" *) 
  CARRY4 \ProgCounter_reg[8]_i_1 
       (.CI(\ProgCounter_reg[4]_i_1_n_0 ),
        .CO({\NLW_ProgCounter_reg[8]_i_1_CO_UNCONNECTED [3],\ProgCounter_reg[8]_i_1_n_1 ,\ProgCounter_reg[8]_i_1_n_2 ,\ProgCounter_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\ProgCounter_reg[8]_i_1_n_4 ,\ProgCounter_reg[8]_i_1_n_5 ,\ProgCounter_reg[8]_i_1_n_6 ,\ProgCounter_reg[8]_i_1_n_7 }),
        .S(ProgCounter_reg[11:8]));
  FDRE #(
    .INIT(1'b0)) 
    \ProgCounter_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(ProgCounter),
        .D(\ProgCounter_reg[8]_i_1_n_6 ),
        .Q(ProgCounter_reg[9]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \addra_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(addra),
        .D(ProgCounter_reg[0]),
        .Q(\addra_reg_n_0_[0] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \addra_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(addra),
        .D(ProgCounter_reg[10]),
        .Q(\addra_reg_n_0_[10] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \addra_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(addra),
        .D(ProgCounter_reg[11]),
        .Q(\addra_reg_n_0_[11] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \addra_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(addra),
        .D(ProgCounter_reg[1]),
        .Q(\addra_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \addra_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(addra),
        .D(ProgCounter_reg[2]),
        .Q(\addra_reg_n_0_[2] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \addra_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(addra),
        .D(ProgCounter_reg[3]),
        .Q(\addra_reg_n_0_[3] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \addra_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(addra),
        .D(ProgCounter_reg[4]),
        .Q(\addra_reg_n_0_[4] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \addra_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(addra),
        .D(ProgCounter_reg[5]),
        .Q(\addra_reg_n_0_[5] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \addra_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(addra),
        .D(ProgCounter_reg[6]),
        .Q(\addra_reg_n_0_[6] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \addra_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(addra),
        .D(ProgCounter_reg[7]),
        .Q(\addra_reg_n_0_[7] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \addra_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(addra),
        .D(ProgCounter_reg[8]),
        .Q(\addra_reg_n_0_[8] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \addra_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(addra),
        .D(ProgCounter_reg[9]),
        .Q(\addra_reg_n_0_[9] ),
        .R(rst_IBUF));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[0]),
        .Q(\instruction_reg_n_0_[0] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[16]),
        .Q(inst[16]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[17]),
        .Q(inst[17]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[18]),
        .Q(inst[18]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[19]),
        .Q(inst[19]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[1]),
        .Q(\instruction_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[20]),
        .Q(inst[20]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[21]),
        .Q(inst[21]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[22]),
        .Q(inst[22]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[23]),
        .Q(inst[23]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[24]),
        .Q(inst[24]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[25]),
        .Q(inst[25]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[26]),
        .Q(highlow),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[27]),
        .Q(inst[27]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[28]),
        .Q(inst[28]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[29]),
        .Q(inst[29]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[2]),
        .Q(\instruction_reg_n_0_[2] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[30]),
        .Q(inst[30]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[31]),
        .Q(inst[31]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \instruction_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(douta[3]),
        .Q(\instruction_reg_n_0_[3] ),
        .R(rst_IBUF));
  OBUF \led_OBUF[0]_inst 
       (.I(led_OBUF[0]),
        .O(led[0]));
  OBUF \led_OBUF[1]_inst 
       (.I(led_OBUF[1]),
        .O(led[1]));
  OBUF \led_OBUF[2]_inst 
       (.I(led_OBUF[2]),
        .O(led[2]));
  OBUF \led_OBUF[3]_inst 
       (.I(led_OBUF[3]),
        .O(led[3]));
  FDSE #(
    .INIT(1'b1)) 
    \led_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(regtmp),
        .D(\regtmp_reg_n_0_[0] ),
        .Q(led_OBUF[0]),
        .S(rst_IBUF));
  FDSE #(
    .INIT(1'b1)) 
    \led_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(regtmp),
        .D(\regtmp_reg_n_0_[1] ),
        .Q(led_OBUF[1]),
        .S(rst_IBUF));
  FDSE #(
    .INIT(1'b1)) 
    \led_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(regtmp),
        .D(\regtmp_reg_n_0_[2] ),
        .Q(led_OBUF[2]),
        .S(rst_IBUF));
  FDSE #(
    .INIT(1'b1)) 
    \led_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(regtmp),
        .D(\regtmp_reg_n_0_[3] ),
        .Q(led_OBUF[3]),
        .S(rst_IBUF));
  Memory memory2
       (.D({douta[31:16],douta[3:0]}),
        .Q({\addra_reg_n_0_[11] ,\addra_reg_n_0_[10] ,\addra_reg_n_0_[9] ,\addra_reg_n_0_[8] ,\addra_reg_n_0_[7] ,\addra_reg_n_0_[6] ,\addra_reg_n_0_[5] ,\addra_reg_n_0_[4] ,\addra_reg_n_0_[3] ,\addra_reg_n_0_[2] ,\addra_reg_n_0_[1] ,\addra_reg_n_0_[0] }),
        .clk_IBUF_BUFG(clk_IBUF_BUFG));
  Registers reg1
       (.Q({\regin_reg_n_0_[3] ,\regin_reg_n_0_[2] ,\regin_reg_n_0_[1] ,\regin_reg_n_0_[0] }),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .ena(ena),
        .regout(regout),
        .\regout_reg[0]_0 ({\regnum_reg_n_0_[3] ,\regnum_reg_n_0_[2] ,\regnum_reg_n_0_[1] ,\regnum_reg_n_0_[0] }),
        .we(we));
  LUT5 #(
    .INIT(32'hEEEFEEE0)) 
    regena_i_1
       (.I0(ProgCounter),
        .I1(\FSM_onehot_cycle_reg_n_0_[3] ),
        .I2(regena_i_2_n_0),
        .I3(addra),
        .I4(ena),
        .O(regena_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h808F8080)) 
    regena_i_2
       (.I0(\regin[3]_i_3_n_0 ),
        .I1(ProgCounter),
        .I2(inst[24]),
        .I3(inst[25]),
        .I4(\FSM_onehot_cycle_reg_n_0_[3] ),
        .O(regena_i_2_n_0));
  FDRE #(
    .INIT(1'b0)) 
    regena_reg
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(regena_i_1_n_0),
        .Q(ena),
        .R(rst_IBUF));
  LUT4 #(
    .INIT(16'hABA8)) 
    \regin[0]_i_1 
       (.I0(\instruction_reg_n_0_[0] ),
        .I1(inst[24]),
        .I2(inst[25]),
        .I3(\regtmp_reg_n_0_[0] ),
        .O(p_0_in[0]));
  LUT4 #(
    .INIT(16'hABA8)) 
    \regin[1]_i_1 
       (.I0(\instruction_reg_n_0_[1] ),
        .I1(inst[24]),
        .I2(inst[25]),
        .I3(\regtmp_reg_n_0_[1] ),
        .O(p_0_in[1]));
  LUT4 #(
    .INIT(16'hABA8)) 
    \regin[2]_i_1 
       (.I0(\instruction_reg_n_0_[2] ),
        .I1(inst[24]),
        .I2(inst[25]),
        .I3(\regtmp_reg_n_0_[2] ),
        .O(p_0_in[2]));
  LUT4 #(
    .INIT(16'h0888)) 
    \regin[3]_i_1 
       (.I0(\regin[3]_i_3_n_0 ),
        .I1(ProgCounter),
        .I2(highlow),
        .I3(inst[24]),
        .O(regin));
  LUT4 #(
    .INIT(16'hABA8)) 
    \regin[3]_i_2 
       (.I0(\instruction_reg_n_0_[3] ),
        .I1(inst[24]),
        .I2(inst[25]),
        .I3(\regtmp_reg_n_0_[3] ),
        .O(p_0_in[3]));
  LUT6 #(
    .INIT(64'h0000000000000100)) 
    \regin[3]_i_3 
       (.I0(inst[29]),
        .I1(inst[30]),
        .I2(inst[28]),
        .I3(inst[27]),
        .I4(inst[25]),
        .I5(inst[31]),
        .O(\regin[3]_i_3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \regin_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(regin),
        .D(p_0_in[0]),
        .Q(\regin_reg_n_0_[0] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \regin_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(regin),
        .D(p_0_in[1]),
        .Q(\regin_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \regin_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(regin),
        .D(p_0_in[2]),
        .Q(\regin_reg_n_0_[2] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \regin_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(regin),
        .D(p_0_in[3]),
        .Q(\regin_reg_n_0_[3] ),
        .R(rst_IBUF));
  LUT4 #(
    .INIT(16'hF888)) 
    \regnum[0]_i_1 
       (.I0(inst[20]),
        .I1(ProgCounter),
        .I2(inst[16]),
        .I3(\FSM_onehot_cycle_reg_n_0_[3] ),
        .O(regnum[0]));
  LUT4 #(
    .INIT(16'hF888)) 
    \regnum[1]_i_1 
       (.I0(inst[21]),
        .I1(ProgCounter),
        .I2(inst[17]),
        .I3(\FSM_onehot_cycle_reg_n_0_[3] ),
        .O(regnum[1]));
  LUT4 #(
    .INIT(16'hF888)) 
    \regnum[2]_i_1 
       (.I0(inst[22]),
        .I1(ProgCounter),
        .I2(inst[18]),
        .I3(\FSM_onehot_cycle_reg_n_0_[3] ),
        .O(regnum[2]));
  LUT5 #(
    .INIT(32'h888808F8)) 
    \regnum[3]_i_1 
       (.I0(\regin[3]_i_3_n_0 ),
        .I1(ProgCounter),
        .I2(\FSM_onehot_cycle_reg_n_0_[3] ),
        .I3(inst[25]),
        .I4(inst[24]),
        .O(\regnum[3]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \regnum[3]_i_2 
       (.I0(inst[23]),
        .I1(ProgCounter),
        .I2(inst[19]),
        .I3(\FSM_onehot_cycle_reg_n_0_[3] ),
        .O(regnum[3]));
  FDRE #(
    .INIT(1'b0)) 
    \regnum_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\regnum[3]_i_1_n_0 ),
        .D(regnum[0]),
        .Q(\regnum_reg_n_0_[0] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \regnum_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\regnum[3]_i_1_n_0 ),
        .D(regnum[1]),
        .Q(\regnum_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \regnum_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\regnum[3]_i_1_n_0 ),
        .D(regnum[2]),
        .Q(\regnum_reg_n_0_[2] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \regnum_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\regnum[3]_i_1_n_0 ),
        .D(regnum[3]),
        .Q(\regnum_reg_n_0_[3] ),
        .R(rst_IBUF));
  LUT6 #(
    .INIT(64'h000000FF000000FE)) 
    \regtmp[3]_i_1 
       (.I0(ProgCounter),
        .I1(\FSM_onehot_cycle_reg_n_0_[4] ),
        .I2(\FSM_onehot_cycle_reg_n_0_[5] ),
        .I3(inst[25]),
        .I4(inst[24]),
        .I5(\FSM_onehot_cycle_reg_n_0_[7] ),
        .O(regtmp));
  FDRE #(
    .INIT(1'b0)) 
    \regtmp_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(regtmp),
        .D(regout[0]),
        .Q(\regtmp_reg_n_0_[0] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \regtmp_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(regtmp),
        .D(regout[1]),
        .Q(\regtmp_reg_n_0_[1] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \regtmp_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(regtmp),
        .D(regout[2]),
        .Q(\regtmp_reg_n_0_[2] ),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \regtmp_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(regtmp),
        .D(regout[3]),
        .Q(\regtmp_reg_n_0_[3] ),
        .R(rst_IBUF));
  OBUF \rgb_OBUF[0]_inst 
       (.I(rgb_OBUF[0]),
        .O(rgb[0]));
  OBUF \rgb_OBUF[1]_inst 
       (.I(rgb_OBUF[1]),
        .O(rgb[1]));
  OBUF \rgb_OBUF[2]_inst 
       (.I(rgb_OBUF[2]),
        .O(rgb[2]));
  OBUF \rgb_OBUF[3]_inst 
       (.I(rgb_OBUF[3]),
        .O(rgb[3]));
  OBUF \rgb_OBUF[4]_inst 
       (.I(rgb_OBUF[4]),
        .O(rgb[4]));
  OBUF \rgb_OBUF[5]_inst 
       (.I(rgb_OBUF[5]),
        .O(rgb[5]));
  FDRE #(
    .INIT(1'b0)) 
    \rgb_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(inst[27]),
        .Q(rgb_OBUF[0]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \rgb_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(inst[28]),
        .Q(rgb_OBUF[1]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \rgb_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(inst[29]),
        .Q(rgb_OBUF[2]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \rgb_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(inst[30]),
        .Q(rgb_OBUF[3]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \rgb_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(inst[31]),
        .Q(rgb_OBUF[4]),
        .R(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    \rgb_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(instruction),
        .D(inst[24]),
        .Q(rgb_OBUF[5]),
        .R(rst_IBUF));
  IBUF rst_IBUF_inst
       (.I(rst),
        .O(rst_IBUF));
  FDRE #(
    .INIT(1'b0)) 
    we_reg
       (.C(clk_IBUF_BUFG),
        .CE(\regnum[3]_i_1_n_0 ),
        .D(ProgCounter),
        .Q(we),
        .R(rst_IBUF));
endmodule

module Memory
   (D,
    clk_IBUF_BUFG,
    Q);
  output [19:0]D;
  input clk_IBUF_BUFG;
  input [11:0]Q;

  wire [19:0]D;
  wire [11:0]Q;
  wire clk_IBUF_BUFG;
  wire [15:4]douta;

  (* IMPORTED_FROM = "d:/Users/Craig/Documents/000 ArtyS7/CPU2/CPU2.gen/sources_1/ip/cpumemory/cpumemory.dcp" *) 
  (* IMPORTED_TYPE = "CHECKPOINT" *) 
  (* IS_IMPORTED *) 
  (* syn_black_box = "TRUE" *) 
  (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
  cpumemory instmemory
       (.addra(Q),
        .clka(clk_IBUF_BUFG),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta({D[19:4],douta,D[3:0]}),
        .ena(1'b1),
        .wea(1'b0));
endmodule

module Registers
   (regout,
    clk_IBUF_BUFG,
    Q,
    \regout_reg[0]_0 ,
    ena,
    we);
  output [3:0]regout;
  input clk_IBUF_BUFG;
  input [3:0]Q;
  input [3:0]\regout_reg[0]_0 ;
  input ena;
  input we;

  wire [3:0]Q;
  wire clk_IBUF_BUFG;
  wire ena;
  wire p_0_in__0;
  wire p_0_out;
  wire [3:0]p_1_out;
  wire [3:0]regout;
  wire [3:0]\regout_reg[0]_0 ;
  wire we;

  (* INIT = "32'h00000000" *) 
  (* RTL_RAM_BITS = "512" *) 
  (* RTL_RAM_NAME = "reg1/regist_reg" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "15" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "0" *) 
  RAM32X1S_UNIQ_BASE_ regist_reg_0_15_0_0
       (.A0(\regout_reg[0]_0 [0]),
        .A1(\regout_reg[0]_0 [1]),
        .A2(\regout_reg[0]_0 [2]),
        .A3(\regout_reg[0]_0 [3]),
        .A4(1'b0),
        .D(Q[0]),
        .O(p_1_out[0]),
        .WCLK(clk_IBUF_BUFG),
        .WE(p_0_in__0));
  LUT2 #(
    .INIT(4'h8)) 
    regist_reg_0_15_0_0_i_1
       (.I0(we),
        .I1(ena),
        .O(p_0_in__0));
  (* INIT = "32'h00000000" *) 
  (* RTL_RAM_BITS = "512" *) 
  (* RTL_RAM_NAME = "reg1/regist_reg" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "15" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "1" *) 
  (* ram_slice_end = "1" *) 
  RAM32X1S_HD19 regist_reg_0_15_1_1
       (.A0(\regout_reg[0]_0 [0]),
        .A1(\regout_reg[0]_0 [1]),
        .A2(\regout_reg[0]_0 [2]),
        .A3(\regout_reg[0]_0 [3]),
        .A4(1'b0),
        .D(Q[1]),
        .O(p_1_out[1]),
        .WCLK(clk_IBUF_BUFG),
        .WE(p_0_in__0));
  (* INIT = "32'h00000000" *) 
  (* RTL_RAM_BITS = "512" *) 
  (* RTL_RAM_NAME = "reg1/regist_reg" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "15" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "2" *) 
  (* ram_slice_end = "2" *) 
  RAM32X1S_HD20 regist_reg_0_15_2_2
       (.A0(\regout_reg[0]_0 [0]),
        .A1(\regout_reg[0]_0 [1]),
        .A2(\regout_reg[0]_0 [2]),
        .A3(\regout_reg[0]_0 [3]),
        .A4(1'b0),
        .D(Q[2]),
        .O(p_1_out[2]),
        .WCLK(clk_IBUF_BUFG),
        .WE(p_0_in__0));
  (* INIT = "32'h00000000" *) 
  (* RTL_RAM_BITS = "512" *) 
  (* RTL_RAM_NAME = "reg1/regist_reg" *) 
  (* RTL_RAM_TYPE = "RAM_SP" *) 
  (* XILINX_LEGACY_PRIM = "RAM16X1S" *) 
  (* XILINX_TRANSFORM_PINMAP = "GND:A4" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "15" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "3" *) 
  (* ram_slice_end = "3" *) 
  RAM32X1S_HD21 regist_reg_0_15_3_3
       (.A0(\regout_reg[0]_0 [0]),
        .A1(\regout_reg[0]_0 [1]),
        .A2(\regout_reg[0]_0 [2]),
        .A3(\regout_reg[0]_0 [3]),
        .A4(1'b0),
        .D(Q[3]),
        .O(p_1_out[3]),
        .WCLK(clk_IBUF_BUFG),
        .WE(p_0_in__0));
  LUT2 #(
    .INIT(4'h2)) 
    \regout[3]_i_1 
       (.I0(ena),
        .I1(we),
        .O(p_0_out));
  FDRE #(
    .INIT(1'b0)) 
    \regout_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(p_0_out),
        .D(p_1_out[0]),
        .Q(regout[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \regout_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(p_0_out),
        .D(p_1_out[1]),
        .Q(regout[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \regout_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(p_0_out),
        .D(p_1_out[2]),
        .Q(regout[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \regout_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(p_0_out),
        .D(p_1_out[3]),
        .Q(regout[3]),
        .R(1'b0));
endmodule

(* CHECK_LICENSE_TYPE = "cpumemory,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
module cpumemory
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [11:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [11:0]addra;
  wire clka;
  wire [31:0]dina;
  wire [31:0]douta;
  wire ena;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_doutb_UNCONNECTED;
  wire [11:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "12" *) 
  (* C_ADDRB_WIDTH = "12" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "4" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "5A" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     10.142799 mW" *) 
  (* C_FAMILY = "spartan7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "cpumemory.mem" *) 
  (* C_INIT_FILE_NAME = "cpumemory.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "4096" *) 
  (* C_READ_DEPTH_B = "4096" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "4096" *) 
  (* C_WRITE_DEPTH_B = "4096" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "spartan7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  cpumemory_blk_mem_gen_v8_4_7 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[31:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[11:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[11:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2023.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jLV29U0rrfMIZhYJzdoUrPoqB9eHQ5NXmWyCdqnN3Wgm+GU4C3zthrN1m4QGiaj0thPCIynZbX+0
7yjtkv+T5ByJ6NhiofAwWseGLvPXlYu6ERAPvi4SAYpF2VUqQHtPAbPmnPubGdDRgIEpeobF7hsz
rEcpEru1pyiScUriyuo=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
vsoizVrOONWw/DhjRLEYrtRmtji+Ok63CbpSg/l9VnoKAi8tAzqRbQ57atGB2N6IGGbKHkbK2Uzh
EHgWvYZeyt4hE+bpQX91vc9PNxfjQMGzPoFD3jCWk30EmEk+AND39eWx+DhJ8xhFuucoOQ2GwyAk
B+Mjs15naPE7DvlHel8hnD4dfSdYhGKp96oozu8JeBto8aHG6poOuYkxSwaut7NCI+mabCkMxtMp
RrydgmRuTvhRTbJMyx5CxFSZTRDrS5aU1vaRlnMiqKCI7g2KY9pemYaJsFeVodBuo6IyKGynyEhs
wr+VtUhQDtaVhMkwB95WwmMoDk9F2L5Au1I+TQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
W081dPMCWhKs5YlQD7n3zvf7+PTcnb8eFWxoVs8+zHLkxDMA1klITbsfztGYvJFce8Yao5XQLLqZ
oUE5Pq2arq+zwICFUcLjdMsmP1WmL82znHOPHm83zNwrxWMloHkySAqzFbgJeHa973uZqj0M8ydc
sYmzCYVlGVjt0QX0xqA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Zpc3MmdLWaVOv+S4z2POuoyslYoAbWc+Npxq2UyQRtDwf566IId3uwAetolMAgfLo/G3ezuSOXMn
8NznS37h9XvmVrxA50SAux68P87WgkLtiUYqM3CMBKkxNlZ/TR8WzTuQyFdvzkOE9lp8HC7LXnk5
RDsnOM+su46FW7ysY01COslo9Xc7rhs6WFqx29+Xcqk8+ZMLSzaJfuwZdNmJFS3Q1vhlq3ZeYqMl
wMieB731KsPxjxp7VKNHpTbgFryC2isqc4ohBDOt52M/Bz4B/rIpFeHfZ7X3jWSiKtSuBsDN2NXf
EMjfAT248dlK7NxJ+NBNPhS5sLxTiGyQhta57A==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rPMYqnkKhJKV1wltOfDrKos9ZbucaoX3WGTuqsdLkGpcKObzslHBwlGrKtWV7bZYmS2SM+QuEMfa
CE+tCUdsSiprp+n5BuSQlJa6BJ8mlqccjoo/JLw2QEmUhyMXQ3TLGomGGoZdeTmMPXhUBAOyLPea
Ddc8mgtTN8Kpy117GOTXDKP+IKJqW01fLrPJpgEhFiJCbyElLgtCRWmI94gX+y4XNVS0Cd1YwNw6
4nHgnEdC7fXARDKcYO3VsWC/pdzPQgursXloNLrVYa6i2xr+8E1V0+nSWwNYQZP7XUIVqXKMU8Ea
bT4acXrRCF/5tJJ5B9JparYI0zxXSbaakn1dIw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2022_10", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mfroTgL8g2pyIXQ/mGO9YHm19cd5mOlJ++qpusOYeVxGmkIhvF4aKx+AyIUz2yGGAeCtOzIasHty
pyqKgZhibSqxcpHgR0m6GOxXXOXJiHaK8NzxUzXeRJovcBI/WjtDhXeb1LRMI1J97jVBtJPJQH0Y
fGOD7jWvkvQwxnrZdyLp6kPWgSIcavHHDbO7iJv4gnyGp6W3/FCDo2RKWNLoW+SNjSdLZ6YRP8a+
ldaGU8TYvJ03KWlmik7repuN6AwxCjg2KeQ+x1sBAEXzROXomuSbvX3ZAo8UiIKAQY1SJumHLG3L
QI/S4Wbl1Hz6LDTsttMwP480gq6+tb6s1E4oWw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QJIabgm8dx/gVHbOQFwt8maOKVHFgkpZTPR6dzD8fqoGo9M9oGPTqBqchtPZWgv2UYFF2KEUSlV4
L3SDXBKrLs+NsAVTcICaEMiEi6j82zj/C1LsPkQfS8RLrg0ab8lbDMb5YqJ7lkHs3iM65x2iN1Mf
66cTgCbkAdl3rDpab75btpTQt5ZKiq5CSY3RZfyIW0uWbTGTELm6liuRKM9+K8BQwTU7A+FFFQBA
/9eJwQYzNNA/iwoYJ2WTPd6pBlzXriNLu9M+/2bYicNBSuH1PBR9v2ESrTB6k7EiV1zvBXV9NuG/
sFt4MumWMuSNwP2W38bQATxxW/l0IrmaXGOC/w==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
lhKf/Vgj6pHpme1ji4HVe36BU8pMkam/2I9lFeyOiBnIbzgdEGfLJBcEvkL33A7s0hxa6LFbHnkT
upgMpPjmIghBz3xUQ13vpiY152thFec6qvlcdg1r+GTmnBOSFl6g/OfZ3eFUhfsve6ZjQHpXnKFo
a55hN2+eP1EG9+VxGeM7XkHaeFhEIry52qtnmg072KEFIwRiGs2d/TJ4AqupuIdIiP1kTN9k+oqa
2ta1vdtqPY0dDHqrf+5YSd0CejkhQeCqg/bauLP3755SwdOPRgooG5ANT8hUpTiFMFXtU+GC9NSp
evJtMHUy1NbgMmhFHO+w3URLEdjSaBxZPD7YLdWkF65jY526tJzoek+BzEKoBaGfCaY7O1nHKXm+
89k3rPUy0Xo4/0nHpno+N/Db09heJPbnGsCwN/l+KnR6Lz8kvWziBjZe0ijOkKI+T12y3T1VeOtY
H/aqtNlQt1mhFwrbw6ezaAiDPVbCQXnly6b4tbb8+nFsxWOGIGAfLozB

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PNsQ8uEcQYrl+GaDuBaq1tQ5br5aAdaqHnyrc0NVu/JnQUk53jaiLx8Oz5fNACvWelUUk2/C+P5I
b2rbU1bb/dC6TqC5J1N0yoMYRYw58u4Lrl8Kgqgt9Rlph5Qgzzfxp+oblXF/pO4mRyAXpZhpNkFT
0Ar9BUtPOTOtJ9/g53SRnZ6GjxzfeD+25J4fcXBNo2gCTgUkwiLSsJRwTB/cJmn+dZPwPdIOHEP9
TkfDK+OrbLYO3T+DFBTCMRNH2NB1J9sc5s+nPU8iYnjgPTo6HoGW+LIlCz6yNJMZzJzoeW708utc
0fJXkT7vLDVh7olvy3V9AAY8Do0YR1kiZlhVhQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zAz8RnGHFebkJFAS+gjC+mXHW7m7We+JgSmIz15mS01u/4+9Ng0sJfkeXOClmVPTQ2Mp2Yuv6/6f
ehzUTcANilWsqLM6Q1FToCPNX/NTqodlcHirGM7b5R9yevouNT/aqH12nmbunBQmBHmehNutdCjG
r6Z7kZgeZ2ZE7MMOF0rTy1XHEPkqgMNTRoS8R/pPWPTW4/j+bn3aJj0Q/fTz4Gi3mbSUKWs2fREQ
UKiuolNJkN6DiDvhlVYHUyytXNJG44ikmBXehoQQRLapkYaxnQmMRT1ok9uY6pKoy71CtvJ3Mt2x
EQv1GU2i4qQyAOwa0mkEohWXduicU6tDz3zQwQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TK3eE9V+v1z2P1KjG4GrjhA1n3qDOpNzLGXdtjnjhF0QBFPSuhC+nmNqTPOb3p2a9r5KD0miY3Cd
+KpjH6Ao09E2/LD2Go4aLQh6vP+9BldlSKEwCGfx2NjBQrXWVH21lQR7IRjOvyTOclpd7SgtUJLw
dvebETyLiKr9C6RfnIBeptuCA3iJlXfwkh6I0JfzD5WBizQkotioZmmrXv5105pCXQ4Ta1WThFsA
2ll9dZeSjEDHUxxhfyfjryv9m4VL89ZDU/rGITsdptwB1BC1jLqmPDymY05lyECnjA6NIR5GGfI4
K2y2f4GfikKoN5r9IOvFzw963Wm82ZZPtXOKGg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 80720)
`pragma protect data_block
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
C5foiskoNwA=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
