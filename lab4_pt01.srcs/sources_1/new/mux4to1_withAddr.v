`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2017 03:43:49 PM
// Design Name: 
// Module Name: mux4to1_withAddr
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


module mux4to1_withAddr(
        input   enable,
        input   clk,
        
        input   [7:0] in0,
        input   [7:0] in1,
        input   [7:0] in2,
        input   [7:0] in3,
        
        output  reg [7:0] out0,
        output  reg [1:0] outAddr,
        output  reg clkb
    );

        
    
initial begin
    outAddr = 0;
     
end

always @ (posedge(clk)) begin
    
    outAddr = outAddr + 1;    
end 

always @ (clk, enable) begin
    if(enable == 1)begin
        clkb = ~clk;
    end else begin
        clkb = 0;
    end
end

always @ (*) begin
    if(enable == 1) begin
        case(outAddr)
            0: out0 = in0;
            1: out0 = in1;
            2: out0 = in2;
            3: out0 = in3;
            default: out0 = 8'bz;
        endcase
    end else begin
        out0 = 8'bz;
    end
    
end

  
endmodule
