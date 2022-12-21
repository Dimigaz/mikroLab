module MCPU_Alutb_n();

parameter CMD_SIZE=2;
parameter WORD_SIZE=2;

reg [CMD_SIZE-1:0] opcode;
reg [WORD_SIZE-1:0] r1;
reg [WORD_SIZE-1:0] r2;
reg iscorrect;
reg [WORD_SIZE-1:0] tempV;

wire [WORD_SIZE-1:0] out;
wire OVERFLOW;

MCPU_Alu #(.CMD_SIZE(CMD_SIZE), .WORD_SIZE(WORD_SIZE)) aluinst (opcode, r1, r2, out, OVERFLOW);

// Testbench code goes here
always #2 r1[0] = $random;
always #2 r2[0] = $random;
always #2 r1[1] = $random;
always #2 r2[1] = $random;

always #2 opcode[0] = $random;
always #2 opcode[1] = $random;

initial begin
  $display("@%0dns default is selected, opcode %b",$time,opcode);
end

always @(opcode) begin //whenever value changes
  
  
  if (opcode == 2'b00) begin  //AND
    
    tempV <= r1&r2;
    if ( out ==  tempV) begin
      iscorrect <= 1;
    end
    else begin
      iscorrect <= 0;
    end
  end
  

  if (opcode == 2'b01) begin  //OR
    
    tempV <= r1|r2;
    if ( out == tempV ) begin
      iscorrect <= 1;
    end
    else begin
      iscorrect <= 0;
    end
  end
  
  if (opcode == 2'b10) begin  //XOR
     
    tempV <= r1^r2;
    if ( out == tempV ) begin
      iscorrect <= 1;
    end
    else begin
      iscorrect <= 0;
    end
  end
  
  if (opcode == 2'b11) begin  //ADD
    
    tempV <= r1+r2;
    if ( out == tempV ) begin
      iscorrect <= 1;
    end
    else begin
      iscorrect <= 0;
    end
  end




end



endmodule

