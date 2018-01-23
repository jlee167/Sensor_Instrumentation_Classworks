`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2017 05:04:31 PM
// Design Name: 
// Module Name: mux2to1
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


module mux2to1(
    input in0,
    input in1,
    input sel,
    output reg out0
    );
    
    
always @ (*) begin
    case(sel)
        1'b0: out0 = in0;
        1'b1: out0 = in1;   
       default: out0 = 0'b0;
    endcase

end


endmodule
