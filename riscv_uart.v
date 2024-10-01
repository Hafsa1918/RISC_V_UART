module riscv_uart( 
input clk,clk_d,reset, 
output data_tx,
output [7:0] data_out_rx
);

wire [31:0] Addr,RdM,WriteData,ReadData;               
wire [31:0] read_data,uart_data;                    								//memory
wire WEM,WEId, WEIc, WEIs,Rd_sel; 														//Address decoder
wire [1:0] immsrc;
wire resultsrc,alusrc,regwrite,pcsrc, memwrite;
wire [7:0] data_in_d, data_in_c, data_rx;
wire [6:0] data_in_s;     
            
risc_V riscv(
.clk(clk_d),
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
.WEId(WEId),
.WEIc(WEIc),
.WEIs(WEIs),
.Rd_sel(Rd_sel)
);

datamem DM(
.mem_addr(Addr),
.write_data(WriteData),
.clk(clk_d),
.memwrite(WEM),
.read_data(RdM)
);
 
uart interface_uart(
.reset(reset),
.send(data_in_c[0]),
.clk(clk),
.parity_type(data_in_c[4:3]),
.baud_rate(data_in_c[2:1]),
.data_in(data_in_d),
.data_rx(data_tx),
.tx_active_flag(data_in_s[6]),
.tx_done_flag(data_in_s[5]),
.rx_active_flag(data_in_s[4]),
.rx_done_flag(data_in_s[3]),
.data_tx(data_tx),
.data_out(data_out_rx),
.error_flag(data_in_s[2:0])
);

Reg_IO io_data(
.WEI(WEId),
.clk(clk_d),
.WriteData(WriteData[7:0]),
.out(data_in_d)
);

Reg_IO io_ctrl(
.WEI(WEIc),
.clk(clk_d),
.WriteData(WriteData[7:0]),
.out(data_in_c)
);

mux mmio_D_S(
.m({{24{1'b0}},data_rx}),
.n({{25{1'b0}},data_in_s}),
.sel(WEIs),
.out(uart_data)
);

Reg_IO io_data_rx(
.WEI(~&data_in_s[2:0]),
.clk(data_in_s[3]),
.WriteData(data_out_rx),
.out(data_rx)
);

mux mmio(
.m(RdM),
.n(uart_data),
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
