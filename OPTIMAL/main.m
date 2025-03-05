% Developed in MATLAB R2022b
% Source codes 
% _____________________________________________________
clear  
clc
close all

%% 
pop=30; % Number of search agents
T=500; % Maximum numbef of iterations
F_name='F1'; % Name of the test function
%% 
for i=1:30
[lb,ub,dim,fobj]=Functions_details(F_name);% Load details of the selected benchmark function
[Best_Fitness_BKA,Best_Pos_BKA,Convergence_curve]=BKA(pop,T,lb,ub,dim,fobj);
%% The Black-winged Kite Algorithm's 30 experiments' mean, standard deviation, best value, and worst value
BKAmean = mean(Best_Fitness_BKA);
BKAStd = std(Best_Fitness_BKA);
BKAbest = min(Best_Fitness_BKA);
BKAWorst = max(Best_Fitness_BKA);
BKAResults = [BKAmean,BKAStd,BKAbest,BKAWorst];
end
%% figure
semilogy(1:T,Convergence_curve,'color','r','linewidth',2.5);
title('Convergence curve');
xlabel('Iteration');
ylabel('Best score obtained so far')
%% Display calculation results
display(['The best fitness is:', num2str(BKAbest)]);
display(['The best position is:', num2str(Best_Pos_BKA)]);

