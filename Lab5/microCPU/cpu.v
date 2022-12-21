module MCPU(clk, reset);


parameter WORD_SIZE=16; //WORD_SIZE is the word size of our processor. Each word is 16 bits or 2 bytes
parameter ADDR_WIDTH=8; //that means 2^8=256 size of memory of WORD_SIZE word
parameter OPCODE_SIZE=4;
parameter ALU_CMD_SIZE=2;
parameter OPERAND_SIZE=4;


//instructions will have the following structure:
//OPCODE OPERAND1 OPERAND2 OPERAND3

parameter INSTRUCTION_SIZE = OPCODE_SIZE + OPERAND_SIZE*3;

input clk;
input reset;

wire [OPCODE_SIZE-1:0] opcode;
wire [OPERAND_SIZE-1:0] operand1;
wire [OPERAND_SIZE-1:0] operand2;
wire [OPERAND_SIZE-1:0] operand3;

wire [ALU_CMD_SIZE-1:0] alu_cmd;


//opcodes for the supported instruction set
parameter  [OPCODE_SIZE-1:0]  OP_AND  = 0; //4'b0000
parameter  [OPCODE_SIZE-1:0]  OP_OR   = 1; //4'b0001
parameter  [OPCODE_SIZE-1:0]  OP_XOR  = 2; //4'b0010
parameter  [OPCODE_SIZE-1:0]  OP_ADD  = 3; //4'b0011
parameter  [OPCODE_SIZE-1:0]  OP_MOV  = 4; //4'b0100
parameter  [OPCODE_SIZE-1:0]  OP_LOAD_FROM_MEM = 5; //4'b0101
parameter  [OPCODE_SIZE-1:0]  OP_STORE_TO_MEM = 6; //4'b0110
parameter  [OPCODE_SIZE-1:0]  OP_SHORT_TO_REG = 7; //4'b0111
parameter  [OPCODE_SIZE-1:0]  OP_BNZ   = 8; //4'b1000

//control signals for ALU
wire [WORD_SIZE-1:0] alu_in1;
wire [WORD_SIZE-1:0] alu_in2;
wire [WORD_SIZE-1:0] alu_out;
wire CARRY;

//assign alu_out operand0;
//assign alu_r1 operand1;
//assign alu_r2 operand2;


MCPU_Alu #(.CMD_SIZE(ALU_CMD_SIZE), .WORD_SIZE(WORD_SIZE)) 
aluinst (.cmd(alu_cmd), 
        .in1(alu_in1), 
        .in2(alu_in2), 
        .out(alu_out), 
        .CF(CARRY));


//The Program Counter
reg [ADDR_WIDTH-1:0] pc;

//Control Bits for Register file
reg [1:0] regset_cmd;
reg regset_wb;
wire [WORD_SIZE-1:0] regdatatoload;
wire [WORD_SIZE-1:0] RegOp1;

MCPU_Registerfile #(.WORD_SIZE(WORD_SIZE), .OPERAND_SIZE(OPERAND_SIZE)) 
regfileinst (.op1(operand1), .op2(operand2), .op3(operand3), .RegOp1(RegOp1), .alu1(alu_in1), .alu2(alu_in2), .datatoload(regdatatoload), .regsetwb(regset_wb), .regsetcmd(regset_cmd));


//Control Bits for RAM
reg RAMWE, RAMRE;
reg [ADDR_WIDTH-1:0] RAMADDR;
wire [WORD_SIZE-1:0] RAMDWRITE;
wire [WORD_SIZE-1:0] RAMDREAD;

wire [ADDR_WIDTH-1:0] IADDR;
wire [WORD_SIZE-1:0] IREAD;

reg [ADDR_WIDTH+1:0] wb_cmd;

MCPU_RAMController #(.WORD_SIZE(WORD_SIZE), .ADDR_WIDTH(ADDR_WIDTH)) 
raminst (.we(RAMWE), .datawr(RAMDWRITE), .re(RAMRE), .addr(RAMADDR), 
.datard(RAMDREAD), .instraddr(IADDR), .instrrd(IREAD));



//instruction is always read from the IREAD channel from memory
wire [INSTRUCTION_SIZE-1:0] instruction;
assign instruction=IREAD;
assign IADDR=pc;

// structural code for instruction decoding
assign opcode=instruction[INSTRUCTION_SIZE-1:INSTRUCTION_SIZE-OPCODE_SIZE];
assign alu_cmd=opcode[ALU_CMD_SIZE-1:0];
assign operand1=instruction[OPCODE_SIZE*3-1:2*OPCODE_SIZE];
assign operand2=instruction[OPCODE_SIZE*2-1:OPCODE_SIZE];
assign operand3=instruction[OPCODE_SIZE-1:0];


wire [WORD_SIZE-1:0] MemOrConstant;
assign MemOrConstant=(opcode==OP_SHORT_TO_REG)?{8'b00000000, operand2, operand3}:RAMDREAD;
assign regdatatoload=(regset_cmd==regfileinst.NORMAL_EX)?alu_out:MemOrConstant;
  
  //only data from operand 1 decoding to register are ever written into memory
  assign RAMDWRITE=RegOp1;

//parameter CPU_STATES_BITS=2;
//Instruction Fetch State
parameter  [1:0]  IF_STATE  = 2'b00;
//Execute Fetch State
parameter  [1:0]  EX_STATE  = 2'b01;
//WriteBack State
parameter  [1:0]  WB_STATE  = 2'b10;
//HALTED State
parameter  [1:0]  HLT_STATE  = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

reg [8*3:0] STATE_AS_STR;
always @(state)
begin
  case(state)
    IF_STATE:
    begin
      STATE_AS_STR<="IF";
    end
    EX_STATE:
    begin
      STATE_AS_STR<="EX";
    end
    WB_STATE:
    begin
      STATE_AS_STR<="WB";
    end
    default:
    begin
      STATE_AS_STR<="HLT";
    end  
  endcase
end
always @ (state, opcode)
begin : MAIN_FSM_COMBINATIONAL
  next_state=0;
  case(state)
    IF_STATE:
    begin
      //this is a 3 stages pipelining so IF and DECODE occur on this step
      case(opcode)
        OP_BNZ:
        begin
            next_state = IF_STATE;
        end
        default:
        begin
            next_state = EX_STATE;
        end
      endcase
    end
    EX_STATE:
    begin
      next_state = WB_STATE;
    end
    WB_STATE:
    begin
      next_state = IF_STATE;
    end
  endcase  
end

always @ (posedge clk, reset)
begin : MAIN_FSM
  if (reset == 1'b1) begin
    //get the CPU into IF state
    state <= #1 IF_STATE;
    
    //reset the Program Counter PC
    pc <= #1 0;
    
  end else begin
    case(state)
      IF_STATE:
      begin
        
        //this is a 3 stages pipelining so IF and DECODE occur on this step
        case(opcode)
        	 OP_AND,OP_OR,OP_XOR,OP_ADD:
          begin
            regset_cmd <= #2 regfileinst.NORMAL_EX;
          end
          OP_MOV:
          begin
            regset_cmd <= #2 regfileinst.MOV_INTERNAL;
          end
          OP_LOAD_FROM_MEM:
          begin
            regset_cmd<= #2 regfileinst.LOAD_FROM_DATA;
            wb_cmd[ADDR_WIDTH-1:0]<= #2 {operand2,operand3};
            wb_cmd[ADDR_WIDTH]<= #2 1'b0; //RAMWE
            wb_cmd[ADDR_WIDTH+1]<= #2 1'b1; //RAMRE
          end
          OP_STORE_TO_MEM:
          begin
            regset_cmd <= #2 regfileinst.DO_NOTHING;
            //whatever there is in RAMDWRITE, it is going to be written at WB to address {operand2,operand3}
            wb_cmd[ADDR_WIDTH-1:0] <= #2 {operand2,operand3};
            wb_cmd[ADDR_WIDTH] <= #2 1'b1; //RAMWE - RAM WRITE ENABLE
            wb_cmd[ADDR_WIDTH+1] <= #2  1'b0; //RAMRE - RAM READ ENABLE
          end
          OP_SHORT_TO_REG:
          begin
            regset_cmd<=#2 regfileinst.LOAD_FROM_DATA;
            wb_cmd[ADDR_WIDTH]<=#2 1'b0; //RAMWE
            wb_cmd[ADDR_WIDTH+1]<=#2 1'b0; //RAMRE
          end
          OP_BNZ:
          begin
            if(RegOp1!=0)
            begin  
              pc <= #5 {operand2, operand3};
            end else
            begin
              pc <= #5 pc+1;
            end
          end
          default:
          begin
          end
        endcase
        
      end        
      EX_STATE:
      begin
      end
      WB_STATE:
      begin
        RAMADDR<=#1 wb_cmd[ADDR_WIDTH-1:0];
        RAMWE<=#1 wb_cmd[ADDR_WIDTH];
        RAMRE<=#1 wb_cmd[ADDR_WIDTH+1];
        
        regset_wb <= #2 1'b1;
        regset_wb<= #3 1'b0;
        wb_cmd[ADDR_WIDTH]<= #3 1'b0;
        wb_cmd[ADDR_WIDTH+1]<=  #3 1'b0;
        RAMWE <= #3 1'b0;
        RAMRE <= #3 1'b0;
        pc <= #5 pc+1;
        
      end
      HLT_STATE:
      begin
        $display("processor HALTED\n");
        $stop;
      end
      default:
      begin
      end
      
    endcase
    state<=#8 next_state;
  end
  
end
endmodule
