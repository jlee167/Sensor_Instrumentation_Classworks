`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2017 02:37:59 AM
// Design Name: 
// Module Name: main
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


module capacitor(
    input wire clk,
    input [3:0] BUTTON,
    output I2C_SCL_1,
    inout I2C_SDA_1,
    output [31:0] dataA,
    output [31:0] dataB
    );
    
    reg [23:0] clkdiv;
    reg [7:0] counter;  
    wire [31:0] PC_CLK;
    assign dataA= {{CH1},{CH1_AVE}};  
    assign dataB = {24'b0,{STATUS}};
    
reg [7:0] LEDS;
reg SCL, SDA, SDA_select;
assign I2C_SCL_1 = SCL;
assign I2C_SDA_1 = (SDA_select == 1'b1) ? SDA : 1'bz;


reg [19:0] clk_div_counter;
reg clk_div_select;
reg clk_div;
reg [5:0] curr_state, next_state;
reg [7:0] bit_counter;
reg [17:0] data_addr, data_read;
reg [7:0] data_in;
reg [15:0] CH1,CH2,CH1_AVE, CH2_AVE,STATUS;
reg [26:0] data_write;
reg [7:0] cap_reg, write_reg;
reg [2:0] read_loop_counter, write_loop_counter;
reg [7:0] config_reg, config_reg_data, CH1_Thres_H, CH1_Thres_L, CH2_Thres_H, CH2_Thres_L; 



always @(posedge clk)
begin
	if (clk_div_counter == 20'd500)
		begin
			clk_div_counter <= 20'd0;
			clk_div <= ~clk_div;
		end
	else
		clk_div_counter = clk_div_counter + 20'd1;
end

initial begin
	clk_div_counter = 20'b0;
	curr_state = 6'd0;
	next_state = 6'd0;
	SCL = 1'b1;
end


always @(posedge clk_div)
begin
        curr_state <= next_state;
end


always
begin
    case (curr_state)
    6'd0:begin
        if (BUTTON[0] == 1'b0)
            next_state <= 6'd1;
        else if (BUTTON[1] == 1'b0)
            next_state <= 6'd19;
        else        
            next_state <= 6'd0;
        end
    6'd1: 
        next_state <= 6'd2;

    6'd2:  
        next_state <= 6'd3;
                 
    6'd3:
        next_state <= 6'd4;
        
    6'd4: 
        next_state <= 6'd6;

    
    6'd5: begin
       next_state <= 6'd6; 
    end
    
    6'd6: begin
        if (bit_counter == 8'd0)
            next_state <= 6'd7;
        else
            next_state <= 6'd3;            
    end
    
    6'd7: 
        next_state <= 6'd8;
 
    
    6'd8: 
        next_state <= 6'd9;

    
    6'd9: 
        next_state <= 6'd10;
    
    6'd10: 
            next_state <= 6'd11;
  
    
    6'd11: 
        next_state <= 6'd12;

      
    6'd12:
        next_state <= 6'd13;

    
    6'd13: 
        next_state <= 6'd15;

    
    6'd14: 
       next_state <= 6'd15; 

    
    6'd15: begin
        if (bit_counter == 8'd0)
            next_state <= 6'd16;
        else
            next_state <= 6'd12;            
        end
    
    6'd16: 
        next_state <= 6'd17;

    
    6'd17: 
        next_state <= 6'd18;
    6'd18: 
        if (cap_reg == 8'd8)
            next_state <= 6'd0;
        else
            next_state = 6'd1;
   
   
       6'd19: 
             next_state <= 6'd20;
            
                6'd20:  
                    next_state <= 6'd21;
                             
                6'd21:
                    next_state <= 6'd22;
                    
                6'd22: 
                    next_state <= 6'd24;
            
                
                6'd23: begin
                   next_state <= 6'd24; 
                end
                
                6'd24: begin
                    if (bit_counter == 8'd0)
                        next_state <= 6'd25;
                    else
                        next_state <= 6'd21;            
                end
                
                6'd25: 
                    next_state <= 6'd26;       
                6'd26: 
                    next_state <= 6'd27;          
                6'd27: 
                    next_state <= 6'd28;
                6'd28: 
                    if (write_reg == 8'h0f)
                        next_state <= 6'd19; 
                    else
                      next_state <= 6'd0;          
      
    endcase
end

always @ (posedge clk_div)
begin
    case (curr_state)
        6'd0:begin
            SDA_select <= 1'b0;
            cap_reg <= 8'd0;
            write_reg <= 8'd9;
            
            config_reg <= 8'h0f;
            config_reg_data <= 8'hba;
            CH1_Thres_H <= 8'h9f;
            CH1_Thres_L <= 8'hf0;
            CH2_Thres_H <= 8'h9f;
            CH2_Thres_L <= 8'hf0;
            end
        6'd1: begin
            bit_counter <= 8'd18;
            data_addr[17:9] <= 9'b100100000;
            data_addr[8:1] <= cap_reg[7:0];
            data_addr[0] = 1'b0;
            data_read[17:9] <= 9'b100100010;
            SDA_select <= 1'b1;
            SDA <= 1'b0;
            end
        6'd2:  begin
            SCL <= 1'b0;

        end
                     
        6'd3:begin
            bit_counter <= bit_counter - 8'd1;
 
            if ( (bit_counter == 6'd10) || (bit_counter == 6'd1) )
                SDA_select <= 0;
            else begin
                SDA_select <= 1'b1;
                SDA <= data_addr[17];
            end
            data_addr[17:1] = data_addr[16:0];
        end
            
        6'd4: begin
            SCL <= 1'b1;

        end
        
        6'd5: begin
            
        end
        
        6'd6: begin
            SCL <= 1'b0;  
           // SDA_select <= 0;      
        end
        
        6'd7: begin
            SDA_select <= 1'b1;
            SDA <= 1'b1;

        end
        
        6'd8: begin
            SCL <= 1'b1;

        end
        
        6'd9: begin
            SDA_select <= 1'b0;
            bit_counter <= 8'd18;
 
        end
        
        6'd10: begin
            SDA_select <= 1'b1;
            SDA <= 1'b0;
        end
        
        6'd11:begin
            SCL <= 1'b0;
        end
          
        6'd12:begin
            bit_counter <= bit_counter - 8'd1;
            if ( bit_counter < 8'd11 )
                SDA_select <= 0;
            else begin
                SDA_select <= 1'b1;
                SDA <= data_read[17];
            end
            data_read[17:1] <= data_read[16:0];
        end
        
        6'd13: begin
            SCL <= 1'b1;

        end
        
        6'd14: begin

        end
        
        6'd15: begin
            SCL <= 1'b0;
            data_in[7:1] <= data_in[6:0];
            data_in[0] <= I2C_SDA_1;
        end
        
        6'd16: begin
            SDA_select <= 1'b1;
            SDA <= 1'b1;

        end
        
        6'd17: begin
            SCL <= 1'b1;
            SDA_select<= 1'b0;
        end
        
        6'd18: begin 
        if (cap_reg == 8'd1)
             CH1[15:8] <= data_in[7:0];
        else if (cap_reg == 8'd2)
             CH1[7:0] <= data_in[7:0];
        else if (cap_reg == 8'd3)
             CH2[15:8] <= data_in[7:0];
        else if (cap_reg == 8'd4)
             CH2[7:0] <= data_in[7:0];
        else if (cap_reg == 8'd5)
             CH1_AVE[15:8] <= data_in[7:0];
        else if (cap_reg == 8'd6)
             CH1_AVE[7:0] <= data_in[7:0];
        else if (cap_reg == 8'd7)
             CH2_AVE[15:8] <= data_in[7:0];
        else if (cap_reg == 8'd8)
             CH2_AVE[7:0] <= data_in[7:0];
        else if (cap_reg == 8'd0)
             STATUS[7:0] <= data_in[7:0];
             
            cap_reg <= cap_reg + 1;  
        end
       
        
        6'd19: begin
            bit_counter <= 8'd27;
            SDA_select <= 1'b1;
            SDA <= 1'b0;
            data_write [26:19] = 8'h90;
            data_write[18] <= 1'b0;
            data_write[17:10] <= write_reg;
            data_write[9] <= 1'b0;
            
            if (write_reg == 8'h09)
                data_write[8:1] <= CH1_Thres_H;
            else if (write_reg == 8'h0a)
                data_write[8:1] <= CH1_Thres_L;
            else if (write_reg == 8'h0c)
                data_write[8:1] <= CH2_Thres_H;
            else if (write_reg == 8'h0d)
                data_write[8:1] <= CH2_Thres_L;
            else if (write_reg == 8'h0f)
                    data_write[8:1] <= 8'hb9;
            
            end
            
        6'd20:  begin
            SCL <= 1'b0;
        end
                     
        6'd21:begin
            bit_counter <= bit_counter - 8'd1;
 
            if ( (bit_counter == 6'd19) || (bit_counter == 6'd10) || (bit_counter == 6'd1) )
                SDA_select <= 0;
            else begin
                SDA_select <= 1'b1;
                SDA <= data_write[26];
            end
            data_write[26:1] = data_write[25:0];
        end
            
        6'd22: begin
            SCL <= 1'b1;

        end
        
        6'd23: begin
            
        end
        
        6'd24: begin
            SCL <= 1'b0;  
           // SDA_select <= 0;      
        end
        
        6'd25: begin
            SDA_select <= 1'b1;
            SDA <= 1'b1;

        end
        
        6'd26: begin
            SCL <= 1'b1;
        end
        
        6'd27: begin
            SDA_select <= 1'b0;
            if (write_reg == 8'h09)
                write_reg <= 8'h0a;
            else if (write_reg == 8'h0a)
                write_reg <= 8'h0c;
            else if (write_reg == 8'h0c)
                write_reg <= 8'h0d;
            else if (write_reg == 8'h0d)
                write_reg <= 8'h0f;          
        end
        
        
    endcase
end

endmodule
