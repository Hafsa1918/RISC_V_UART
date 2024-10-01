module tb_risc_uart();

reg clk, clk_d,reset;
wire data_tx;
wire [7:0] data_out_rx;

riscv_uart dut(clk,clk_d,reset,data_tx, data_out_rx);

initial
clk=0;

initial
clk_d=0;

always #1 clk=~clk;  //clock to generate baud clock
always #8000 clk_d = ~clk_d;  // clock for RISC-V processor

initial 
begin
 reset = 1; 
 #5;
 reset = 0;
end

endmodule 
