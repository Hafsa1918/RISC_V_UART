module ErrorCheck(
 input reset,
 input rx_flag,
 input parity_bit,
 input start_bit,
 input stop_bit,
 input [1:0] parity_type,
 input [7:0] raw_data,
 output reg [2:0] error_flag
);

reg error_parity;
reg parity_flag;
reg start_flag;
reg stop_flag;

localparam Odd  = 2'b01,
           Even = 2'b10;
			  
always @ (*)
begin
   case (parity_type)
	   Odd:   error_parity <= (^raw_data)? 1'b0 : 1'b1;
		Even:  error_parity <= (^raw_data)? 1'b1 : 1'b0;
	endcase
end
always @ (*) begin
  if (reset)
  begin
    parity_flag <= 1'b0;
	 start_flag  <= 1'b0;
	 stop_flag   <= 1'b0;
  end
  else
  begin
    if(rx_flag)
    begin
	   parity_flag  <= ~(error_parity && parity_bit);
      start_flag   <= (start_bit || 1'b0);
	   stop_flag    <= ~(stop_bit && 1'b1);
	 end
	 else
	 begin
	   parity_flag  <= 1'b0;
		start_flag   <= 1'b0;
		stop_flag    <= 1'b0;
		end
	end
end

always @(*)
begin
  error_flag = {stop_flag,start_flag,parity_flag};
end
	  
endmodule 