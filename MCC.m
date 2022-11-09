%Dimitrios Gazos AM:4035 Askhsh 2.3
%clear;
%close all;

% Gia ta endiamesa einai MC gia AND kai MC gia NOT
function sa = MCC(N)
  %Workload = [1 1 0];
  Workload = [];
  MCsize = N;
  switches = 0;
  for i = 1:MCsize
    Workload=[Workload; round(mod(rand(),2)), round(mod(rand(),2)), round(mod(rand(),2))];
  endfor

  numOfWorkloads=size(Workload, 1) %posa exei to workload %mallon peritth
  numOfGates=size(Workload, 2) %posa einai ta inputs edw 4
  %curGate = 0;
  curGate=circuit(Workload(1,1),Workload(1,2),Workload(1,3));

  for i = 2:numOfWorkloads
    newGate = circuit(Workload(i,1),Workload(i,2),Workload(i,3));
    if curGate == newGate
      continue;
    else
      curGate = newGate;
      switches = switches + 1;
    endif
  endfor

  switches
  Workload
  sa = switches/numOfWorkloads
endfunction

function s=sp2AND(input1sp, input2sp)
  s = input1sp*input2sp;
endfunction

%NOT Gate for input probability
function s=sp2NOT(input1sp)
  s = 1 - input1sp;
endfunction

function s = circuit(a,b,c)
  %printf("input:a,b | middle output:e | AND GATE\n")
  e = sp2AND(a,b);
  %printf("input:c | middle output:f | NOT GATE\n")
  f = sp2NOT(c);
  %printf("input:e,f | final output:d | AND GATE\n")
  d = sp2AND(e,f);
  s = d;
endfunction



