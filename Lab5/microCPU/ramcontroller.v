module MCPU_RAMController(we, datawr, re, addr, datard, instraddr, instrrd);
parameter WORD_SIZE=8;
parameter ADDR_WIDTH=8;
parameter RAM_SIZE=1<<ADDR_WIDTH;

input we, re;

input [WORD_SIZE-1:0] datawr;

input [ADDR_WIDTH-1:0] addr;
input [ADDR_WIDTH-1:0] instraddr;

output [WORD_SIZE-1:0] datard;
output [WORD_SIZE-1:0] instrrd;

reg [WORD_SIZE-1:0] mem[RAM_SIZE-1:0];


reg [WORD_SIZE-1:0] datard;
reg [WORD_SIZE-1:0] instrrd;

always @ (addr or we or re or datawr)
begin
  if(we)begin
    mem[addr]=datawr;
  end
  if(re) begin
    datard=mem[addr];
  end
end


always @ (instraddr)
begin
    instrrd=mem[instraddr];
end


endmodule

