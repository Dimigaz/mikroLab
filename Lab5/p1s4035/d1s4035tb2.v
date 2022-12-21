module d1s4035tb2();
  
reg tb_a;
reg tb_b;
reg tb_c;
reg tb_d_corrector;


wire [2:0] tb_dut_inputs;

wire tb_d;



d1s4035 dut(tb_a, tb_b, tb_c, tb_d);

assign tb_dut_inputs={tb_a, tb_b, tb_c};

initial begin
  {tb_a, tb_b, tb_c}=3'b000;
  
  forever #5 {tb_a, tb_b, tb_c}=tb_dut_inputs+1;
end

initial begin
  
  forever #2 begin
  
  if(tb_a==0 && tb_b==0 && tb_c==0 && tb_d==0) begin
  tb_d_corrector = 1;
  end
  else if(tb_a==0 && tb_b==0 && tb_c==1 && tb_d==0) begin
  tb_d_corrector = 1;
  end
  else if(tb_a==0 && tb_b==1 && tb_c==0 && tb_d==0) begin
  tb_d_corrector = 1;
  end
  else if(tb_a==0 && tb_b==1 && tb_c==1 && tb_d==0) begin
  tb_d_corrector = 1;
  end
  else if(tb_a==1 && tb_b==0 && tb_c==0 && tb_d==0) begin
  tb_d_corrector = 1;
  end
  else if(tb_a==1 && tb_b==0 && tb_c==1 && tb_d==0) begin
  tb_d_corrector = 1;
  end
  else if(tb_a==1 && tb_b==1 && tb_c==0 && tb_d==1) begin
  tb_d_corrector = 1;
  end
  else if(tb_a==1 && tb_b==1 && tb_c==1 && tb_d==0) begin
  tb_d_corrector = 1;
  end
  else begin
  tb_d_corrector = 0;
  end 
  
  end  

end

endmodule
