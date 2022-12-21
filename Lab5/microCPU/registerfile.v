module MCPU_Registerfile(op1, op2, op3, RegOp1, alu1, alu2, datatoload, regsetwb, regsetcmd);
parameter WORD_SIZE=8;
parameter OPERAND_SIZE=4;
parameter REGS_NUMBER_WIDTH=2;
parameter REGISTERS_NUMBER=1<<REGS_NUMBER_WIDTH;

input [OPERAND_SIZE-1:0] op1,op2,op3;
input [WORD_SIZE-1:0] datatoload;

input [1:0] regsetcmd;
input regsetwb;
//REGISTER FILE COMMAND (regsetcmd control bits)
parameter  [1:0]  NORMAL_EX  = 0; //2'b00
parameter  [1:0]  MOV_INTERNAL   = 1; //2'b01
parameter  [1:0]  LOAD_FROM_DATA   = 2; //2'b10
parameter  [1:0]  DO_NOTHING   = 3; //2'b11

//these are always set outputs implemented structurally 
// correspond to translated operands to registers
//operand1 is translated to RegOp1
//operand2 is translated to alu1
//operand3 is translated to alu2
output [WORD_SIZE-1:0] RegOp1;
output [WORD_SIZE-1:0] alu1; // to be the first operand of alu
output [WORD_SIZE-1:0] alu2; // to be the second operand of alu

//this processor has 4 registers
reg [WORD_SIZE-1:0] R[REGISTERS_NUMBER-1:0];
//this processor has 4 registers //aliases
//wire [WORD_SIZE-1:0] r0,r1,r2,r3;


//alias
//assign r0=R[0];
//assign r1=R[1];
//assign r2=R[2];
//assign r3=R[3];


//operands translation to registers
assign RegOp1=R[op1[REGS_NUMBER_WIDTH-1:0]];
assign alu1=R[op2[REGS_NUMBER_WIDTH-1:0]];
assign alu2=R[op3[REGS_NUMBER_WIDTH-1:0]];



//whenever this unit needs to act - this signal is asserted at WB from the control unit
always @(posedge regsetwb)
begin
  #1    
  case(regsetcmd)
  NORMAL_EX,LOAD_FROM_DATA:
  begin
    R[op1[REGS_NUMBER_WIDTH-1:0]]<=datatoload;
  end
  MOV_INTERNAL:
  begin
    R[op1[REGS_NUMBER_WIDTH-1:0]]<=R[op2[REGS_NUMBER_WIDTH-1:0]];
  end
  default:
  begin
    
  end
  endcase
end
endmodule

