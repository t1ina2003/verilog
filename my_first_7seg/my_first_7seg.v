// ============================================================
// File Name: my_first_7seg.v
// Megafunction Name(s):
// 			MY_FIRST_7SEG
//
// File Function:
//     Main controller of program, function as below:
// 1. Receive button pulse from debounce module
// 2. Judge state of 7-segment-display gaming
// 3. Send out enable of 7-segment-display
// 4. Increase 7-segment-display's speed if game is over.
// ============================================================
module my_first_7seg(
           iClk,
           iRst_n,
           iKEY0_N,
           iDEBUG_PIN,
           HEX0,
           HEX1,
           HEX2,
           HEX3,
           HEX4,
           HEX5,
           LED0,
           LED1,
           LED2,
           owBtn,
           oHex_en
       );
input iClk          /* synthesis chip_pin = "AA16" */;
input iRst_n        /* synthesis chip_pin = "AA15" */;
input iKEY0_N        /* synthesis chip_pin = "AA14" */;
input iDEBUG_PIN     /* synthesis chip_pin = "AB12" */;
output [6:0] HEX0   /* synthesis chip_pin = "AH28, AG28, AF28, AG27, AE28, AE27, AE26" */;
output [6:0] HEX1   /* synthesis chip_pin = "AD27, AF30, AF29, AG30, AH30, AH29, AJ29" */;
output [6:0] HEX2   /* synthesis chip_pin = "AC30, AC29, AD30, AC28, AD29, AE29, AB23" */;
output [6:0] HEX3   /* synthesis chip_pin = "AB22, AB25, AB28, AC25, AD25, AC27, AD26" */;
output [6:0] HEX4   /* synthesis chip_pin = "W25, V23, W24, W22, Y24, Y23, AA24" */;
output [6:0] HEX5   /* synthesis chip_pin = "AA25, AA26, AB26, AB27, Y27, AA28, V25" */;
output LED0         /* synthesis chip_pin = "V16" */;
output LED1         /* synthesis chip_pin = "W16" */;
output LED2         /* synthesis chip_pin = "V17" */;
output owBtn        /* synthesis chip_pin = "V18" */;
output [5:0] oHex_en;

localparam TIMER_DEFAULT    =  32'd10000000; // 100 for SIM (DEBUG), 10000000 for real case.
// localparam TIMER_DEFAULT    =  32'd100000000; // 100 for SIM (DEBUG), 10000000 for real case.
localparam TIMER_DECREASE   =  32'd1000000; // 10 for SIM (DEBUG), 1000000 for real case.
// localparam TIMER_DECREASE   =  32'd10000000 ; // 10 for SIM (DEBUG), 1000000 for real case.
localparam BUTTON_COUNT     =  5000         ; // 5 for SIM (DEBUG), 5000 for real case.
// localparam BUTTON_COUNT     =  5000         ; // 5 for SIM (DEBUG), 5000 for real case.

// input decimal number
reg [3:0] iNUM = 4'd0;

// 7-seg change timer
reg [31:0] timer = {32{1'b0}};
reg [31:0] timer_end = TIMER_DEFAULT;

wire wBtn; // button input from btn_debounce to seven_seg_all
wire wAllDisabled; // if all number stopped, timer will speed up!

always @(posedge iClk)
begin
	timer_end <= (!iRst_n && wAllDisabled ) ? timer_end - TIMER_DECREASE : TIMER_DEFAULT; // if all number stopped, timer will speed up!
    timer <= (timer == timer_end) ? 0 : timer + 1; 
    iNUM <= (timer == timer_end) ? iNUM + 4'd1 : iNUM; 
end

btn_debounce #(
    .COUNT_NUM ( BUTTON_COUNT ))
u_btn_debounce (
    .iClk     ( iClk  ),
    .iRst_n   ( iRst_n  ),
    .iBtn_n   ( iKEY0_N  ),
    .oBtn     ( wBtn  ),
    .oState     ( {LED2,LED1,LED0}  )
);

seven_seg_all  u_seven_seg_all (
    .iClk     ( iClk    ),
    .iRst_n   ( iRst_n  ),
    .iBtn     ( wBtn	),  
    .iNum     ( iNUM	),
    .oHex     ( {HEX5,HEX4,HEX3,HEX2,HEX1,HEX0} ),
	.oAllDisabled ( wAllDisabled ),
    .oHex_en (oHex_en) //DEBUG
);

assign owBtn = wBtn; //DEBUG

endmodule
