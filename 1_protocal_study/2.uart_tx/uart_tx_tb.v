`timescale 1ns / 1ps
`include "uart_tx.v"

module uart_tx_tb();
reg clk;
reg [7:0]data;
reg data_valid;
wire tx,busy;

uart_tx ut(.clk(clk),.tx(tx),.data(data),.data_valid(data_valid),.busy(busy));

initial begin
    $dumpfile("uart_tx_tb.vcd");
    $dumpvars(0,ut);
    clk = 0;
    data = 0;
    data_valid = 0;
end

always #0.5 clk = ~clk;
initial begin
    #100 data_valid=1; 
    #80 data=123;
    #50 data_valid=0;
end
initial #3500 $finish;
    
endmodule