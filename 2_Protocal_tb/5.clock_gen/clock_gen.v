/*
 * Clock genrator from chipverify.com.
 * 
 * Functionality: 
 * it allows different blocks to be in sync with each other.
 * 
 *
 * Properties:
 * FREQ     how many cycles can be found in 1 sec.
 * PHASE    start time can be shifted by 0,90,180,270,360 deg.
 * DUTY     The amount of time the clock is high compared to its time period.
 * 
 * All copyright reserved to chipverify.com.
 */
`timescale 1ns/1ps

module clock_gen
#(
    parameter FREQ = 100000,
    parameter PHASE = 0,
    parameter DUTY = 50
)
(
    input enable,
    output reg clk
);
    real clk_on,clk_off,quarter,start_dly;
    real clk_pd = 1.0/(FREQ * 1e3) * 1e9;

    always @(*) begin
        clk_on = DUTY/100.0 * clk_pd;
        clk_off = (100.0 - DUTY)/100.0 * clk_pd;
        quarter = clk_pd/4;
        start_dly = quarter * PHASE/90;
    end

    reg start_clk;

    initial begin
        $display("FREQ          =   %0d kHz",FREQ);
        $display("PHASE         =   %0d deg",PHASE);
        $display("DUTY          =   %0d %%",DUTY);

        $display("PERIOD        =   %0.3f ns",clk_pd);
        $display("CLK_ON        =   %0.3f ns",clk_on);
        $display("CLK_OFF       =   %0.3f ns",clk_off);
        $display("QUARTER       =   %0.3f ns",quarter);
        $display("START_DLY     =   %0.3f ns",start_dly);
    end

    initial begin
        clk <= 0;
        start_clk <= 0;
    end

    // when clock is enabled, delay driving the clock to one in order
    // to achieve the phase effect. start_dly is configured to the 
    // correct delay dir the configurated phase. when enable is 0,
    // allow enough time to complete the current clock period
    always @(posedge enable or negedge enable) begin
        if (enable) begin
            #(start_dly) start_clk = 1;
        end
        else begin
            #(start_dly) start_clk = 0;
        end
    end

    // achieve duty cycle by a skewed clock on/off time and let this 
    // run as long as the clocks are turned on.
    always @(posedge start_clk) begin
        if (start_clk) begin
            clk = 1;
            
            while (start_clk) begin
                #(clk_on) clk = 0;
                #(clk_off) clk = 1;
            end

            clk = 0;
        end
    end
endmodule

module tb;
wire clk_50M,clk_250ms;
reg enable;
integer i,dly;

clock_gen #(.FREQ(50000)) 
cg1 (
    .enable (enable),
    .clk (clk_50M)
);
clock_gen #(.FREQ(4)) 
cg2 (
    .enable (enable),
    .clk (clk_250ms)
);

initial begin
    $dumpfile("clock_gen.vcd");
    $dumpvars;
end

initial begin
    enable <= 0;
    #10 enable <= 1;
    // for (i=0; i<10; i = i + 1) begin
    //     dly = $random;
    //     #(dly) enable <= ~enable;
    //     #50;
    // end
    #500 $finish;
end

endmodule