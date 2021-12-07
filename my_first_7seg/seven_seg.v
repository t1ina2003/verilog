// ============================================================
// File Name: seven_seg.v
// Megafunction Name(s):
// 			SEVEN_SEG
//
// File Function:
//     Translate decimal number into 7 segment display binary code,
// 	mapping number 0-15 into 0-F.
//
// ============================================================

module seven_seg (
           input iClk,
           input iRst_n,
           input [3:0] iNum,
           output [6:0] oHex
       );

function [6:0] fDecoder;
    input [3:0] inNum;
    begin
        case (inNum)
            // 7-seg is low active
            7'd0: 	 fDecoder[6:0] = 7'b1000000; //0 -- 40h
            7'd1: 	 fDecoder[6:0] = 7'b1111001; //1 -- 79h
            7'd2: 	 fDecoder[6:0] = 7'b0100100; //2 -- 24h
            7'd3: 	 fDecoder[6:0] = 7'b0110000; //3 -- 30h
            7'd4: 	 fDecoder[6:0] = 7'b0011001; //4 -- 19h
            7'd5: 	 fDecoder[6:0] = 7'b0010010; //5 -- 12h
            7'd6: 	 fDecoder[6:0] = 7'b0000010; //6 -- 02h
            7'd7: 	 fDecoder[6:0] = 7'b1111000; //7 -- 78h
            7'd8: 	 fDecoder[6:0] = 7'b0000000; //8 -- 00h
            7'd9: 	 fDecoder[6:0] = 7'b0010000; //9 -- 10h
            7'd10:	 fDecoder[6:0] = 7'b0001000; //A -- 08h
            7'd11:	 fDecoder[6:0] = 7'b0000011; //b -- 03h
            7'd12:	 fDecoder[6:0] = 7'b1000110; //C -- 46h
            7'd13:	 fDecoder[6:0] = 7'b0100001; //d -- 21h
            7'd14:	 fDecoder[6:0] = 7'b0000110; //E -- 06h
            7'd15:	 fDecoder[6:0] = 7'b0001110; //F -- 0Eh
            7'd16:	 fDecoder[6:0] = 7'b0111111; //- -- 3Fh
            default: fDecoder[6:0] = 7'b1111111; // all - 7F
        endcase
    end
endfunction

assign oHex = fDecoder(iNum);

endmodule
