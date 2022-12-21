module MCPU_ramcontroller_tb();
parameter WORD_SIZE=8;
parameter ADDR_WIDTH=8;
parameter RAM_SIZE=1<<ADDR_WIDTH;

reg we, re;
reg [WORD_SIZE-1:0] datawr;
reg [ADDR_WIDTH-1:0] addr;
reg [ADDR_WIDTH-1:0] instraddr;
reg [WORD_SIZE-1:0] mem[RAM_SIZE-1:0];

wire [WORD_SIZE-1:0] datard;
wire [WORD_SIZE-1:0] instrrd;

//MCPU_RAMController #(.WORD_SIZE(WORD_SIZE), .ADDR_WIDTH(ADDR_WIDTH), .RAM_SIZE(RAM_SIZE)) raminst (we, re, datawr, addr, instraddr, datard, instrrd);
MCPU_RAMController raminst (.we(we),.datawr(datawr),.re(re),.addr(addr),.datard(datard),.instraddr(instraddr),.instrrd(instrrd));

integer i;
integer k;
integer l;

initial begin     //write test
  
  we <= 1;
  re <= 0;
  
  //instraddr <= 0;
  //addr <= 0;
  //datawr <= 0;
  for(i=0;i < RAM_SIZE; i=i+1) 
  begin
    mem[i] = $random;
    datawr = mem[i];
    addr = i;
    #1;
  end  
end

initial begin     //anagnwsh dedomenwn test
  #256;
  we <= 0;
  re <= 1;
  
  for(k=0;k < RAM_SIZE; k=k+1) 
  begin
    
    addr <= k;
    #1;
  end  
end

initial begin     //anagnwsh entolwn test 
  #512;
  we <= 0;
  re <= 0;
  
  for(l=0;l < RAM_SIZE; l=l+1) 
  begin
    
    instraddr <= l;
    #1;
  end  
end


endmodule
