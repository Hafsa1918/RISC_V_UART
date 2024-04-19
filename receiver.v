module receiver(
input reset,
input data_rx,
input clk,
input [1:0] parity_type,
input [1:0] baud_rate,
output active_flag,
output done_flag,
output [2:0] error_flag,
output [7:0] data_out
);

wire baud_clk;
wire [10:0] data_parallel;
wire rx_flag;
wire par_bit;
wire start_bit;
wire stop_bit;

BaudGenR bg_unit(
.reset(reset),
.clk(clk),
.baud_rate(baud_rate),

.baud_clk(baud_clk)
);

SIPO shift_reg(
.reset(reset),
.data_rx(data_rx),
.baud_clk(baud_clk),

.active_flag(active_flag),
.rx_flag(rx_flag),				
.data_parallel(data_parallel)
);

DeFrame deframe_unit(
.reset(reset),
.rx_flag(rx_flag),
.data_parallel(data_parallel),

.parity_bit(par_bit),
.start_bit(start_bit),
.stop_bit(stop_bit),
.done_flag(done_flag), 
.raw_data(data_out)
);

ErrorCheck errorDetect(
.reset(reset),
.rx_flag(done_flag),	
.parity_bit(par_bit),
.start_bit(start_bit),
.stop_bit(stop_bit),
.parity_type(parity_type),
.raw_data(data_out),

.error_flag(error_flag)
);

endmodule
