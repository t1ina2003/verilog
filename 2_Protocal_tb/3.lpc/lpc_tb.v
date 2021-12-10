`include "lpc.v"
`default_nettype none

module tb_lpc;
reg clk = 0;
reg rst_n;

reg sel = 1;
reg [3:0] data = 4'hf;
inout [3:0] lpc_data;
assign lpc_data = sel ? data : 4'bZ;

reg lpc_frame = 1;
wire [7:0] tx_data;
wire tx_data_valid;
reg [7:0] rx_data;
reg rx_data_valid;
reg tx_busy = 0;

reg [7:0] read_data;

lpc lpc0
(
	.lpc_clk(clk),
	.lpc_rst(rst_n),
	.lpc_data(lpc_data),
	.lpc_frame(lpc_frame),
	.tx_data(tx_data),
	.tx_data_valid(tx_data_valid),
	.rx_data(rx_data),
	.rx_data_valid(rx_data_valid),
	.tx_busy(tx_busy)
);



initial begin
    $dumpfile("lpc_tb.vcd");
    $dumpvars(0, tb_lpc);
end

task tick;
    begin
	# 1 clk = 1;
	# 1 clk = 0;
    end
endtask

task lpc_write;
    begin
    sel = 1;
    lpc_frame<=0;
    data<=0;
    tick;
    lpc_frame<=1;
    data<=2;
    tick;
    data<=4'h0;
    tick;
    data<=4'h3;
    tick;
    data<=4'hf;
    tick;
    data<=4'hd;
    tick;
    data<=4'hB;
    tick;
    data<=4'hA;
    tick;
    sel = 0;
    end
endtask

task lpc_read;
input [15:0] port;
output [7:0] read_value;
begin
    sel <= 1;
    // START
    lpc_frame<=0;
    data<=0;
    tick;
    // CTDIR
    lpc_frame<=1;
    data<=0;
    tick;
    // ADDR0
    data<=port[15:12];
    tick;
    // ADDR1
    data<=port[11:8];
    tick;
    // ADDR2
    data<=port[7:4];
    tick;
    // ADDR3
    data<=port[3:0];
    tick;
    // TAR0
    sel <= 0;
	tick;
	// SYNC
	tick;
    // DATA0
    tick;
    read_value[3:0] <= lpc_data;
    // DATA1
    tick;
    read_value[7:4] <= lpc_data;
    sel <= 1;
    // TAR1
    tick;
end    
endtask

initial begin
    rst_n<=1;
    tick;
    rst_n<=0;
    tick;
    rst_n<=1;
    lpc_read (16'h3fd, read_data);
    repeat(2) tick;
    
    $finish(2);
end

endmodule
`default_nettype wire

