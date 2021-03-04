module simple_tb;

   reg   A,B,CIN;

   wire  COUT,SUM;

   initial
     begin
        $dumpfile("simple.vcd");
        $dumpvars(0, s);
        $monitor("A = %b, B = %b CIN = %b | COUT = %b SUM = %b ", A, B,CIN,COUT,SUM);
        #50 A = 1'b0; B=1'b0;CIN=1'b0;
        #50 A = 1'b0; B=1'b1;CIN=1'b0;
        #50 A = 1'b1; B=1'b0;CIN=1'b0;
        #50 A = 1'b1; B=1'b1;CIN=1'b0;
        #50 A = 1'b0; B=1'b0;CIN=1'b1;
        #50 A = 1'b0; B=1'b1;CIN=1'b1;
        #50 A = 1'b1; B=1'b0;CIN=1'b1;
        #50 A = 1'b1; B=1'b1;CIN=1'b1;
        #50 $finish;
     end

   simple s(A, B,CIN,COUT,SUM);

endmodule