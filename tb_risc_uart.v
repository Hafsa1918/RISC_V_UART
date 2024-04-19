module tb_risc_uart();

reg clkR,clkI,reset,data_rx;
reg [1:0] baud_rate, parity_type; 
//wire resultsrc,memwrite,alusrc,regwrite,pcsrc;
wire data_tx;
//wire [1:0] immsrc;
wire [7:0] data_out;

riscv_uart dut(clkR,clkI,reset,data_rx,baud_rate, parity_type,data_tx, data_out);

always #1 clkI=~clkI;
always #13000 clkR=~clkR;
initial 
begin
 reset = 1;
 baud_rate=2'b11;
 parity_type=2'b10;
 #50;
 reset = 0;
 data_rx=1;
 #10000 data_rx=0;
#10000 data_rx=1;
 #10000 data_rx=0;
#10000 data_rx=1;
 //#1500 $stop;
end
initial
clkI=0;
initial
clkR=0;
endmodule 
