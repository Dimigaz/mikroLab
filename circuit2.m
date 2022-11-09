%Dimitrios Gazos AM:4035 Askhsh 2.2
%clear;
%close all;
% oi prakseis eginan sto xarti

% check  circuit (0.5,0.5,0.5)  sp  Pout=0.5
function s = circuit2(a,b,c)

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
  printf("switching activity in E: %d\n", findESW(e))
  printf("input:c | middle output:f | NOT GATE\n")
  f = sp2NOT(c)
  printf("switching activity in F: %d\n", findESW(f))
  printf("input:e,f | final output:d | AND GATE\n")
  d = sp2AND(e,f)
  printf("switching activity in D: %d\n", findESW(d))
endfunction

function s=sp2AND(input1sp, input2sp)
  s = input1sp*input2sp;
endfunction

function s=sp2NOT(input1sp)
  s = 1 - input1sp;
endfunction


function s = findESW(signal)
    s = 2*signal*(1-signal);
endfunction
