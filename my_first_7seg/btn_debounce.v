// ============================================================
// File Name: btn_debounce.v
// Megafunction Name(s):
// 			BTN_DEBOUNCE
//
// File Function:
//     process button press bounce signal, and give out one shot signal
// ============================================================

module btn_debounce
       #(
           parameter COUNT_NUM = 5000
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

localparam IDLE             = 0; // wait for button press
localparam PRESS            = 1; // check button press, start count, fire after enough count
localparam FIRE             = 2; // fire signal and wait for btn release
localparam RELEASE          = 3; // check button release, start count, back to WAIT_PRESS after enough count

// Moore FSM
reg [1:0]  curr_state       = IDLE;
reg [1:0]  next_state;
reg [25:0]  count;

// Moore FSM: state reg
always @(posedge iClk or negedge iRst_n)
    curr_state  <= (!iRst_n) ? IDLE : next_state;

// Moore FSM: next state logic
always @(*) begin
    case (curr_state)
        IDLE:           next_state = (!iBtn_n) ? PRESS : IDLE;
        PRESS:          next_state = (count > COUNT_NUM - 1) ? FIRE : PRESS ;
        FIRE:           next_state = RELEASE;
        RELEASE:        next_state = (count > COUNT_NUM - 1) ? IDLE : RELEASE ;
        default:        next_state = IDLE;
    endcase
end

// Moore FSM: output logic
always @(posedge iClk) begin
    case (curr_state)
        IDLE: begin
            count <= 0;
            oBtn <= 0;
        end

        PRESS: begin
            oBtn <= 0;
            count <= (!iBtn_n) ? count + 1 : 25'b0;
        end

        FIRE: begin
            count <= 0;
            oBtn <= 1;
        end

        RELEASE: begin
            oBtn <= 0;
            count <= (iBtn_n) ? count + 1 : 25'b0;
        end
    endcase
end


assign oState = curr_state; // DEBUG

endmodule
