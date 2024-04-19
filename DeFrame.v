module DeFrame(
input reset,
input rx_flag,
input [10:0] data_parallel,

output reg parity_bit,
output reg start_bit,
output reg stop_bit,
output reg done_flag,
output reg [7:0] raw_data
);

always @ (*)
begin

	if (reset)
	begin
		raw_data <= {8{1'b1}};
		parity_bit <= 1'b1;
		start_bit <= 1'b0;
		stop_bit <= 1'b1;
		done_flag <= 1'b1;
	end

	else
		begin
		if (rx_flag)
		begin
			raw_data <= data_parallel[8:1];
			parity_bit <= data_parallel[9];
			start_bit <= data_parallel[0];
			stop_bit <= data_parallel[10];
			done_flag <= 1'b1;
		end

		else 
		begin
			raw_data <= {8{1'b1}};
			parity_bit <= 1'b1;
			start_bit <= 1'b0;
			stop_bit <= 1'b1;
			done_flag <= 1'b0;
		end
	end
end

endmodule 