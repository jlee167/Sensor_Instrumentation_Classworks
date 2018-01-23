`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2017 02:14:29 PM
// Design Name: 
// Module Name: clkDivCustom24bit
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


module clkDivCustom24bit(
    input           clk,    //input clk
    input   [23:0]  div,    //what to divide by. must be at least 2, or else default to 2
    input           rstBar, //If rstBar = 0, reset count
    input           enBar,  //If enBar = 0, clkDiv is running. if not, clkDiv is halted
    output  reg     sclk    //The output sclk. freq(sclk) = freq(clk)/div
    
    
    );
    



reg [23:0] count;           //every posEdge clk, increment count

wire [23:0] divHalf; //Calculate divHalf
                    //Calculated

reg [23:0] nextCount;
reg next_sclk;



    initial begin
        sclk                = 0;    //reset sclk
        nextCount           = 0;
        next_sclk           = 0;
        count               = 0;    //reset count
        
    end
    
    wire en_rstBar;
    //
    assign divHalf = div >> 1;
    assign en_rstBar = ~enBar & rstBar;
    /*
    always @ (div) begin    //whenever div changes
        assign divHalf = div >> 1;  //divHalf is div/2. Use Lshift for simplicity and auto rounding.

    end;*/
    
    //next clock and next sclk
    always @ (*) begin        
        
        
        if (count == div) begin
            nextCount = 1;
            next_sclk = 1;
        end else if(count >= divHalf) begin
            nextCount = count + 1;
            next_sclk = 0; 
        end else begin
            nextCount = count + 1;
            next_sclk = 1;
        end
      
    end
        
    //update sclk and count    
    always @ (posedge(clk)) begin    
        
        if(en_rstBar == 1) begin
            count = nextCount;
            sclk = next_sclk;
        end else begin
            count = 0;
            sclk = 0;
        end
    end
    
endmodule 
