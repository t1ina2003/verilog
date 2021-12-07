/*
 * I2C interface slave module.
 * 2021/07/27 start writing this program, 
 *
 * yeah, master is too hard for me at this moment.😂
 * basic function:
 * 1. receive START, STOP.
 * 2. receive 7-bit address, compare address, and ACK.
 *
 * Copyright (C) 2021 Shawn ZS Wang <ZS_Wang@wistron.com>
 * Distributed under the terms of GPLv2 or (at your option) any later version.
 */
module i2c_slave (
    SDA,
    SCL,
);

inout SDA;
input SCL;

reg sda_en = 0, sda_data = 0;
assign SDA = (sda_en) ? sda_data : 1'bz;

//---------------------------------------------
// Pararmeter Declaration
//---------------------------------------------
parameter I2C_ADDR = 7'h27;

//---------------------------------------------
// State Declaration
//---------------------------------------------
parameter IDLE = 8;
parameter ADDR7 = 7;
parameter ADDR6 = 6;
parameter ADDR5 = 5;
parameter ADDR4 = 4;
parameter ADDR3 = 3;
parameter ADDR2 = 2;
parameter ADDR1 = 1;
parameter RW = 0;

//---------------------------------------------
// start,stop condition
//---------------------------------------------
reg start = 0, stop = 0;
always @ ( negedge SDA )
    if(SCL) begin
        start = 1;
        stop = 0;
    end
always @ ( posedge SDA )
    if(SCL) begin
        stop = 1;
        start = 0;
    end
//---------------------------------------------
// State counter
//---------------------------------------------
reg [3:0] state = IDLE;
always @(negedge SCL) begin
    // loop state while start
    if(start && state > RW)
        state = state - 1;
    if(stop)
        state = IDLE;
    // check ACK, take SDA
    if( ack==1 && state==RW) begin
        sda_en = 1;
        sda_data = 0;
        state = IDLE;
    end
    // back to IDLE state, return SDA
    else begin
        ack = 0;
        sda_data = 0;
        sda_en = 0;
    end

end

//---------------------------------------------
// Address matching & Send ACK
//---------------------------------------------
reg [6:0] addr_diff = 7'd0;
reg ack = 0, nack = 0;
reg rw = 0;
always @(posedge SCL) begin
    // Address check difference
    if( state<IDLE & ack==0 & state>RW ) begin 
        addr_diff[state-1] = I2C_ADDR[state-1] ^ SDA; //check I2C_ADDR[6:0]
    end 
    // Calculate if ACK
    if( ~(|addr_diff[6:0]) && state==RW ) begin
        ack = 1;
        rw = SDA;
    end
end

endmodule

//---------------------------------------------
// TESTBENCH
//---------------------------------------------
`timescale 1s/1ms
module tb;
    reg scl;
    wire sda;
    reg sda_en = 0, sda_data = 0;
    assign sda = (sda_en) ? sda_data : 1'bz;

    i2c_slave i2cs0(
        .SDA (sda),
        .SCL (scl)
    );

    task tick;
    begin
        scl = ~scl;
    end
    endtask

    task tick2;
    begin
        scl = 0; 
        #1 ;
        scl = 1; 
        #1 ;
    end
    endtask

    initial begin
        $dumpfile("i2c_slave.vcd");
        $dumpvars();
        scl=1;
        sda_en=1;
        sda_data=1;
    end

    initial #30 $finish;

    // Sim master signal
    initial begin

        #1 ; // Better looking of waveform
        sda_data = 0; // START 
        #1 ; // delay #1 to start transmission
        sda_data = 0; tick2; // ADDR 7 (set value at low SCL, and gen a whole SCL cycle)
        sda_data = 1; tick2; // ADDR 6
        sda_data = 0; tick2; // ADDR 5
        sda_data = 0; tick2; // ADDR 4
        sda_data = 1; tick2; // ADDR 3
        sda_data = 1; tick2; // ADDR 2
        sda_data = 1; tick2; // ADDR 1
        sda_data = 1; tick2; // READ
        sda_en = 0; sda_data = 0; tick2; // hand over control of SDA, wait ACK
        sda_en = 1; tick2; // take back control of SDA
        #0.5 sda_data = 0; #0.5 sda_data = 1; // STOP
    end
endmodule