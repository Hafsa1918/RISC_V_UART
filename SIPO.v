module SIPO(
input reset,
input data_rx,
input baud_clk,

output reg active_flag,
output reg rx_flag,
output reg [10:0] data_parallel
);

reg [3:0] frame_counter;
reg [3:0] stop_count;
reg [1:0] next_state;

localparam   IDLE   = 2'b00,
				 CENTER = 2'b01,
				 FRAME  = 2'b10,
				 HOLD   = 2'b11;
				 
always @ (posedge baud_clk, posedge reset)
begin
if (reset)
		next_state <= IDLE;
	else
	begin
		case (next_state)
		IDLE:
			begin
				data_parallel <= {11{1'b1}};
				active_flag   <= 1'b0;
				rx_flag       <= 1'b0;
				stop_count    <= 4'd0;
				frame_counter <= 4'd0;
				
				if (~data_rx)
				begin
					next_state  <= CENTER;
					active_flag <= 1'b1;
				end
				else
				begin
					next_state  <= IDLE;
					active_flag <= 1'b0;
				end
			end
		CENTER:
			begin
			if (&stop_count[2:0])
				begin
				data_parallel   <= data_rx;
				stop_count      <= 4'd0;
				next_state      <= FRAME;
				end
			else
				begin
				stop_count      <= stop_count + 4'd1;
				next_state      <= CENTER;
				end
			end
		FRAME:
			begin
			if (frame_counter[1] && frame_counter[3])
				begin
				frame_counter   <= 4'd0;
				next_state      <= HOLD;
				active_flag     <= 1'b0;
				rx_flag         <= 1'b1;
				end
			else
				begin
				if (stop_count[3:0])
					begin
					data_parallel[frame_counter + 4'd1]   <= data_rx;
					frame_counter   							  <= frame_counter + 4'd1;
				   next_state   							     <= FRAME;
					stop_count                            <= 4'd0;
					end
				else
					begin
					stop_count      <= stop_count + 4'd1;
					next_state      <= FRAME;
					end
				end
			end
		HOLD:
			begin
			if (&stop_count[3:0])
				begin
				data_parallel   <= data_parallel;
				frame_counter   <= 4'd0;
				next_state      <= IDLE;
				stop_count      <= 4'd0;
				rx_flag         <= 1'b0;
				end
			else
				begin
				stop_count      <= stop_count + 4'd1;
				next_state      <= HOLD;
				end
			end
		default:
			next_state        <= IDLE;
		endcase
	end
end
endmodule 