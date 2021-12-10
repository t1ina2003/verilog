module diff (
    input d,
    input clk,
    input rstn,
    output reg q,
    output qn
);
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            q <= 0;
        else
            q <= d;
    end    
    assign qn= ~q;
endmodule

module ripCounter (
    input clk,
    input rstn,
    output [3:0] out
);
    wire q0,q1,q2,q3;
    wire qn0,qn1,qn2,qn3;

    diff d0(.d(qn0),.clk(clk),.rstn(rstn),.q(q0),.qn(qn0));
    diff d1(.d(qn1),.clk(q0),.rstn(rstn),.q(q1),.qn(qn1));
    diff d2(.d(qn2),.clk(q1),.rstn(rstn),.q(q2),.qn(qn2));
    diff d3(.d(qn3),.clk(q2),.rstn(rstn),.q(q3),.qn(qn3));

    assign out = {qn3,qn2,qn1,qn0};
endmodule


module tb_;
reg clk;
reg rstn;
wire [3:0] out;

ripCounter rc(
    .rstn (rstn),
    .clk (clk),
    .out(out)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("02_rippleCounter.vcd");
    $dumpvars(0, rc);
end

initial begin
    rstn <= 0;
    clk <= 0;
    repeat (4) @ (posedge clk);
    rstn <= 1;
    repeat (25) @ (posedge clk);
    $finish;
end

endmodule