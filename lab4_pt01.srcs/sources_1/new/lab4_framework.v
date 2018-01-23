`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////


module pipeIn_PipeOut_framework(
        input   wire [4:0] okUH,
        output  wire[2:0] okHU,
        inout   wire[31:0] okUHU,
        inout   wire okAA,
        input   wire sys_clkn,
        input   wire sys_clkp,
        output CVM300_SPI_EN,
        output CVM300_SPI_IN,
        input  CVM300_SPI_OUT,
        output CVM300_SPI_CLK,
        
        output CVM300_CLK_IN,
        output CVM300_SYS_RES_N,
        input CVM300_CLK_OUT,
        output [7:0] USER_33,
        output CVM300_Enable_LVDS,
        output CVM300_T_EXP1,
        output CVM300_T_EXP2,
        output CVM300_FRAME_REQ,
        input [9:0] CVM300_D,
        input CVM300_Line_valid, CVM300_Data_valid,
        output [7:0]xled,        
        
        output I2C_SCL_0,
        inout I2C_SDA_0,
        output I2C_SCL_1,
        inout I2C_SDA_1,
        
        input [3:0]button
    );
    assign xled[4:0] = state;
    
    reg clk_div;
    reg [1:0] counter_div;
    always @ (posedge clk)
    begin
        counter_div <= counter_div + 1;
        if (counter_div == 2'b11)
            clk_div = ~clk_div;
    end
    
    reg CVM300_SYS_RES_N_reg;
    reg CVM300_T_EXP1_reg;
    reg CVM300_FRAME_REQ_reg;
    reg [1:0] SPI_CONTROL;
    wire [1:0] SPI_CONTROL_WIRE;
    assign SPI_CONTROL_WIRE = SPI_CONTROL;
    assign CVM300_FRAME_REQ = CVM300_FRAME_REQ_reg;
    
    assign CVM300_Enable_LVDS = 1'b0;
    assign CVM300_CLK_IN = clk_div;
    assign CVM300_SYS_RES_N = CVM300_SYS_RES_N_reg; 
    assign CVM300_T_EXP1 = CVM300_T_EXP1_reg;
    
    ila ila0(
    .clk(clk),
    .trig_in(button[0]),
    .trig_in_ack(trig_ack),
    .probe0({CVM300_Line_valid, CVM300_CLK_OUT, CVM300_FRAME_REQ, CVM300_D,CVM300_Data_valid,CVM300_CLK_OUT,SPI_STATE,CVM300_SPI_EN,CVM300_SPI_IN,CVM300_SPI_OUT,CVM300_SPI_CLK,CVM300_CLK_IN}),
    .probe1(button[1:0]),
    .probe2(CVM300_Data_valid),//button[0]),
    .probe3(button)
    );
    wire [7:0] DATA_OUT;
    wire [4:0] state_out;
    assign state_out = state;
    
    reg [7:0] SPI_DATA_IN, SPI_ADDR_IN;
    wire [7:0] SPI_DATA_IN_WIRE, SPI_ADDR_IN_WIRE;
    assign SPI_DATA_IN_WIRE = SPI_DATA_IN;
    assign SPI_ADDR_IN_WIRE = SPI_ADDR_IN;
    
    wire SPI_READY;
    wire [4:0] SPI_STATE;
    
    
    reg[3:0] CAP_CONTROL;
    wire[3:0] CAP_CONTROL_WIRE;
    assign CAP_CONTROL_WIRE[3:0] = CAP_CONTROL[3:0];
    
    capacitor capmodule1(
        .clk(clk),
        .BUTTON(),
        .I2C_SCL_1(I2C_SCL_1),
        .I2C_SDA_1(I2C_SDA_1),
        .dataA(),
        .dataB()
        );
    SPI spimodule1(.SPI_EN_WIRE(CVM300_SPI_EN), .SPI_CLK_WIRE(CVM300_SPI_CLK), .SPI_IN_WIRE(CVM300_SPI_IN), .SPI_OUT_WIRE(CVM300_SPI_OUT), .clk(clk), .data_out_wire(DATA_OUT),
                    .SPI_TRIGGER(SPI_CONTROL), .state_out(SPI_STAT), .SPI_ADDR_IN(SPI_ADDR_IN_WIRE), .SPI_DATA_IN(SPI_DATA_IN_WIRE), .READY(SPI_READY) );
    
    // Clock
    wire clk;
    wire trig_ack;
    
    IBUFGDS osc_clk(
        .O(clk),
        .I(sys_clkp),
        .IB(sys_clkn)
    );
    
    //FP wires    
    wire okClk;
    wire [112:0] okHE;
    wire [64:0] okEH;
    wire [3*65-1:0] okEHx;// Adjust size of okEHx to fit the number of outgoing endpoints in your design (n*65-1:0)

    // Endpoint connections:

    wire [31:0] ep10data;


////
    wire [31:0] epA3pipe; //data in pipe out a3      input
    wire       epA3read; //pipe out a3 read         output
    wire       epA3strobe; //pipe out a3 strobe     output
    wire        epA3ready; //pipe out a3 ready       input
    
    
    
    wire [31:0] pipeDataIn;
    wire [31:0] pipeDataOut;
    
    wire ep80write;    

      
    wire epA0read;    
    wire fifoReset;
    
    wire full           ;
    wire almost_full    ;
    wire empty          ;  
    wire almost_empty   ;
    
    reg reset_temp;
    assign fifoReset = ep10data[0];
    
    
    //Your HDL here
    
    okHost hostIF (
        .okUH(okUH),         //input  wire [4:0]   okUH,    
        .okHU(okHU),         //output wire [2:0]   okHU,    
        .okUHU(okUHU),       //inout  wire [31:0]  okUHU,   
        .okClk(okClk),       //inout  wire         okAA,    
        .okAA(okAA),         //output wire         okClk,   
        .okHE(okHE),         //output wire [112:0] okHE,    
        .okEH(okEH)          //input  wire [64:0]  okEH  

    );
    
    // Adjust N to fit the number of outgoing endpoints in your design (.N(n))
    okWireOR # (.N(3)) wireOR (okEH, okEHx);
    
    // Your FrontPanel module instantiations here
    
    reg [31:0] counter;
    reg [4:0] state, next_state;
    always @(posedge clk_div) begin
        state <= next_state;
    end
    
    
    always @(posedge clk_div) begin 
        case (state)
        5'd0: begin
            CVM300_SYS_RES_N_reg <= 1'b0;
            SPI_CONTROL <= 2'b11;
        end
        5'd1: begin    
            counter <= 32'd0;
            CVM300_SYS_RES_N_reg <= 1'b1;
            CVM300_FRAME_REQ_reg <= 1'b0;
            SPI_DATA_IN <= 8'd9;
            SPI_ADDR_IN <= 8'd69;
            SPI_CONTROL <= 2'b11;
            
            end
        5'd2: 
            SPI_CONTROL <= 2'b01;
        
        5'd3:
            SPI_CONTROL <= 2'b11;
        
        5'd4:begin
            SPI_CONTROL <= 2'b11;
            SPI_DATA_IN <= 8'd3;
            SPI_ADDR_IN <= 8'd57;
        end
        
        5'd5:
            SPI_CONTROL <= 2'b01;
         
        
        5'd6: 
            SPI_CONTROL <= 2'b11;
        5'd7:
            SPI_CONTROL <= 2'b11;
        
        5'd8: 
               CVM300_FRAME_REQ_reg <= 1'b1;
                
        5'd9: 
              CVM300_FRAME_REQ_reg <= 1'b0;
              

        endcase
    end
    
    always begin
        case (state)
            5'd0: 
                if (button[0] == 1'b0)
                    next_state <= 5'd1; 
                else
                    next_state <= 5'd0;
            5'd1: 
                next_state <= 5'd2; 
            
            5'd2: 
                next_state <= 5'd3; 
            5'd3: begin
                     if (SPI_READY == 1'b1)
                          next_state <= 5'd4; 
                     else
                          next_state <= 5'd3;
                  end        
            5'd4:
                   next_state <= 5'd5; 
            5'd5: 
                  next_state <= 5'd6;  
                         
              5'd6:begin
                    if (SPI_READY == 1'b1)
                        next_state <= 5'd7;  
                    else
                        next_state <= 5'd6;  
                    end   
              5'd7:
                    if (ep10data == 32'h00000001)
                        next_state <= 5'd8;
                    else
                        next_state <= 5'd7;
              5'd8:                  
                    next_state <= 5'd9;
              5'd9:                  
                 if (ep10data == 32'h00000001)  
                     next_state <= 5'd8; 
                 else
                    next_state <= 5'd9;                    

        endcase
    end

 //Wire 10    write data
    okWireIn wire10 (           .okHE(okHE),
                                .ep_addr(8'h10), 
                                .ep_dataout(ep10data));                                                         
//Pipein 80
    okPipeIn pipeIn80 (
                                .okHE(okHE), 
                                .okEH(okEHx[ 2*65 +: 65 ]),
                                .ep_addr(8'h80), 
                                .ep_dataout(pipeDataIn), 
                                .ep_write(ep80write));
//pipeout A0
    okPipeOut pipeOutA0 (
                                .okHE(okHE), 
                                .okEH(okEHx[ 0*65 +: 65 ]),
                                .ep_addr(8'ha0), 
                                .ep_datain(pipeDataOut), 
                                .ep_read(epA0read));
//btpipoute A3
    okBTPipeOut pipeOutA3 (     .okHE(okHE), 
                                .okEH(okEHx[ 1*65 +: 65 ]),
                                .ep_addr(8'ha3), 
                                .ep_datain(epA3pipe), 
                                .ep_read(epA3read),
                                .ep_blockstrobe(epA3strobe), 
                                .ep_ready(epA3ready));
    
    fifo_generator_0 fifo   (
  
         .wr_clk(CVM300_CLK_OUT),
         .rd_clk(okClk),                 
         .rst(fifoReset),               
         .din({24'b0,CVM300_D[7:0]}),                 
         .wr_en(CVM300_Data_valid),          
         .rd_en(epA3read),             
         .dout(epA3pipe),               
         .full(full),               
         .almost_full(almost_full), 
         .empty(empty),             
         .almost_empty(almost_empty),             
         .prog_full(epA3ready)
    );
    
 

    
    initial begin
        state = 5'd0;
        //epA3pipe = 0; //data in pipe out a3      input

    end

    
    
    
endmodule
