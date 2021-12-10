module full_adder (
    x,y,z,s,c
);
    input x,y,z;
    output s,c;
    wire hs,hc,tc;
    half_adder ha1(x,y,hs,hc);
    half_adder ha2(hs,z,s,tc);
    or(c,tc,hc);
endmodule