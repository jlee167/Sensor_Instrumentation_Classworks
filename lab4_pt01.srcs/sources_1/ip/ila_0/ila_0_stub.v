// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Tue Nov 14 09:10:19 2017
// Host        : ECEB-4022-02 running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/jlee167/OKPipes/lab7pipeInPipeOut/lab4_pt01.srcs/sources_1/ip/ila_0/ila_0_stub.v
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a75tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2017.2" *)
module ila_0(clk, trig_in, trig_in_ack, probe0, probe1, probe2, 
  probe3)
/* synthesis syn_black_box black_box_pad_pin="clk,trig_in,trig_in_ack,probe0[31:0],probe1[1:0],probe2[0:0],probe3[3:0]" */;
  input clk;
  input trig_in;
  output trig_in_ack;
  input [31:0]probe0;
  input [1:0]probe1;
  input [0:0]probe2;
  input [3:0]probe3;
endmodule
