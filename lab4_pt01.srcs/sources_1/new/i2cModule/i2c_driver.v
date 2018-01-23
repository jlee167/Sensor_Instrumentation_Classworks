`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2017 04:01:07 PM
// Design Name: 
// Module Name: i2c_driver
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


module i2c_driver(
    //type  type    size    name
    input               clk,
    input               start,
    input   [7:0]       dataIn,
    input               dataInClk,
    input   [3:0]       dataInAddr,
    input   [7:0]       deviceAddr,
    input   [7:0]       registAddr,
    input               readWriteB,
    input   [3:0]       byteCount,      //Send the X most recent bytes, in order of being input
    
    output  reg         flag_ready,     //i2c has finished
    output              flag_valid,
    
    output  reg  [7:0]  dataOut,
    input        [3:0]  dOutAddr,
    output  reg         flag_ACKb,
    
    output              SCL,
    input               SDA_in,
    output              SDA_out
    );
    
localparam  TYPE_start  = 3'd0,
            TYPE_stop   = 3'd1,
            TYPE_read   = 3'd2,
            TYPE_write  = 3'd3,
            TYPE_reStart = 3'd4;
            
localparam  STATE_ready       = 4'd0,
                                        //prep: setup the inputs
                                        //go: standby, do whatever.
            STATE_write_01    = 8'd1,   //start prep
            STATE_write_02    = 8'd2,   //start go
            STATE_write_03    = 8'd3,   //addrW prep
            STATE_write_04    = 8'd4,   //addrW go
            STATE_write_05    = 8'd5,   //regAddr prep   
            STATE_write_06    = 8'd6,   //regAddr go     
            STATE_write_07    = 8'd7,   //write N prep
            STATE_write_08    = 8'd8,   //write go
            STATE_write_09    = 8'd9,   //stop prep
            STATE_write_10    = 8'd10,   //stop go
            
            STATE_read_01     = 8'd11,  //start prep  
            STATE_read_02     = 8'd12,  //start go    
            STATE_read_03     = 8'd13,  //addrW prep  
            STATE_read_04     = 8'd14,  //addrW go    
            STATE_read_05     = 8'd15,  //regAddr prep   
            STATE_read_06     = 8'd16,  //regAddr go     
            STATE_read_07     = 8'd17,  //restart pre
            STATE_read_08     = 8'd18,  //restart go 
            STATE_read_09     = 8'd19,  //addrW prep  
            STATE_read_10     = 8'd20,  //addrW go       
            STATE_read_11     = 8'd21,  //write N prep
            STATE_read_12     = 8'd22,  //write go    
            STATE_read_13     = 8'd23,  //stop prep   
            STATE_read_14     = 8'd24;  //stop go     
                        
    
localparam queueSize = 16;    

reg [queueSize*8-1:0] dInQ;     //queue of 16 bits
reg [queueSize*8-1:0] dOutQ;    //queue of 16 bits
// dInQ[ N*8 +: 8 ]     For byte N    
reg [queueSize*8-1:0] dInQ_active;     //active queue of 16 bits
reg [queueSize*8-1:0] dOutQ_active;    //active queue of 16 bits

reg [queueSize*8-1:0] nextDInQ_active;     //active queue of 16 bits
//reg [queueSize*8-1:0] nextDOutQ_active;    //active queue of 16 bits

reg [queueSize*8-1:0] nextDOutQ;    // queue of 16 bits


reg [7:0] nextState;
reg [7:0] currentState;

reg [3:0] byteCount_active;
reg [6:0] deviceAddr_active;
reg [7:0] registerAddr_active;
reg [6:0] nextDeviceAddr_active;
reg [7:0] nextRegisterAddr_active;


reg [3:0] dataPointer_active;
reg [3:0] nextByteCount_active;
reg [3:0] nextDataPointer_active;

reg [7:0] activeByteIn;
wire [7:0] activeByteOut;

wire        coreReady;
reg         coreStart;
reg         coreInputACK;
reg [7:0]   coreDIn;
reg [2:0]   coreType;

reg nextFlag_ACKb;
reg nextFlag_ready;

wire coreOutputACK;

i2c_core i2cCore(
    .clk(clk),                  //input           clk,
    .type(coreType),            //input   [2:0]   type,
    .start(coreStart),          //input           start,
    .dIn(coreDIn),              //input   [7:0]   dIn,
    .inputACK(coreInputACK),    //input           inputACK,

    .SDA_in(SDA_in),            //input           SDA_in,
    .SDA_out(SDA_out),          //output   reg    SDA_out,
     
    .outputACK(coreOutputACK),      //output  reg        coreOutputACK,   
    .dOut(activeByteOut),       //output  reg [7:0]   dOut,
    .ready(coreReady),          //output   reg   ready,
    .SCL(SCL)                   //output   reg   SCL
    );









initial begin
   // dInPointer = 0;
    //dOutPointer = 0;
    currentState = STATE_ready;
    nextState = STATE_ready;
    
    byteCount_active        = 0;
    nextByteCount_active    = 0;
    
    dataPointer_active      = 0;
    nextDataPointer_active  = 0;
    
    registerAddr_active = 0;
    nextRegisterAddr_active = 0;
    
    deviceAddr_active = 0;
    nextDeviceAddr_active = 0;
    
    coreStart = 0;
    coreInputACK = 0;
    
    
    dInQ  = queueSize*8'h0;    //queue of 16 bits
    dOutQ = queueSize*8'h0;    //queue of 16 bits   
    
    dInQ_active = queueSize*8'h0;     //active queue of 16 bits
    dOutQ_active = queueSize*8'h0;
    
    nextDInQ_active = queueSize*8'h0; //active queue of 16 bits
    //reg [queueSize*8-1:0] nextDOutQ_active;    //active queue of 16 bits
    
    nextDOutQ = queueSize*8'h0;    // queue of 16 bits


    flag_ACKb = 1;
    nextFlag_ACKb = 1;
    
    flag_ready = 0;
    nextFlag_ready = 0;

  
    
    
    
    
    
end

//active byte in of core
always @ (*) begin
    activeByteIn = activeByteIn;
    case(dataPointer_active) 
        0 :         activeByteIn = dInQ_active[       0 *8 +:8];
        1 :         activeByteIn = dInQ_active[       1 *8 +:8];
        2 :         activeByteIn = dInQ_active[       2 *8 +:8];
        3 :         activeByteIn = dInQ_active[       3 *8 +:8];
        4 :         activeByteIn = dInQ_active[       4 *8 +:8]; 
        5 :         activeByteIn = dInQ_active[       5 *8 +:8];
        6 :         activeByteIn = dInQ_active[       6 *8 +:8];
        7 :         activeByteIn = dInQ_active[       7 *8 +:8];
        8 :         activeByteIn = dInQ_active[       8 *8 +:8];
        9 :         activeByteIn = dInQ_active[       9 *8 +:8];
        10:         activeByteIn = dInQ_active[       10*8 +:8];
        11:         activeByteIn = dInQ_active[       11*8 +:8];
        12:         activeByteIn = dInQ_active[       12*8 +:8];
        13:         activeByteIn = dInQ_active[       13*8 +:8]; 
        14:         activeByteIn = dInQ_active[       14*8 +:8];
        15:         activeByteIn = dInQ_active[       15*8 +:8];
        default:    activeByteIn = dInQ_active[       0*8  +:8];
    endcase
end

//active byte out of core
always @ (*) begin
    dOutQ_active = dOutQ_active;
    case(dataPointer_active) 
        0 :         dOutQ_active[       0 *8 +:8] = activeByteOut;
        1 :         dOutQ_active[       1 *8 +:8] = activeByteOut;
        2 :         dOutQ_active[       2 *8 +:8] = activeByteOut;
        3 :         dOutQ_active[       3 *8 +:8] = activeByteOut;
        4 :         dOutQ_active[       4 *8 +:8] = activeByteOut; 
        5 :         dOutQ_active[       5 *8 +:8] = activeByteOut;
        6 :         dOutQ_active[       6 *8 +:8] = activeByteOut;
        7 :         dOutQ_active[       7 *8 +:8] = activeByteOut;
        8 :         dOutQ_active[       8 *8 +:8] = activeByteOut;
        9 :         dOutQ_active[       9 *8 +:8] = activeByteOut;
        10:         dOutQ_active[       10*8 +:8] = activeByteOut;
        11:         dOutQ_active[       11*8 +:8] = activeByteOut;
        12:         dOutQ_active[       12*8 +:8] = activeByteOut;
        13:         dOutQ_active[       13*8 +:8] = activeByteOut; 
        14:         dOutQ_active[       14*8 +:8] = activeByteOut;
        15:         dOutQ_active[       15*8 +:8] = activeByteOut;
        default:    dOutQ_active[       0*8  +:8] = activeByteOut;
    endcase
end


//data loading
always @ (posedge(dataInClk)) begin
    dInQ = dInQ;
    case(dataInAddr) 
        0 :         dInQ[       0 *8 +:8] = dataIn;
        1 :         dInQ[       1 *8 +:8] = dataIn;
        2 :         dInQ[       2 *8 +:8] = dataIn;
        3 :         dInQ[       3 *8 +:8] = dataIn;
        4 :         dInQ[       4 *8 +:8] = dataIn; 
        5 :         dInQ[       5 *8 +:8] = dataIn;
        6 :         dInQ[       6 *8 +:8] = dataIn;
        7 :         dInQ[       7 *8 +:8] = dataIn;
        8 :         dInQ[       8 *8 +:8] = dataIn;
        9 :         dInQ[       9 *8 +:8] = dataIn;
        10:         dInQ[       10*8 +:8] = dataIn;
        11:         dInQ[       11*8 +:8] = dataIn;
        12:         dInQ[       12*8 +:8] = dataIn;
        13:         dInQ[       13*8 +:8] = dataIn; 
        14:         dInQ[       14*8 +:8] = dataIn;
        15:         dInQ[       15*8 +:8] = dataIn;
        default:    dInQ[       0*8  +:8] = dataIn;
    endcase
end

//data reading
always @ (*) begin
    dataOut = dataOut;
    case(dOutAddr)
         0 :        dataOut = dOutQ[        0 *8 +:8];
         1 :        dataOut = dOutQ[        1 *8 +:8];
         2 :        dataOut = dOutQ[        2 *8 +:8];
         3 :        dataOut = dOutQ[        3 *8 +:8];
         4 :        dataOut = dOutQ[        4 *8 +:8];
         5 :        dataOut = dOutQ[        5 *8 +:8];
         6 :        dataOut = dOutQ[        6 *8 +:8];
         7 :        dataOut = dOutQ[        7 *8 +:8];
         8 :        dataOut = dOutQ[        8 *8 +:8];
         9 :        dataOut = dOutQ[        9 *8 +:8];
         10:        dataOut = dOutQ[        10*8 +:8];
         11:        dataOut = dOutQ[        11*8 +:8];
         12:        dataOut = dOutQ[        12*8 +:8];
         13:        dataOut = dOutQ[        13*8 +:8];
         14:        dataOut = dOutQ[        14*8 +:8];
         15:        dataOut = dOutQ[        15*8 +:8];
         default:   dataOut = dOutQ[        15*8 +:8];
    endcase    
end


always @    (*) begin //fsm
    nextState = currentState;
    nextDataPointer_active = dataPointer_active;
    case(currentState)
        STATE_ready     : begin     nextDataPointer_active = 0; 
                                    if((readWriteB == 1) && (start == 1))begin nextState = STATE_read_01;  end  
                                    else if ((readWriteB == 0) && (start == 1)) begin nextState = STATE_write_01; end 
                                    else               begin nextState = STATE_ready;    end end//ready
        
        STATE_write_01  : begin     if(coreReady ==0)begin nextState = STATE_write_02; end  end//start prep   
        STATE_write_02  : begin     if(coreReady ==1)begin nextState = STATE_write_03; end  end//start go       
        STATE_write_03  : begin     if(coreReady ==0)begin nextState = STATE_write_04; end  end//addr/W prep   
        STATE_write_04  : begin     if(coreReady ==1)begin 
                                                    if(flag_ACKb == 0) begin nextState = STATE_write_05; end
                                                    else nextState = STATE_write_09; end end//addr/W go    
        STATE_write_05  : begin     if(coreReady ==0)begin nextState = STATE_write_06; end  end//regAddr prep   
        STATE_write_06  : begin     if(coreReady ==1)begin nextState = STATE_write_07; end  end//regAddr go  
        STATE_write_07  : begin     if(coreReady ==0)begin nextState = STATE_write_08; end  end//write N prep 
        STATE_write_08  : begin     if(coreReady ==1)begin  if(dataPointer_active < (byteCount_active-1)) begin nextState = STATE_write_07; nextDataPointer_active = dataPointer_active +1; end
                                                            else begin nextState = STATE_write_09; end end end      //write N go                                                       
        STATE_write_09  : begin     if(coreReady ==0)begin nextState = STATE_write_10; end  end//stop prep    
        STATE_write_10  : begin     if(coreReady ==1)begin nextState = STATE_ready;    end  end//stop go      
                                            
                                                                                       
        STATE_read_01   : begin     if(coreReady ==0)begin nextState = STATE_read_02;  end  end//start prep   
        STATE_read_02   : begin     if(coreReady ==1)begin nextState = STATE_read_03;  end  end//start go     
        STATE_read_03   : begin     if(coreReady ==0)begin nextState = STATE_read_04;  end  end//addrW prep   
        STATE_read_04   : begin     if(coreReady ==1)begin 
                                                    if(flag_ACKb == 0) begin nextState = STATE_read_05; end
                                                    else begin nextState = STATE_read_13;  end end  end//addrW go
        STATE_read_05   : begin     if(coreReady ==0)begin nextState = STATE_read_06;  end  end//regAddr prep   
        STATE_read_06   : begin     if(coreReady ==1)begin nextState = STATE_read_07;  end  end//regAddr go     
        STATE_read_07   : begin     if(coreReady ==0)begin nextState = STATE_read_08;  end  end//restart pre  
        STATE_read_08   : begin     if(coreReady ==1)begin nextState = STATE_read_09;  end  end//restart go   
        STATE_read_09   : begin     if(coreReady ==0)begin nextState = STATE_read_10;  end  end//addrR prep   
        STATE_read_10   : begin     if(coreReady ==1)begin 
                                                    if(flag_ACKb == 0) begin nextState = STATE_read_11; end
                                                    else begin nextState = STATE_read_13; end end end//addrR go     
        STATE_read_11   : begin     if(coreReady ==0)begin nextState = STATE_read_12;  end  end//read N prep 
        STATE_read_12   : begin     if(coreReady ==1)begin  if(dataPointer_active < (byteCount_active-1) ) begin nextState = STATE_read_11; nextDataPointer_active = dataPointer_active +1; end
                                                            else begin nextState = STATE_read_13; end end end //read N go
        STATE_read_13   : begin     if(coreReady ==0)begin nextState = STATE_read_14;  end  end//stop prep    
        STATE_read_14   : begin     if(coreReady ==1)begin nextState = STATE_ready;    end  end//stop go      

        default         : begin end
    endcase
end

//TYPE_start  = 3'd0, 
//TYPE_stop   = 3'd1, 
//TYPE_read   = 3'd2, 
//TYPE_write  = 3'd3, 
//TYPE_reStart = 3'd4;



always @    (*) begin //fsm decoder
    nextDeviceAddr_active = deviceAddr_active;
    nextRegisterAddr_active = registerAddr_active;
    nextByteCount_active = byteCount_active;
    nextDInQ_active = dInQ_active;
//    nextDOutQ_active = dOutQ_active;
    nextFlag_ACKb = flag_ACKb;
    nextFlag_ready = 0;
    nextDOutQ = dOutQ;
    
    case(currentState)
        STATE_ready     : begin coreStart = 0; 
                        nextDeviceAddr_active = deviceAddr; nextRegisterAddr_active = registAddr; 
                        nextByteCount_active = byteCount;   
                        nextDInQ_active = dInQ; 
                        nextFlag_ready = 1; end//ready
        
        
        
        
//        STATE_write_03  : begin coreStart = 1; coreInputACK = 0; coreType = 3'd3; coreDIn = {deviceAddr_active , 1'b0}; end//addrW prep   
        STATE_write_01  : begin coreStart = 1; coreInputACK = 1; coreType = 3'd0; coreDIn = 0; end//start prep      
        STATE_write_02  : begin coreStart = 1; coreInputACK = 1; coreType = 3'd0; coreDIn = 0; end//start go        
        STATE_write_03  : begin coreStart = 1; coreInputACK = 1; coreType = 3'd3; coreDIn = {deviceAddr_active,1'b0}; nextFlag_ACKb = coreOutputACK; end//addr/W prep      
        STATE_write_04  : begin coreStart = 1; coreInputACK = 1; coreType = 3'd3; coreDIn = {deviceAddr_active,1'b0}; nextFlag_ACKb = coreOutputACK; end//addr/W go        
        STATE_write_05  : begin coreStart = 1; coreInputACK = 1; coreType = 3'd3; coreDIn = registerAddr_active; end//regAddr prep    
        STATE_write_06  : begin coreStart = 1; coreInputACK = 1; coreType = 3'd3; coreDIn = registerAddr_active; end//regAddr go      
        STATE_write_07  : begin coreStart = 1; coreInputACK = 1; coreType = 3'd3; coreDIn = activeByteIn; end//write N prep    
        STATE_write_08  : begin coreStart = 1; coreInputACK = 1; coreType = 3'd3; coreDIn = activeByteIn; end//write go        
        STATE_write_09  : begin coreStart = 1; coreInputACK = 1; coreType = 3'd1; coreDIn = 0; nextDOutQ = dOutQ_active; nextFlag_ACKb = coreOutputACK; end//stop prep       
        STATE_write_10  : begin coreStart = 1; coreInputACK = 1; coreType = 3'd1; coreDIn = 0; nextDOutQ = dOutQ_active; nextFlag_ACKb = coreOutputACK; end//stop go         
                                                                                     
        STATE_read_01   : begin coreStart = 1; coreInputACK = 0; coreType = 3'd0; coreDIn = 0; end//start prep      
        STATE_read_02   : begin coreStart = 1; coreInputACK = 0; coreType = 3'd0; coreDIn = 0; end//start go        
        STATE_read_03   : begin coreStart = 1; coreInputACK = 0; coreType = 3'd3; coreDIn = {deviceAddr_active,1'b0}; nextFlag_ACKb = coreOutputACK; end//addr/W prep      
        STATE_read_04   : begin coreStart = 1; coreInputACK = 0; coreType = 3'd3; coreDIn = {deviceAddr_active,1'b0}; nextFlag_ACKb = coreOutputACK; end//addr/W go        
        STATE_read_05   : begin coreStart = 1; coreInputACK = 0; coreType = 3'd3; coreDIn = registerAddr_active; end//regAddr prep    
        STATE_read_06   : begin coreStart = 1; coreInputACK = 0; coreType = 3'd3; coreDIn = registerAddr_active; end//regAddr go      
        STATE_read_07   : begin coreStart = 1; coreInputACK = 0; coreType = 3'd4; coreDIn = 1; end//restart pre     
        STATE_read_08   : begin coreStart = 1; coreInputACK = 0; coreType = 3'd4; coreDIn = 1; end//restart go      
        STATE_read_09   : begin coreStart = 1; coreInputACK = 0; coreType = 3'd3; coreDIn = {deviceAddr_active,1'b1}; nextFlag_ACKb = coreOutputACK; end//addrR prep      
        STATE_read_10   : begin coreStart = 1; coreInputACK = 0; coreType = 3'd3; coreDIn = {deviceAddr_active,1'b1}; nextFlag_ACKb = coreOutputACK; end//addrR go        
        STATE_read_11   : begin coreStart = 1;  coreType = 3'd2; coreDIn = 0; 
                                   if(dataPointer_active < (byteCount_active-1) ) begin coreInputACK = 10;  end
                                   else begin coreInputACK = 1; end 
                                                                    end//read N prep    
        STATE_read_12   : begin coreStart = 1;  coreType = 3'd2; coreDIn = 0; 
                                   if(dataPointer_active < (byteCount_active-1) ) begin coreInputACK = 0;  end
                                   else begin coreInputACK = 1; end  
                                                                    end//read go        
        STATE_read_13   : begin coreStart = 1; coreInputACK = 0; coreType = 3'd1; coreDIn = 0; nextDOutQ = dOutQ_active; nextFlag_ACKb = coreOutputACK; end//stop prep       
        STATE_read_14   : begin coreStart = 1; coreInputACK = 0; coreType = 3'd1; coreDIn = 0; nextDOutQ = dOutQ_active; nextFlag_ACKb = coreOutputACK; end//stop go         


        default         : begin coreStart = 0; coreInputACK = 1; coreType = 3'd1; coreDIn = 0; end
    endcase
end




always @ (posedge(clk)) begin
    currentState        = nextState;
    dataPointer_active  = nextDataPointer_active;
    registerAddr_active = nextRegisterAddr_active;
    deviceAddr_active   = nextDeviceAddr_active;
    byteCount_active    = nextByteCount_active;
    dInQ_active         = nextDInQ_active;
    //dOutQ_active        = nextDOutQ_active;
    flag_ACKb           = nextFlag_ACKb;
    flag_ready          = nextFlag_ready;
    
    dOutQ = nextDOutQ;
end
    
endmodule
