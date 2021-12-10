module half_adder_tb;
// iverilog -o .\00_halfAdder.vvp .\00_halfAdder_tb.v .\00_halfAdder.v
// vvp .\00_halfAdder.vvp
    reg x,y;
    wire s,c;

    initial begin
        $dumpfile("00_half_adder.vcd");
        $dumpvars(0,h);
        $monitor("x = %b, y = %b | s = %b, c = %b ", x, y,s,c);
        #50 x=1'b0; y=1'b0;
        #50 x=1'b0; y=1'b1;
        #50 x=1'b1; y=1'b0;
        #50 x=1'b1; y=1'b1;
        #50 $finish;
    end

    half_adder h(x,y,s,c);
endmodule