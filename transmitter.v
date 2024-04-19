module transmitter(
input reset,
input send,
input clk,
input [1:0] parity_type,
input [1:0] baud_rate,
input [7:0] data_in,

output data_tx,
output active_flag,
output done_flag
);

wire parity_bit;
wire baud_clk;

BaudGenT bg_unit(
.reset(reset),
.clk(clk),
.baud_rate(baud_rate),

.baud_clk(baud_clk)
);

parityT p_unit(
.reset(reset),
.data_in(data_in),
.parity_type(parity_type),

.parity_bit(parity_bit)
);

PISO shift_reg(
.reset(reset),
.send(send),
.baud_clk(baud_clk),
.data_in(data_in),
.parity_type(parity_type),
.parity_bit(parity_bit),

.data_tx(data_tx),
.active_flag(active_flag),
.done_flag(done_flag) 
);

endmodule
