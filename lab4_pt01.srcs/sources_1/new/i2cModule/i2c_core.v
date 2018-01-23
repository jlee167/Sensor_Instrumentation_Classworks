`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2017 04:38:32 PM
// Design Name: 
// Module Name: i2c_core
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


//use  a 400kHz clock
            

module i2c_core(
    input           clk,
    input   [2:0]   type,
    input           start,
    input   [7:0]   dIn,
    input           inputACK,

    input           SDA_in,
    output   reg    SDA_out,
     
    output  reg        outputACK,   
    output  reg [7:0]   dOut,
    output   reg   ready,
    output   reg   SCL
    );
    
//reg [31:0]  count;
//reg [31:0]  nextCount;
reg [7:0]   currentState;
reg [7:0]   nextState;

reg [7:0]   SDA_read;
reg [7:0]   nextSDA_read;

reg [7:0]   SDA_write;
reg [7:0]   nextSDA_write;

reg         ACKout;
reg         nextACKout;
reg         ACKin;
reg         nextACKin;  

//reg [7:0]   nextDOut;
  
localparam  TYPE_start  = 3'd0,
            TYPE_stop   = 3'd1,
            TYPE_read   = 3'd2,
            TYPE_write  = 3'd3,
            TYPE_reStart = 3'd4;
            
localparam  STATE_ready = 8'd0,
        
            STATE_start_0 = 8'd1,
            STATE_start_1 = 8'd2,
            STATE_start_2 = 8'd3,
            
            STATE_stop_0 = 8'd4,
            STATE_stop_1 = 8'd5,
            STATE_stop_2 = 8'd6,

            STATE_restart_0 = 8'd7,
            STATE_restart_1 = 8'd8,
            STATE_restart_2 = 8'd9,
            STATE_restart_3 = 8'd10,
                        
            STATE_read_00 = 8'd11,
            STATE_read_01 = 8'd12,
            STATE_read_02 = 8'd13,
            STATE_read_03 = 8'd14,
            STATE_read_04 = 8'd15,
            STATE_read_05 = 8'd16,
            STATE_read_06 = 8'd17,
            STATE_read_07 = 8'd18,
            STATE_read_08 = 8'd19,
            STATE_read_09 = 8'd20,
            STATE_read_10 = 8'd21,
            STATE_read_11 = 8'd22,
            STATE_read_12 = 8'd23,
            STATE_read_13 = 8'd24,
            STATE_read_14 = 8'd25,
            STATE_read_15 = 8'd26,
            STATE_read_16 = 8'd27,
            STATE_read_17 = 8'd28,
            STATE_read_18 = 8'd29,
            STATE_read_19 = 8'd30,
            STATE_read_20 = 8'd31,
            STATE_read_21 = 8'd32,
            STATE_read_22 = 8'd33,
            STATE_read_23 = 8'd34,
            STATE_read_24 = 8'd35,
            STATE_read_25 = 8'd36,
            STATE_read_26 = 8'd37,
            STATE_read_27 = 8'd38,
            STATE_read_28 = 8'd39,
            STATE_read_29 = 8'd40,
            STATE_read_30 = 8'd41,
            STATE_read_31 = 8'd42,
            STATE_read_32 = 8'd43,
            STATE_read_33 = 8'd44,
            STATE_read_34 = 8'd45,
            STATE_read_35 = 8'd46,
            STATE_read_36 = 8'd47,
            STATE_read_37 = 8'd48,
            STATE_read_38 = 8'd49,
            STATE_read_39 = 8'd50,

            
            STATE_write_00 = 8'd51,
            STATE_write_01 = 8'd52,
            STATE_write_02 = 8'd53,
            STATE_write_03 = 8'd54,
            STATE_write_04 = 8'd55,
            STATE_write_05 = 8'd56,
            STATE_write_06 = 8'd57,
            STATE_write_07 = 8'd58,
            STATE_write_08 = 8'd59,
            STATE_write_09 = 8'd60,
            STATE_write_10 = 8'd61,
            STATE_write_11 = 8'd62,
            STATE_write_12 = 8'd63,
            STATE_write_13 = 8'd64,
            STATE_write_14 = 8'd65,
            STATE_write_15 = 8'd66,
            STATE_write_16 = 8'd67,
            STATE_write_17 = 8'd68,
            STATE_write_18 = 8'd69,
            STATE_write_19 = 8'd70,
            STATE_write_20 = 8'd71,
            STATE_write_21 = 8'd72,
            STATE_write_22 = 8'd73,
            STATE_write_23 = 8'd74,
            STATE_write_24 = 8'd75,
            STATE_write_25 = 8'd76,
            STATE_write_26 = 8'd77,
            STATE_write_27 = 8'd78,
            STATE_write_28 = 8'd79,
            STATE_write_29 = 8'd80,
            STATE_write_30 = 8'd81,
            STATE_write_31 = 8'd82,
            STATE_write_32 = 8'd83,
            STATE_write_33 = 8'd84,
            STATE_write_34 = 8'd85,
            STATE_write_35 = 8'd86,
            STATE_write_36 = 8'd87,
            STATE_write_37 = 8'd88,
            STATE_write_38 = 8'd89,
            STATE_write_39 = 8'd90,
            
            STATE_error_01 = 8'd255;
            





initial begin
    currentState = STATE_ready;
    nextState = STATE_ready; 
end



//ACK
always @(*) begin
    outputACK = ACKin;
end

//FSM decode
always @(currentState,start,type,SDA_in, SDA_read, SDA_write, dIn, dOut) begin
//always @(currentState) begin
    ready = 0;
    nextSDA_read = SDA_read;
    nextSDA_write = SDA_write;
    dOut = SDA_read;
    nextACKout = ACKout;
    
    case(currentState)
//////////Start
        STATE_ready: begin
            if(start == 1) begin
                case(type)
                    TYPE_start:     begin nextState = STATE_start_0;
                                    SCL     = 1; end
                    TYPE_stop:      begin nextState = STATE_stop_0;
                                    SCL     = 0; end
                    TYPE_reStart:   begin nextState = STATE_restart_0; 
                                    SCL     = 0; end
                    TYPE_read:      begin nextState = STATE_read_00;   
                                    SCL     = 0; end      
                    TYPE_write:     begin nextState = STATE_write_00;  
                                    SCL     = 0; end         
                    default:        begin nextState = STATE_ready;
                                    SCL     = 1; end
                endcase
                nextSDA_write = dIn;
                nextACKout = inputACK; 
            end else begin
                nextState = STATE_ready;
                SCL = 1;
            end
            
            
            SDA_out = 1; 
            ready = 1; end
                
                    
//////////Start
        STATE_start_0: begin
            nextState = STATE_start_1;
            SCL     = 1; 
            SDA_out = 1; end
        STATE_start_1: begin
            nextState = STATE_start_2;
            SCL     = 1; 
            SDA_out = 0; end
        STATE_start_2: begin
            nextState = STATE_ready;
            SCL     = 10; 
            SDA_out = 0;
            ready = 1; end

//////////Stop
        STATE_stop_0: begin
            nextState = STATE_stop_1;
            SCL     = 0; 
            SDA_out = 0; end
        STATE_stop_1: begin
            nextState = STATE_stop_2;
            SCL     = 1; 
            SDA_out = 0; end
        STATE_stop_2: begin
            nextState = STATE_ready;
            SCL     = 1; 
            SDA_out = 1; 
            ready = 1; end
            
//////////Soft Restart
        STATE_restart_0: begin
            nextState = STATE_restart_1;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_restart_1: begin
            nextState = STATE_restart_2;
            SCL     = 1; 
            SDA_out = 1; end
        STATE_restart_2: begin
            nextState = STATE_restart_3;
            SCL     = 1; 
            SDA_out = 0; end            
        STATE_restart_3: begin
            nextState = STATE_ready;
            SCL     = 0; 
            SDA_out = 0; 
            ready = 1; end        

//////////Read
        STATE_read_00: begin
            nextState = STATE_read_01;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_read_01: begin
            nextState = STATE_read_02;
            SCL     = 1; 
            SDA_out = 1; 
            nextSDA_read[7] = SDA_in; end
        STATE_read_02: begin
            nextState = STATE_read_03;
            SCL     = 1; 
            SDA_out = 1; end            
        STATE_read_03: begin
            nextState = STATE_read_04;
            SCL     = 0; 
            SDA_out = 1; end  
        STATE_read_04: begin
            nextState = STATE_read_05;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_read_05: begin
            nextState = STATE_read_06;
            SCL     = 1; 
            SDA_out = 1; 
            nextSDA_read[6] = SDA_in; end
        STATE_read_06: begin
            nextState = STATE_read_07;
            SCL     = 1; 
            SDA_out = 1; end            
        STATE_read_07: begin
            nextState = STATE_read_08;
            SCL     = 0; 
            SDA_out = 1; end  
        STATE_read_08: begin
            nextState = STATE_read_09;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_read_09: begin
            nextState = STATE_read_10;
            SCL     = 1; 
            SDA_out = 1; 
            nextSDA_read[5] = SDA_in; end
        STATE_read_10: begin
            nextState = STATE_read_11;
            SCL     = 1; 
            SDA_out = 1; end            
        STATE_read_11: begin
            nextState = STATE_read_12;
            SCL     = 0; 
            SDA_out = 1; end  
        STATE_read_12: begin
            nextState = STATE_read_13;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_read_13: begin
            nextState = STATE_read_14;
            SCL     = 1; 
            SDA_out = 1; 
            nextSDA_read[4] = SDA_in; end
        STATE_read_14: begin
            nextState = STATE_read_15;
            SCL     = 1; 
            SDA_out = 1; end            
        STATE_read_15: begin
            nextState = STATE_read_16;
            SCL     = 0; 
            SDA_out = 1; end 
        STATE_read_16: begin
            nextState = STATE_read_17;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_read_17: begin
            nextState = STATE_read_18;
            SCL     = 1; 
            SDA_out = 1; 
            nextSDA_read[3] = SDA_in; end
        STATE_read_18: begin
            nextState = STATE_read_19;
            SCL     = 1; 
            SDA_out = 1; end     
        STATE_read_19: begin
            nextState = STATE_read_20;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_read_20: begin
            nextState = STATE_read_21;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_read_21: begin
            nextState = STATE_read_22;
            SCL     = 1; 
            SDA_out = 1; 
            nextSDA_read[2] = SDA_in; end            
        STATE_read_22: begin
            nextState = STATE_read_23;
            SCL     = 1; 
            SDA_out = 1; end  
        STATE_read_23: begin
            nextState = STATE_read_24;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_read_24: begin
            nextState = STATE_read_25;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_read_25: begin
            nextState = STATE_read_26;
            SCL     = 1; 
            SDA_out = 1; 
            nextSDA_read[1] = SDA_in; end            
        STATE_read_26: begin
            nextState = STATE_read_27;
            SCL     = 1; 
            SDA_out = 1; end  
        STATE_read_27: begin
            nextState = STATE_read_28;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_read_28: begin
            nextState = STATE_read_29;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_read_29: begin
            nextState = STATE_read_30;
            SCL     = 1; 
            SDA_out = 1; 
            nextSDA_read[0] = SDA_in; end            
        STATE_read_30: begin
            nextState = STATE_read_31;
            SCL     = 1; 
            SDA_out = 1; end  
        STATE_read_31: begin
            nextState = STATE_read_32;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_read_32: begin
            nextState = STATE_read_33;
            SCL     = 0; 
            SDA_out = ACKout; end
        STATE_read_33: begin
            nextState = STATE_read_34;
            SCL     = 1; 
            SDA_out = ACKout; end            
        STATE_read_34: begin
            nextState = STATE_read_35;
            SCL     = 1; 
            SDA_out = ACKout; end 
        STATE_read_35: begin
            nextState = STATE_ready;
            SCL     = 0; 
            SDA_out = ACKout; 
            ready = 1;end
                
        
//////////Write
        STATE_write_00: begin
            nextState = STATE_write_01;
            SCL     = 0; 
            SDA_out = SDA_write[7]; end
        STATE_write_01: begin
            nextState = STATE_write_02;
            SCL     = 1; 
            SDA_out = SDA_write[7]; end
        STATE_write_02: begin
            nextState = STATE_write_03;
            SCL     = 1; 
            SDA_out = SDA_write[7]; end            
        STATE_write_03: begin
            nextState = STATE_write_04;
            SCL     = 0; 
            SDA_out = SDA_write[7]; end  
        STATE_write_04: begin
            nextState = STATE_write_05;
            SCL     = 0; 
            SDA_out = SDA_write[6]; end
        STATE_write_05: begin
            nextState = STATE_write_06;
            SCL     = 1; 
            SDA_out = SDA_write[6]; end
        STATE_write_06: begin
            nextState = STATE_write_07;
            SCL     = 1; 
            SDA_out = SDA_write[6]; end            
        STATE_write_07: begin
            nextState = STATE_write_08;
            SCL     = 0; 
            SDA_out = SDA_write[6]; end  
        STATE_write_08: begin
            nextState = STATE_write_09;
            SCL     = 0; 
            SDA_out = SDA_write[5]; end
        STATE_write_09: begin
            nextState = STATE_write_10;
            SCL     = 1; 
            SDA_out = SDA_write[5]; end
        STATE_write_10: begin
            nextState = STATE_write_11;
            SCL     = 1; 
            SDA_out = SDA_write[5]; end            
        STATE_write_11: begin
            nextState = STATE_write_12;
            SCL     = 0; 
            SDA_out = SDA_write[5]; end  
        STATE_write_12: begin
            nextState = STATE_write_13;
            SCL     = 0; 
            SDA_out = SDA_write[4]; end
        STATE_write_13: begin
            nextState = STATE_write_14;
            SCL     = 1; 
            SDA_out = SDA_write[4]; end
        STATE_write_14: begin
            nextState = STATE_write_15;
            SCL     = 1; 
            SDA_out = SDA_write[4]; end            
        STATE_write_15: begin
            nextState = STATE_write_16;
            SCL     = 0; 
            SDA_out = SDA_write[4]; end 
        STATE_write_16: begin
            nextState = STATE_write_17;
            SCL     = 0; 
            SDA_out = SDA_write[3]; end
        STATE_write_17: begin
            nextState = STATE_write_18;
            SCL     = 1; 
            SDA_out = SDA_write[3]; end
        STATE_write_18: begin
            nextState = STATE_write_19;
            SCL     = 1; 
            SDA_out = SDA_write[3]; end     
        STATE_write_19: begin
            nextState = STATE_write_20;
            SCL     = 0; 
            SDA_out = SDA_write[3]; end
        STATE_write_20: begin
            nextState = STATE_write_21;
            SCL     = 0; 
            SDA_out = SDA_write[2]; end
        STATE_write_21: begin
            nextState = STATE_write_22;
            SCL     = 1; 
            SDA_out = SDA_write[2]; end            
        STATE_write_22: begin
            nextState = STATE_write_23;
            SCL     = 1; 
            SDA_out = SDA_write[2]; end  
        STATE_write_23: begin
            nextState = STATE_write_24;
            SCL     = 0; 
            SDA_out = SDA_write[2]; end
        STATE_write_24: begin
            nextState = STATE_write_25;
            SCL     = 0; 
            SDA_out = SDA_write[1]; end
        STATE_write_25: begin
            nextState = STATE_write_26;
            SCL     = 1; 
            SDA_out = SDA_write[1]; end            
        STATE_write_26: begin
            nextState = STATE_write_27;
            SCL     = 1; 
            SDA_out = SDA_write[1]; end  
        STATE_write_27: begin
            nextState = STATE_write_28;
            SCL     = 0; 
            SDA_out = SDA_write[1]; end
        STATE_write_28: begin
            nextState = STATE_write_29;
            SCL     = 0; 
            SDA_out = SDA_write[0]; end
        STATE_write_29: begin
            nextState = STATE_write_30;
            SCL     = 1; 
            SDA_out = SDA_write[0]; end            
        STATE_write_30: begin
            nextState = STATE_write_31;
            SCL     = 1; 
            SDA_out = SDA_write[0]; end  
        STATE_write_31: begin
            nextState = STATE_write_32;
            SCL     = 0; 
            SDA_out = SDA_write[0]; end
        STATE_write_32: begin
            nextState = STATE_write_33;
            SCL     = 0; 
            SDA_out = 1; end
        STATE_write_33: begin
            nextState = STATE_write_34;
            SCL     = 1; 
            SDA_out = 1; 
            nextACKin = SDA_in; end            
        STATE_write_34: begin
            nextState = STATE_write_35;
            SCL     = 1; 
            SDA_out = 1; end 
        STATE_write_35: begin
            nextState = STATE_ready;
            SCL     = 0; 
            SDA_out = 1; 
            ready = 1; end


//////////Soft Restart        
    
        default: begin 
            nextState = STATE_error_01;
            SCL = 0;
            SDA_out = 0; end
    endcase
end

always @ (posedge(clk)) begin
    SDA_write = nextSDA_write;
    SDA_read = nextSDA_read;
    currentState = nextState;
    ACKin = nextACKin;
    ACKout = nextACKout;
//    dOut = nextDOut;
    
end



endmodule
