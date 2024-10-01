module alucontrol(aluop,funct3,funct7,operation);
input [1:0] aluop;
input [2:0] funct3;
input funct7;
output [2:0] operation;
reg[2:0] operation;
wire [13:0] control;
  always @(*)
begin 
case(aluop)
2'b00: operation=3'b000;											//Add
2'b01: begin
		 case (funct3)
		 3'b000: operation=3'b001;									//Sub
		 3'b001: operation=3'b100;									//not equal
		 default: operation = 3'bxxx;
		 endcase
		 end
2'b10: begin
       case(funct3)
       3'b000:operation=funct7? 3'b001 : 3'b000;			
       3'b111:operation=3'b010;									//and
       3'b110:operation=3'b011;									//or	
       3'b010:operation=3'b101;									//slt
       default: operation = 3'bxxx;
       endcase
       end
default: operation= 3'bxxx;
endcase
end
endmodule
