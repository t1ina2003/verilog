// ============================================================
// File Name: seven_seg_all.v
// Megafunction Name(s):
// 			SEVEN_SEG_ALL
//
// File Function:
//      1 decimal to 6 hex 7-seg display.
//      input button signal to disable one 7-seg each time.
//
// ============================================================

module seven_seg_all (
           input iClk,
           input iRst_n,
           input iBtn,              // button signal to disable one 7-seg each time.
           input [3:0] iNum,
           output [41:0] oHex,
           output oAllDisabled,     // if all enable is 0, fire this.
           output [5:0] oHex_en
       );

wire [6:0] wHex;
reg [41:0] rHex = 42'b0;
reg [5:0] hex_en = 6'b111111; // 7-seg enable mask

// Implement 7 segment display
seven_seg  u_seven_seg0 (
               .iClk   ( iClk      ),
               .iRst_n ( iRst_n    ),
               .iNum   ( iNum      ),
               .oHex   ( wHex      )
           );

always @(posedge iClk or negedge iRst_n) begin
    if(!iRst_n) hex_en <= 6'b111111; // Reset logic
    else hex_en <= (iBtn) ? {1'b0,hex_en[5:1]} : hex_en; // Press button will shift 0 to MSB
end

always @(posedge iClk) begin
    // Use hex_en as mask of the output.
    rHex[6:0]   <= (hex_en[0]) ? wHex : rHex[6:0]   ;
    rHex[13:7]  <= (hex_en[1]) ? wHex : rHex[13:7]  ;
    rHex[20:14] <= (hex_en[2]) ? wHex : rHex[20:14] ;
    rHex[27:21] <= (hex_en[3]) ? wHex : rHex[27:21] ;
    rHex[34:28] <= (hex_en[4]) ? wHex : rHex[34:28] ;
    rHex[41:35] <= (hex_en[5]) ? wHex : rHex[41:35] ;
end

// Output mask register number to output.
assign oHex = {6{rHex}};
assign oAllDisabled = (hex_en == 6'b000000) ? 1 : 0;
assign oHex_en = hex_en;

endmodule
