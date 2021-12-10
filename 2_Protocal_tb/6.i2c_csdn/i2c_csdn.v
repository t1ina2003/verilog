
`timescale 1ns / 1ps
module I2CTEST(
SDA, SCL
);
 
input SCL;
inout SDA;
 
// The 7-bits address that we want for our I2C slave
parameter I2C_ADR = 7'h13;
 
//---------------------------------------------
//start,stop condition judgement
//---------------------------------------------
wire start, stop;
reg sda1, sda2;
reg sda11;
 
always @ ( posedge SCL )
sda1 <= SDA;
always @ ( negedge SCL )
sda2 <= SDA;
always @ ( negedge SCL )
sda11 <= sda1;
assign start = sda11 & (!sda2);
assign stop = sda2 & ( !sda11 );
//----------------------------------------------
//count setting
//----------------------------------------------
reg [3:0]  bitcont;
wire bit_ack = bitcont[3];
always @ ( posedge SCL or posedge start)
begin
    if ( start )
    bitcont <=  4'h6;
    else
    begin
        if (bit_ack)
        bitcont <= 4'h6;
        else
        bitcont <= bitcont -4'h1;
    end
end
//-------------------------------------
//get sda using posedge scl
//-------------------------------------
reg sdar;
always @ ( posedge SCL ) sdar <= SDA;
//----------------------------------------
//address match
//----------------------------------------
reg addr_match, op_read;
always @ ( negedge SCL or posedge start )
begin
    if ( start )
    begin
        addr_match <= 1'h1;
        op_read <= 1'h0;
    end
    else
    begin
        if( (bitcont == 6) & (sdar != I2C_ADR[6])) addr_match <= 1'h0;
        if( (bitcont == 5) & (sdar != I2C_ADR[5])) addr_match <= 1'h0;
        if( (bitcont == 4) & (sdar != I2C_ADR[4])) addr_match <= 1'h0;
        if( (bitcont == 3) & (sdar != I2C_ADR[3])) addr_match <= 1'h0;
        if( (bitcont == 2) & (sdar != I2C_ADR[2])) addr_match <= 1'h0;
        if( (bitcont == 1) & (sdar != I2C_ADR[1])) addr_match <= 1'h0;
        if( (bitcont == 0) & (sdar != I2C_ADR[0])) addr_match <= 1'h0;
        if( bitcont == 0 ) op_read <= sdar;
    end
end
//-----------------------------------------------------------------------
//send ack
//-----------------------------------------------------------------------
reg ack_assert;
always @ ( negedge SCL )
begin
    if ( bit_ack & addr_match & op_read )
    ack_assert <= 1'h1;
    else
    ack_assert <= 1'h0;
end
//-------------------------------------------------------------------------
//control SDA line
//-------------------------------------------------------------------------
assign SDA = ack_assert ? 1'h0 : 1'hz;
pullup ( SDA );
endmodule

