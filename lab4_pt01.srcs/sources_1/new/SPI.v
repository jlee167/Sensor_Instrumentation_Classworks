`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2017 06:49:17 AM
// Design Name: 
// Module Name: SPI
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


module SPI(
    input [1:0] SPI_TRIGGER,
    output SPI_EN_WIRE,
    output SPI_CLK_WIRE,
    output SPI_IN_WIRE,
    input SPI_OUT_WIRE,
    input [7:0] SPI_ADDR_IN, SPI_DATA_IN,
    input clk,
    output [7:0] data_out_wire,
    output [4:0] state_out,
    output READY
    );
    

    reg ready;
    assign READY = ready;
    reg SPI_EN, SPI_IN, SPI_OUT, SPI_CLK;
    reg [4:0] state, next_state;
    assign SPI_EN_WIRE = SPI_EN;
    assign SPI_CLK_WIRE = SPI_CLK;
    assign SPI_IN_WIRE = SPI_IN;    
    assign data_out_wire = data_out;
    assign state_out = state;
    
    reg [7:0] addr_read, temp_data, addr_write;
    reg [7:0] data_out;
    reg [4:0] counter_8;
    
    always @ (posedge clk)
    begin
        state <= next_state;
    end
    
    always @ (posedge clk)
    begin
        case (state)
        5'd0:
            begin
            addr_read <= SPI_ADDR_IN;
            addr_write <= (8'b10000000 | SPI_ADDR_IN);
            temp_data <= SPI_DATA_IN;
            SPI_EN <= 1'b0;
            SPI_CLK <= 1'b0;
            counter_8 <= 5'd8;
            ready <= 1'b1;
            end
        5'd1:
            begin
            SPI_EN <= 1'b1;
            SPI_CLK <= 1'b0;
            SPI_IN <= addr_read[7];
            addr_read [7:1] <= addr_read[6:0];
            counter_8 <= counter_8 - 5'd1;   
            ready <= 1'b0;         
            end   
        5'd2:
            begin
            SPI_CLK <= 1'b1;
            if (counter_8 == 5'd0)
                counter_8 <= 5'd8;
            ready <= 1'b0;
            end
        5'd3:
            begin
                SPI_CLK <= 1'b0;
                SPI_IN <= 1'b0;
                counter_8 = counter_8 - 5'd1;
                ready <= 1'b0;
            end
        5'd4: 
            begin
                SPI_CLK <= 1'b1;
                data_out[0] <= SPI_OUT;
                data_out[7:1] <= data_out[6:0];
                ready <= 1'b0;
            end
        5'd5:
                begin
                SPI_EN <= 1'b1;
                SPI_CLK <= 1'b0;
                SPI_IN <= addr_write[7];
                addr_write [7:1] <= addr_write[6:0];
                counter_8 <= counter_8 - 5'd1;     
                ready <= 1'b0;       
                end   
       5'd6:
                begin
                SPI_CLK <= 1'b1;
                if (counter_8 == 5'd0)
                    counter_8 <= 5'd8;
                ready <= 1'b0;
                end

       5'd7:
            begin
                SPI_CLK <= 1'b0;
                SPI_IN <= temp_data[7];
                temp_data[7:1] <= temp_data[6:0];
                counter_8 = counter_8 - 5'd1;
                ready <= 1'b0;
            end
       5'd8: 
            begin
                SPI_CLK <= 1'b1;
                ready <= 1'b0;
            end                       
        endcase    
    end
 
    always
    begin
        case (state)
        5'd0:   begin
                if (SPI_TRIGGER == 2'b10) 
                    next_state <= 5'd1;
                else if (SPI_TRIGGER == 2'b01)
                    next_state <= 5'd5; 
                else
                    next_state <= 5'd0;
                end
                
        5'd1:   begin
                next_state <= 5'd2; end
        5'd2:   begin
                if (counter_8 == 5'd0)
                    next_state <= 5'd3; 
                else
                    next_state <= 5'd1;
                end
        5'd3:   begin
                    next_state <= 5'd4;
                end
        5'd4:   begin
                if (counter_8 == 5'd0)
                    next_state <= 5'd0; 
                else
                    next_state <= 5'd3;
                end
                5'd5:   begin
                        next_state <= 5'd6; end
                5'd6:   begin
                        if (counter_8 == 5'd0)
                            next_state <= 5'd7; 
                        else
                            next_state <= 5'd5;
                        end
                5'd7:   begin
                            next_state <= 5'd8;
                        end
                5'd8:   begin
                        if (counter_8 == 5'd0)
                            next_state <= 5'd0; 
                        else
                            next_state <= 5'd7;
                        end        
        
        endcase
    end
endmodule
