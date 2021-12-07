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
           input [9:0] iSwitch,
           output [41:0] oHex,
           output [4:0] oLED,     // if all enable is 0, fire this.
           output [5:0] oHex_en
       );

reg [41:0] rHex = {42{1'b1}};
reg [9:0] rXnor = 0;
reg [9:0] rXor = 0;
reg [9:0] rAnswer = 10'b1101010011;
reg [4:0] rTimes = 5'b11111;
reg rTimeEn = 0;
reg [31:0] rTimeCount = 0;
reg rTimeOut = 0;

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


function [3:0] fSum;
    input [9:0] inNum;
    integer i;
    begin
        for(i=0;i<10;i=i+1) begin
            if(inNum[i] == 1'b1)
                fSum = fSum +1;
        end
    end
endfunction

always @(posedge iClk or negedge iRst_n) begin

    if(!iRst_n) begin
        // Reset logic
        rHex <= {42{1'b1}};
        rTimes <= 5'b11111;
        rTimeEn <= 0;
        rTimeCount <= 0;
        rTimeOut <= 0;
    end
    else begin

        // Press button, check Answer!
        if (iBtn) begin
            rTimes = rTimes >> 1;
            rXor = rAnswer ^ iSwitch;
            rXnor = ~(rAnswer ^ iSwitch);
            if ( rTimes <= 0 ) rTimeEn = 1;
            else begin
                if ( fSum(rXnor) == 4'ha ) begin
                    rTimeEn = 1;
                    rTimes = 0;
                end
                rHex[6:0]   = fDecoder(11);
                rHex[13:7]  = fDecoder(fSum(rXor));
                rHex[20:14] = fDecoder(10);
                rHex[27:21] = fDecoder(fSum(rXnor));
            end

        end

        // Enable face emoji timer!
        if ( rTimeEn ) begin
            rTimeCount = rTimeCount + 1;
            if(rTimeCount > 100000000) rTimeOut = 1;
        end

        // Show face emoji!
        if( rTimeOut ) begin
            if( fSum(rXnor) == 4'ha) begin
                rHex[6:0]   = 7'b0000011;
                rHex[13:7]  = 7'b1011100;
                rHex[20:14] = 7'b1110111;
                rHex[27:21] = 7'b1110111;
                rHex[34:28] = 7'b1011100;
            end
            else begin
                rHex[6:0]   = 7'b0001100;
                rHex[13:7]  = 7'b0011100;
                rHex[20:14] = 7'b1110111;
                rHex[27:21] = 7'b1110111;
                rHex[34:28] = 7'b0011100;
            end
        end
    end
end


// Output mask register number to output.
assign oHex = {6{rHex}};
assign oLED= rTimes;


endmodule
