module uart(

input reset,
input send,									// an enable to starting sending data 
input clk,
input [1:0] parity_type, baud_rate,
input [7:0] data_in,
input data_rx,

output tx_active_flag, tx_done_flag,
output rx_active_flag, rx_done_flag,
output data_tx,
output [7:0] data_out,
output [2:0] error_flag
);

transmitter tx(
.reset(reset),
.send(send),
.clk(clk),
.parity_type(parity_type),
.baud_rate(baud_rate),
.data_in(data_in),

.data_tx(data_tx),
.active_flag(tx_active_flag),
.done_flag(tx_done_flag)
);

receiver rx(
.reset(reset),
.clk(clk),
.parity_type(parity_type),
.baud_rate(baud_rate),
.data_rx(data_rx),
.data_out(data_out),
.error_flag(error_flag),
.active_flag(rx_active_flag),
.done_flag(rx_done_flag)
);


endmodule
