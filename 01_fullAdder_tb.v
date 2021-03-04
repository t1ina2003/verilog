module full_adder_tb;
// iverilog -o 01_fullAdder.vvp .\01_fullAdder_tb.v .\01_fullAdder.v .\00_halfAdder.v
// vvp .\01_fullAdder.vvp
    reg x,y,z;
    wire s,c;

    initial begin
        $dumpfile("01_fullAdder.vcd");
        $dumpvars(0,f);
        $monitor("x = %b, y = %b, z=%b | s = %b, c = %b ", x, y, z, s, c);
        #50 x=1'b0; y=1'b0; z=1'b0;
        #50 x=1'b0; y=1'b0; z=1'b1;
        #50 x=1'b0; y=1'b1; z=1'b0;
        #50 x=1'b0; y=1'b1; z=1'b1;
        #50 x=1'b1; y=1'b0; z=1'b0;
        #50 x=1'b1; y=1'b0; z=1'b1;
        #50 x=1'b1; y=1'b1; z=1'b0;
        #50 x=1'b1; y=1'b1; z=1'b1;
        #50 $finish;
    end

    full_adder f(x,y,z,s,c);
endmodule