// ============================================================
// File Name: switch_debounce.v
// Megafunction Name(s):
// 			SWITCH_DEBOUNCE
//
// File Function:
//     process switch bounce signal, and give out one/zero signal
// ============================================================

module switch_debounce
       #(
           parameter COUNT_NUM = 5
           // Debounce time equal to Clk time 20ns (for 50MHz) * COUNT_NUM
           // higher COUNT_NUM value for longer response time
       )
       (
           input iClk,
           input iRst_n,
           input iBtn_n,
           output reg oBtn,
           output [1:0] oState
       );

localparam NONE             = 0; // wait for button press
localparam ONE              = 1; // check button press, start count, fire after enough count
localparam ZERO             = 2; // check button release, start count, back to WAIT_PRESS after enough count

// Moore FSM
reg [1:0]   curr_state       = NONE;
reg [1:0]   next_state;
reg [25:0]  one_count = 0;
reg [25:0]  zero_count = 0;

// Moore FSM: state reg
always @(posedge iClk or negedge iRst_n)
    curr_state  <= (!iRst_n) ? NONE : next_state;

// Moore FSM: next state logic
always @(*) begin
    case (curr_state)
        NONE: begin
            if (one_count > COUNT_NUM - 1) next_state = ONE;
            else if (zero_count > COUNT_NUM - 1) next_state = ZERO;
            else next_state = curr_state;
        end
        ONE:            next_state = (!iBtn_n) ? NONE : curr_state ;
        ZERO:           next_state = (iBtn_n) ? NONE : curr_state;
        default:        next_state = NONE;
    endcase
end

// Moore FSM: output logic
always @(posedge iClk) begin
    case (curr_state)
        NONE: begin
            oBtn <= oBtn;
            if (iBtn_n)  one_count <= one_count + 1;
            else zero_count <= zero_count + 1;
        end

        ONE: begin
            one_count <= 0;
            zero_count <= 0;
            oBtn <= 1;
        end

        ZERO: begin
            zero_count <= 0;
            oBtn <= 0;
        end
    endcase
end


assign oState = curr_state; // DEBUG

endmodule
