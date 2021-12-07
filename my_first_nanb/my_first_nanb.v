module my_first_nanb (
           iClk,
           iRst_n,
           iKEY0_N,
           sw0,
           sw1,
           sw2,
           sw3,
           sw4,
           sw5,
           sw6,
           sw7,
           sw8,
           sw9,
           HEX0,
           HEX1,
           HEX2,
           HEX3,
           HEX4,
           HEX5,
           LED0,
           LED1,
           LED2,
           LED3,
           LED4
       );
input iClk          /* synthesis chip_pin = "AA16" */;
input iRst_n        /* synthesis chip_pin = "AA15" */;
input iKEY0_N        /* synthesis chip_pin = "AA14" */;
input sw0           /* synthesis chip_pin = "AB12" */;
input sw1           /* synthesis chip_pin = "AC12" */;
input sw2           /* synthesis chip_pin = "AF9 " */;
input sw3           /* synthesis chip_pin = "AF10" */;
input sw4           /* synthesis chip_pin = "AD11" */;
input sw5           /* synthesis chip_pin = "AD12" */;
input sw6           /* synthesis chip_pin = "AE11" */;
input sw7           /* synthesis chip_pin = "AC9 " */;
input sw8           /* synthesis chip_pin = "AD10" */;
input sw9           /* synthesis chip_pin = "AE12" */;
output [6:0] HEX0   /* synthesis chip_pin = "AH28, AG28, AF28, AG27, AE28, AE27, AE26" */;
output [6:0] HEX1   /* synthesis chip_pin = "AD27, AF30, AF29, AG30, AH30, AH29, AJ29" */;
output [6:0] HEX2   /* synthesis chip_pin = "AC30, AC29, AD30, AC28, AD29, AE29, AB23" */;
output [6:0] HEX3   /* synthesis chip_pin = "AB22, AB25, AB28, AC25, AD25, AC27, AD26" */;
output [6:0] HEX4   /* synthesis chip_pin = "W25, V23, W24, W22, Y24, Y23, AA24" */;
output [6:0] HEX5   /* synthesis chip_pin = "AA25, AA26, AB26, AB27, Y27, AA28, V25" */;
output LED0         /* synthesis chip_pin = "V16" */;
output LED1         /* synthesis chip_pin = "W16" */;
output LED2         /* synthesis chip_pin = "V17" */;
output LED3         /* synthesis chip_pin = "V18" */;
output LED4         /* synthesis chip_pin = "W17" */;

reg [9:0] input_array;
wire [9:0] output_array;
wire wBtn; // button input from btn_debounce to seven_seg_all
assign output_array_temp = output_array;

// genvar i;
// generate
//     for (i = 0; i<10; i=i+1)begin: switch_debounce_array
//         switch_debounce #(
//                          .COUNT_NUM(5))
//                      u_switch_debounce(
//                          .iClk(iClk),
//                          .iRst_n(iRst_n),
//                          .iBtn_n(input_array[i]),
//                          .oBtn(output_array[i]),
//                          .oState()
//                      );
//     end
// endgenerate

btn_debounce #(
                 .COUNT_NUM ( 5000 ))
             u_btn_debounce (
                 .iClk     ( iClk  ),
                 .iRst_n   ( iRst_n  ),
                 .iBtn_n   ( iKEY0_N  ),
                 .oBtn     ( wBtn  )
             );

seven_seg_all  u_seven_seg_all (
                   .iClk    ( iClk    ),
                   .iRst_n  ( iRst_n  ),
                   .iBtn    ( wBtn	),
                   .iSwitch ( {sw9,sw8,sw7,sw6,sw5,sw4,sw3,sw2,sw1,sw0}	),
                   .oHex    ( {HEX5,HEX4,HEX3,HEX2,HEX1,HEX0} ),
                   .oLED    ( {LED4,LED3,LED2,LED1,LED0} ),
                   .oHex_en (oHex_en) //DEBUG
               );

endmodule
