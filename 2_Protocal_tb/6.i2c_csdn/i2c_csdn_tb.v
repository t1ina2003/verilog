`include "i2c_csdn.v"
`timescale 1ns / 1ps
module test(
sda
);
 
	reg	scl;
	inout sda;
	reg	sda_out;
	wire	sda_in;
	reg	[7:0]	data;
	
	reg start_flag, stop_flag;
	
	assign sda = sda_out ? 1'bz : 1'b0;
	assign sda_in = sda;
	pullup( sda );
	
	
	I2CTEST testmine(.SDA(sda), .SCL(scl));
 
    initial begin
        $dumpfile("i2c_csdn_tb.vcd");
        $dumpvars();
    end

    initial begin
        #100000 $finish;
    end

	initial
		begin
		   scl = 0;
			sda_out = 0;
			data = 8'h27;
			start_flag = 0;
			#160;
			start ( );
		end
	
	always 
	begin
	   #500 scl = ~scl;
   end
   	
	always @ (posedge start_flag)
	begin
	   repeat (8)
	      begin
	         wait ( scl == 0 );
				#200;
				sda_out = data[7];
				#400;
				data = data << 1;
			end
			wait (~ scl);
			#200;
			sda_out = 1;
			#1600;
			stop ( );
	end 
	
	always @ ( posedge stop_flag)
	begin
//	   sda_out = 0;
//	   #500;
	   sda_out = 1;
	end   
	
	task start;   
	begin
		wait (scl == 0);
		#200;
		sda_out = 1;
		wait ( scl == 1 );
		#200;
		sda_out = 0;
		start_flag = 1;
	end
	endtask
		
	task stop;
	begin
		wait ( scl == 0 );
		#200;
		sda_out = 0;
		wait ( scl ==1 );
		#200;
		sda_out = 1;
		stop_flag = 1;
		end
	endtask
		
endmodule

