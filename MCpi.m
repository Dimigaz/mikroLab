%Dimitrios Gazos AM:4035 Askhsh 1.1
%clear;
%close all;
%clf;

function s = MCpi(N)
a = 1; %pleura tetragwnou
r = a/2; %aktina
pi = 3.14159265359;
count = 0; %arithmos shmeiwn mesa ston kyklo

%N = 1000; %arithmos shmeiwn

Esqr = a^2;
Ecircle = pi*r^2;


for i = 1:N
  x = rand();
  y = rand();
  checkInsideCircle = sqrt((x-0.5)^2 + (y-0.5)^2); %circle has center (0.5,0.5)

  %tsekaroume ama to shmeio einai mesa ston kyklo
  if checkInsideCircle <= r
    %disp("yes")
    count = count + 1;
  end

  %disp(count);
  %disp(i);
  %disp(N);


  mcpi(i) = (count/i)*4;
  %disp(mcpi(i));


end

%figure;
printf("final Monte Carlo simulation of pi: %f\n", mcpi(N));
plot(1:N,mcpi, 'color', 'r');
xlabel("N");
ylabel("MCpi");
ylim([1 5]);
line ([0 i], [pi pi], "linestyle", "--", "color", "g"); %show where pi is

endfunction
