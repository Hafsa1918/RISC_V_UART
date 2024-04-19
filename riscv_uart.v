module riscv_uart( 
input clkR,clkI,reset, 
//input data_rx, 
input [1:0] baud_rate,parity_type,
output data_tx,
output [7:0] data_out
);

wire [31:0] Addr,RdM,WriteData,ReadData;                                //riscv    
wire [31:0] read_data;                    					                 		//memory
wire WEM,WEI,Rd_sel; 																		                //Address decoder
wire tx_active_flag,tx_done_flag,rx_done_flag, rx_active_flag;					//UART
wire [2:0] error_flag;																		              //UART
wire [7:0] data_in;																			                //UART
wire [1:0] immsrc;                                                      //riscv
wire resultsrc,alusrc,regwrite,pcsrc;                                   //riscv

risc_V riscv(
.clk(clkR),
.reset(reset),
.ReadData(ReadData),
.resultsrc(resultsrc),
.memwrite(memwrite),
.alusrc(alusrc),
.regwrite(regwrite),
.pcsrc(pcsrc),
.immsrc(immsrc),
.Addr(Addr),
.WriteData(WriteData)
);

address_decoder addr_decode(
.memWrite(memwrite),
.Addr(Addr),
.WEM(WEM),
.WEI(WEI),
.Rd_sel(Rd_sel)
);

datamem DM(
.mem_addr(Addr),
.write_data(WriteData),
.clk(clkR),
.memwrite(WEM),
.read_data(RdM)
);
 
uart interface_uart(
.reset(reset),
.send(WEI),
.clk(clkI),
.parity_type(parity_type),
.baud_rate(baud_rate),
.data_in(data_in),
.data_rx(data_tx),
.tx_active_flag(tx_active_flag),
.tx_done_flag(tx_done_flag),
.rx_active_flag(rx_active_flag),
.rx_done_flag(rx_done_flag),
.data_tx(data_tx),
.data_out(data_out),
.error_flag(error_flag)
);

Reg_IO io(
.WEI(WEI),
.clk(clkI),
.WriteData(WriteData[7:0]),
.out(data_in)
);

mux mmio(
.m(RdM),
.n({{24{1'b0}},data_out}),
.sel(Rd_sel),
.out(read_data)
);

mux result_0(
.m(Addr),
.n(read_data),
.sel(resultsrc),
.out(ReadData)
);

endmodule
