module parityT(
input reset,
input [7:0] data_in,
input [1:0] parity_type,

output reg parity_bit
);

localparam  Odd = 2'b01,
				Even= 2'b10;
				
always @ (*)
begin
	if (reset)
	parity_bit <= 1'b1;
	else
		begin
			case (parity_type)
			Odd:  parity_bit <= (^data_in) ? 1'b0:1'b1;
			Even: parity_bit <= (^data_in) ? 1'b1:1'b0;
			endcase
		end
end
endmodule 