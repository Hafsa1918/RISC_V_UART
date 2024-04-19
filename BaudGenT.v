module BaudGenT(
input reset,
input clk,
input [1:0] baud_rate,

output reg baud_clk
);

reg [14:0] clk_ticks;
reg [14:0] final_value;

localparam  BAUD24 = 2'b00,
				BAUD48 = 2'b01,
				BAUD96 = 2'b10,
				BAUD192 = 2'b11;
				
always @ (baud_rate)
begin
case (baud_rate)
	BAUD24: final_value = 14'd5208; //10417
	BAUD48: final_value = 14'd2604;	//5208
	BAUD96: final_value = 14'd1302;	//2604
	BAUD192:final_value = 14'd651;	//1302
	default: final_value = 14'd0;
endcase
end

always @ (posedge reset, posedge clk)
begin
	if(reset)
	begin 
	clk_ticks <= 14'd0;
	baud_clk <= 1'b0;
	end

	else 
	begin
		if (clk_ticks == final_value)
		begin
		clk_ticks <= 14'd0;
		baud_clk <= ~baud_clk;
		end

		else
		begin
		clk_ticks <= clk_ticks +1'd1;
		//baud_clk <= baud_clk;
		end

	end
end
endmodule
