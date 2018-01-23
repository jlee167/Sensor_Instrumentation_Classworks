`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2017 04:01:02 PM
// Design Name: 
// Module Name: concat_1to4_withAddr
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


module concat_1to4_withAddr(
        input clk,
        input [7:0] dIn,
        
        output reg [1:0] dataAddr,
        output reg [31:0] dOutCat
    );
    
initial begin
    dataAddr = 0;
    dOutCat = 0;
end
   
always @ (posedge(clk)) begin
    dataAddr = dataAddr + 1;
end

always @ (negedge(clk)) begin
    dOutCat = dOutCat;

    case(dataAddr)
        0: dOutCat[8*0+:8] = dIn;
        1: dOutCat[8*1+:8] = dIn;
        2: dOutCat[8*2+:8] = dIn;
        3: dOutCat[8*3+:8] = dIn;
        default: begin end
    endcase
end



endmodule
