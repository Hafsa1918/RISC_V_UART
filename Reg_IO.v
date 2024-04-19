module Reg_IO(
input WEI,
input clk,
input [7:0] WriteData,
output reg [7:0] out
);

always @ (posedge clk)
begin
if (WEI)
out = WriteData;
end

endmodule 