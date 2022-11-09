%%%%Dimitrios Gazos AM:4035 Askhsh 1.3
%%%
%%% τρέχετε το πρόγραμμα ως:
%%% signalprobs(input1sp,input2sp)
%%%
%%% Παραδείγματα:
%%% >> signalprobs(0.5,0.5)
%%% AND Gate for input probabilities (0.500000 0.500000):
%%% ans =  0.25000
%%% OR Gate for input probabilities (0.500000 0.500000):
%%% ans =  0.75000
%%% XOR Gate for input probabilities (0.500000 0.500000):
%%% NAND Gate for input probabilities (0.500000 0.500000):
%%% NOR Gate for input probabilities (0.500000 0.500000):
%%%
%%%
%%% >> signalprobs(0,0)
%%% AND Gate for input probabilities (0.00000 0.00000):
%%% ans =  0
%%% OR Gate for input probabilities (0.00000 0.00000):
%%% ans =  0
%%% XOR Gate for input probabilities (0.00000 0.00000):
%%% NAND Gate for input probabilities (0.00000 0.00000):
%%% NOR Gate for input probabilities (0.00000 0.00000):
%%%
%%% >> signalprobs(1,1)
%%% AND Gate for input probabilities (1.00000 1.00000):
%%% ans =  1
%%% OR Gate for input probabilities (1.00000 1.00000):
%%% ans =  1
%%% XOR Gate for input probabilities (1.00000 1.00000):
%%% NAND Gate for input probabilities (1.00000 1.00000):
%%% NOR Gate for input probabilities (1.00000 1.00000):
%%%
%%%
%%%
%%% Οι συναρτήσεις που υπολογίζουν τα signal probabilities
%%% AND και OR πυλών δύο εισόδων έχουν ήδη υλοποιηθεί παρακάτω.
%%% Οι συναρτήσεις που υπολογίζουν τα signal probabilities
%%% XOR, NAND και NOR πυλών δύο εισόδων είναι ημιτελής.
%%% (α) Σας ζητείτε να συμπληρώσετε τις υπόλοιπες ημιτελής συναρτήσεις για τον υπολογισμό
%%% των signal probabilities XOR,NAND και NOR 2 εισόδων πυλών.
%%% (β) γράψτε συναρτήσεις για τον υπολογισμό των signal probabilities
%%% AND, OR, XOR, NAND, NOR πυλών 3 εισόδων
%%% (γ) γράψτε συναρτήσεις για τον υπολογισμό των signal probabilities
%%% AND, OR, XOR, NAND, NOR πυλών Ν εισόδων


function s=signalprobs(varargin)
  N = nargin;
  printf("sp = signal probability | esw = signal activity\n");
  printf("***********************************************\n");
  switch nargin
    case 2 %for 2 inputs
      input1sp = varargin{1};
      input2sp = varargin{2};
      sp2 = sp2AND(input1sp, input2sp)
      sp2 = sp2OR(input1sp, input2sp)
      sp2 = sp2XOR(input1sp, input2sp)
      sp2 = sp2NAND(input1sp, input2sp)
      sp2 = sp2NOR(input1sp, input2sp)
    case 3  %for 3 inputs
      input1sp = varargin{1};
      input2sp = varargin{2};
      input3sp = varargin{3};
      sp3 = sp3AND(input1sp, input2sp, input3sp)
      sp3 = sp3OR(input1sp, input2sp, input3sp)
      sp3 = sp3XOR(input1sp, input2sp, input3sp)
      sp3 = sp3NAND(input1sp, input2sp, input3sp)
      sp3 = sp3NOR(input1sp, input2sp, input3sp)
    case N  %for N inputs
      sp = spAND(varargin)
      sp = spOR(varargin)
      sp = spXOR(varargin)
      sp = spNAND(varargin)
      sp = spNOR(varargin)


  endswitch


  % Οι παρακάτω συναρτήσεις πρέπει να γραφούν εξ'ολοκλήρου για το (β)


  % Οι παρακάτω συναρτήσεις πρέπει να γραφούν εξ'ολοκλήρου για το (γ)
  %% προσοχή: πρέπει να παίζουν ανεξάρτητα του πόσες εισόδους τους δίνετε
  %spAND(input1sp, input2sp, input3sp, input4sp ...)
  %spOR(input1sp, input2sp, input3sp, input4sp ...)
  %spXOR(input1sp, input2sp, input3sp, input4sp, ...);
  %spNAND(input1sp, input2sp, input3sp, input4sp, ...);
  %spNOR(input1sp, input2sp, input3sp, input4sp, ...);

end
%

% 2-input AND gate truth table
% 0 0:0
% 0 1:0
% 1 0:0
% 1 1:1
%% signal probability calculator for a 2-input AND gate
%% input1sp: signal probability of first input signal
%% input2sp: signal probability of second input signal
%%        s: output signal probability
function s=sp2AND(input1sp, input2sp)
  printf("2-AND Gate for input probabilities (%f %f):\n",input1sp,input2sp)
  s = input1sp*input2sp;
  esw = findESW(s)
  endfunction

% 2-input OR gate truth table
% 0 0:0
% 0 1:1
% 1 0:1
% 1 1:1
%% signal probability calculator for a 2-input OR gate
%% input1sp: signal probability of first input signal
%% input2sp: signal probability of second input signal
%%        s: output signal probability
function s=sp2OR(input1sp, input2sp)
  printf("2-OR Gate for input probabilities (%f %f):\n",input1sp,input2sp)
  s = 1-(1-input1sp)*(1-input2sp);
  esw = findESW(s)
endfunction


% 2-input XOR gate truth table
% 0 0:0
% 0 1:1
% 1 0:1
% 1 1:0
%% signal probability calculator for a 2-input XOR gate
%% input1sp: signal probability of first input signal
%% input2sp: signal probability of second input signal
%%        s: output signal probability
function s=sp2XOR(input1sp, input2sp)
  printf("2-XOR Gate for input probabilities (%f %f):\n",input1sp,input2sp)
  %s = ??;
  s = input1sp*(1-input2sp)+(1-input1sp)*input2sp;
  esw = findESW(s)
endfunction


% 2-input NAND gate truth table
% 0 0:1
% 0 1:1
% 1 0:1
% 1 1:0
%% signal probability calculator for a 2-input XOR gate
%% input1sp: signal probability of first input signal
%% input2sp: signal probability of second input signal
%%        s: output signal probability
function s=sp2NAND(input1sp, input2sp)
  printf("2-NAND Gate for input probabilities (%f %f):\n",input1sp,input2sp)
  %s = ??;
  s = (1-input1sp)*(1-input2sp)+(1-input1sp)*input2sp+input1sp*(1-input2sp);
  esw = findESW(s)
endfunction



% 2-input NOR gate truth table
% 0 0:1
% 0 1:0
% 1 0:0
% 1 1:0
%% signal probability calculator for a 2-input NOR gate
%% input1sp: signal probability of first input signal
%% input2sp: signal probability of second input signal
%%        s: output signal probability
function s=sp2NOR(input1sp, input2sp)
  printf("2-NOR Gate for input probabilities (%f %f):\n",input1sp,input2sp)
  %s = ??;
  s = (1-input1sp)*(1-input2sp);
  esw = findESW(s)
endfunction

% 3-input AND gate truth table
% 0 0 0:0
% 0 0 1:0
% 0 1 0:0
% 0 1 1:0
% 1 0 0:0
% 1 0 1:0
% 1 1 0:0
% 1 1 1:1
function s=sp3AND(input1sp,input2sp,input3sp)
  printf("3-AND Gate for input probabilities (%f %f %f):\n",input1sp,input2sp,input3sp)
  s = input1sp*input2sp*input3sp;
  esw = findESW(s)
endfunction

% 3-input OR gate truth table
% 0 0 0:0
% 0 0 1:1
% 0 1 0:1
% 0 1 1:1
% 1 0 0:1
% 1 0 1:1
% 1 1 0:1
% 1 1 1:1
function s=sp3OR(input1sp,input2sp,input3sp)
  printf("3-OR Gate for input probabilities (%f %f %f):\n",input1sp,input2sp,input3sp)
  s = 1-(1-input1sp)*(1-input2sp)*(1-input3sp);
  esw = findESW(s)
endfunction

% 3-input XOR gate truth table
% 0 0 0:0
% 0 0 1:1
% 0 1 0:1
% 0 1 1:0
% 1 0 0:1
% 1 0 1:0
% 1 1 0:0
% 1 1 1:1
function s=sp3XOR(input1sp,input2sp,input3sp)
  printf("3-XOR Gate for input probabilities (%f %f %f):\n",input1sp,input2sp,input3sp)
  s = input1sp*input2sp*input3sp + input1sp*(1-input2sp)*(1-input3sp) + (1-input1sp)*input2sp*(1-input3sp) + (1-input1sp)*(1-input2sp)*input3sp;
  esw = findESW(s)
endfunction

% 3-input NAND gate truth table
% 0 0 0:1
% 0 0 1:1
% 0 1 0:1
% 0 1 1:1
% 1 0 0:1
% 1 0 1:1
% 1 1 0:1
% 1 1 1:0
function s=sp3NAND(input1sp,input2sp,input3sp)
  printf("3-NAND Gate for input probabilities (%f %f %f):\n",input1sp,input2sp,input3sp)
  s = 1-input1sp*input2sp*input3sp;
  esw = findESW(s)
endfunction

% 3-input NOR gate truth table
% 0 0 0:1
% 0 0 1:0
% 0 1 0:0
% 0 1 1:0
% 1 0 0:0
% 1 0 1:0
% 1 1 0:0
% 1 1 1:0
function s=sp3NOR(input1sp,input2sp,input3sp)
  printf("3-NOR Gate for input probabilities (%f %f %f):\n",input1sp,input2sp,input3sp)
  s = (1-input1sp)*(1-input2sp)*(1-input3sp);
  esw = findESW(s)
endfunction

% N-input AND gate truth table
function s=spAND(varargin)
   printf("N-AND Gate for input probabilities:\n")
   s = 1;
   for i = 1:length(varargin{1})
     s = s * varargin{1}{i};
   endfor
   esw = findESW(s)
endfunction

% N-input OR gate truth table
function s=spOR(varargin)
  printf("N-OR Gate for input probabilities:\n")
  s = 1;
  temp = 1;
  for i = 1:length(varargin{1})
    temp = temp * (1-varargin{1}{i});
    s = 1 - temp;
  endfor
  esw = findESW(s)
endfunction

% N-input XOR gate truth table
function s=spXOR(varargin)
  printf("N-XOR Gate for input probabilities:\n")
  s = sp2XOR(varargin{1}{1},varargin{1}{2}); %prwtes 2 se XOR
  for i = 3:length(varargin{1})
    s = sp2XOR(varargin{1}{i},s);  %to apotelesma ths prwths se nea XOR
  endfor
  esw = findESW(s);
endfunction

% N-input NAND gate truth table
function s=spNAND(varargin)
  printf("N-NAND Gate for input probabilities:\n")
  s = 1;
  temp = 1;
  for i = 1:length(varargin{1})
    temp = temp * varargin{1}{i};
    s = 1 - temp;
  endfor
  esw = findESW(s)
endfunction

% N-input NOR gate truth table
function s=spNOR(varargin)
  printf("N-NOR Gate for input probabilities:\n")
  s = 1;
  for i = 1:length(varargin{1})
    s = s * (1-varargin{1}{i});
  endfor
  esw = findESW(s)
endfunction

% find switching activity
function s = findESW(signal)
    s = 2*signal*(1-signal);
endfunction

%parathrhsh
% ta sp einai symplhrwmatika sto 1
% osa perissotera N, toso megalyterh h diafora tous
% esw idia ektos apo XOR

