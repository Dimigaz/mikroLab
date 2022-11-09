%Dimitrios Gazos AM:4035 Askhsh 1.2
%clear;
%close all;

function SwitchingActivity=MCOR4(N)
  Workload = [];
  MCsize = N;
  switches = 0;
  for i = 1:MCsize    %tuxaia workloads
    Workload=[Workload; round(mod(rand(),2)), round(mod(rand(),2)), round(mod(rand(),2)), round(mod(rand(),2))];
  endfor

  numOfWorkloads=size(Workload, 1) %posa exei to workload
  numOfGates=size(Workload, 2) %posa einai ta inputs edw 4
  % An h prwth pulh exei estw enan asso tote ksekina me 1
  curGate = 0;
  for z = 1:numOfGates
    if Workload(1,z) == 1
      curGate = 1;
    else
      continue;
    end

  endfor
  %curGate = (Workload(1,1) |  Workload(1,2)) |  (Workload(1,3) | Workload(1,4));



  for i = 2:numOfWorkloads
      %newGate = Workload(i,1) |  Workload(i,2) | Workload(i,3) | Workload(i,4);
      newGate = 0;
      for y =1:numOfGates      %An exei estw enan asso -> 1
        if Workload(i,y) == 1
          newGate = 1;
        endif
      endfor

      if (curGate == newGate)
          continue;
      else
          curGate = newGate;
          switches = switches + 1;
      end

  endfor
  switches
  SwitchingActivity = switches / numOfWorkloads;
  printf("Calculated Switching Activity: %f\n",SwitchingActivity);
  %Workload

endfunction

% truth table of 4 - input OR
% 0 0 0 0:0
% 0 0 0 1:1
% 0 0 1 0:1
% 0 0 1 1:1
% 0 1 0 0:1
% 0 1 0 1:1
% 0 1 1 0:1
% 0 1 1 1:1
% 1 0 0 0:1
% 1 0 0 1:1
% 1 0 1 0:1
% 1 0 1 1:1
% 1 1 0 0:1
% 1 1 0 1:1
% 1 1 1 0:1
% 1 1 1 1:1



