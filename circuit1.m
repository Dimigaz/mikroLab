%Dimitrios Gazos AM:4035 Askhsh 2.1
%clear;
%close all;
% oi prakseis eginan sto xarti
% trexw me to onoma synarthshs px circuit(1,1,0)

function s = circuit1(a,b,c)

  printf(" Truth table of circuit \n");
  printf(" A  B  C  |  E  F  |  D \n");
  printf(" ====================== \n");
  printf(" 0  0  0  |  0  1  |  0 \n");
  printf(" 0  0  1  |  0  0  |  0 \n");
  printf(" 0  1  0  |  0  1  |  0 \n");
  printf(" 0  1  1  |  0  0  |  0 \n");
  printf(" 1  0  0  |  0  1  |  0 \n");
  printf(" 1  0  1  |  0  0  |  0 \n");
  printf(" 1  1  0  |  1  1  |  1 \n");
  printf(" 1  1  1  |  1  0  |  0 \n");

  printf("input:a,b | middle output:e | AND GATE\n")
  e = sp2AND(a,b)
  printf("input:c | middle output:f | NOT GATE\n")
  f = sp2NOT(c)
  printf("input:e,f | final output:d | AND GATE\n")
  d = sp2AND(e,f)
endfunction

function s=sp2AND(input1sp, input2sp)
  %printf("AND Gate for input probabilities (%f %f):\n",input1sp,input2sp)
  s = input1sp*input2sp;
endfunction

function s=sp2NOT(input1sp)
  s = 1 - input1sp;
endfunction

