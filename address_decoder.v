module address_decoder(
input memWrite,
input [31:0] Addr,

output reg WEM,
output reg WEI,
output reg Rd_sel);

localparam UART_base_address = 60;

always @ (*)
begin
if (UART_base_address == Addr && memWrite ==1)
begin
WEM=0; WEI=1; Rd_sel=1;
end

else if(UART_base_address == Addr && memWrite ==0)
begin
WEM=0; WEI=0; Rd_sel=1;
end

else if(UART_base_address != Addr && memWrite ==1)
begin
WEM=1; WEI=0; Rd_sel=0;
end

else if(UART_base_address != Addr && memWrite ==0)
begin
WEM=0; WEI=0; Rd_sel=0;
end

end

endmodule
