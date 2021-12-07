`timescale 1ns / 1ps
`include "uart_rx.v"

module uart_rx_tb();
reg clk,rx;
wire [7:0]data;
wire data_valid;

uart_rx ur(.clk(clk),.rx(rx),.data(data),.data_valid(data_valid));

initial begin
    $dumpfile("uart_rx_tb.vcd");
    $dumpvars(0,ur);
    clk = 0;
    rx = 1;
end

always #1 clk = ~clk;
initial begin
    #100 rx=0;
    #1 rx=1;
    #286 rx=1;
    #286 rx=1;
    #286 rx=0;
    #286 rx=1;
    #286 rx=0;
    #286 rx=1;
    #286 rx=0;
    #286 rx=1;
    #286 rx=1;
end
initial #3000 $finish;
    
endmodule