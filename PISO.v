module PISO(
input reset,
input send,
input baud_clk,
input [7:0] data_in,
input [1:0] parity_type,
input parity_bit,

output reg data_tx,
output reg active_flag,
output reg done_flag 
);

reg [3:0] stop_count;
reg [10:0] frame;
reg [10:0] frame_r;
reg [7:0] data;
reg next_state;

localparam  IDLE   = 1'b0,
				ACTIVE = 1'b1;

always @ (negedge next_state) 
begin
	if (~next_state)				
		data <= data_in;
	else
		data <= data;
end				
			
always @ (data, parity_type, parity_bit)
begin
	if ((~|parity_type) || (&parity_type))
		frame = {2'b11,data,1'b0};
	else
		frame = {1'b1,parity_bit,data,1'b0};
end

always @ (posedge baud_clk, posedge reset)
begin
	if (reset)
		next_state <= IDLE;
	else
	begin
		frame_r <= frame;
		case (next_state)
		IDLE:
			begin
			data_tx		<= 1'b1;
			active_flag <= 1'b0;
			done_flag   <= 1'b1;
			stop_count  <= 4'd0;
			
			if (send)
			next_state  <= ACTIVE;
			else
			next_state  <= IDLE;
			end
		ACTIVE:
			begin
			if(stop_count[3] && stop_count[1] && stop_count[0])
				begin
				data_tx		<= 1'b1;
				active_flag <= 1'b0;
				done_flag   <= 1'b1;
				stop_count  <= 4'd0;
				next_state  <= IDLE;
				end
			else
				begin
				data_tx     <= frame_r[0];
				frame_r     <= frame_r >> 1;
				active_flag <= 1'b1;
				done_flag   <= 1'b0;
				stop_count  <= stop_count + 4'd1;
				next_state  <= ACTIVE;
				end
			end
		default: 
			next_state     <= IDLE;
		endcase
	end
end		
endmodule 