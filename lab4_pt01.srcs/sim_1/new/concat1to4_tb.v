`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2017 01:18:35 PM
// Design Name: 
// Module Name: concat1to4_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module concat1to4_tb(

    );



wire [7:0] i2cDriver_DIn;
wire [1:0] i2cDInAddr;
wire       i2cDIn_clk;

reg clkHalf;

initial begin
    clkHalf = 0;
end

always begin
    #5
        clkHalf = ~clkHalf;

end





mux4to1_withAddr i2cDriverDataMux(
         .enable(1),            //input   enable,
         .clk(clkHalf),               //input   clk,
                      //
         .in0(8'h11),         //input   [7:0] in0,
         .in1(8'h22),         //input   [7:0] in1,
         .in2(8'h33),         //input   [7:0] in2,
         .in3(8'h44),         //input   [7:0] in3,
                            //
         .out0(i2cDriver_DIn),    //output  reg [7:0] out0,
         .outAddr(i2cDInAddr), //output  reg [1:0] outAddr,
         .clkb(i2cDIn_clk)           //output  reg clkb
);


endmodule
