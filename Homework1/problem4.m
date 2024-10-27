% Computing Pareto Efficient Allocations Consider an endowment economy with
% m goods and n agents. Each agent has an endowment for every good and a
% utility function of the form 
% u^i(x) = sum_{j=1}^m \alpha_j \frac{x_j^{1 + \omega_j^i}}{1 + \omega_j^i}
% where alpha_j > 0 > \omega_j^i are agent specific parameters. 

% Given some social weights $\lambda$, solve the social planner's problem
% for m = n = 3 with your favorite optimization method. Try different
% values for alpha, omega, and lambda. 

%% 0. Housekeeping 
clear variables 
close all 

%% 1. Compute Pareto Efficient Allocations (basic version) 
% The goal will be to find the optimal x given the limited endowment 
% Start with identical weights, endowments, and parameters, then solve for
% the allocation 

% "Hyperparameters" 
m = 3 ; 
n = 3 ; 

% Identical Weights 
lambda = (1/n)*ones(1,n) ;

% lambda = [1/2, 1/3, 1/6] ; 

% Alpha > 0 
alpha = 2*ones(n,m) ; 

% Omega < 0
omega = -2*ones(n,m) ; 

% Endowments 
individual_endow = ones(n,m) ; 
total_endow = transpose(individual_endow)*ones(n,1) ; 

% Start with a guess 
x = [0.5,1,1.5; 1.5,1,0.5] ;
A = [];
b = [] ;
Aeq = [] ; 
beq = [] ; 
lb = zeros(n-1,m) ;

temp = fmincon(@(x) social_planner(x,total_endow,lambda,alpha,omega), x,A,b,Aeq,beq,lb) ; 
x_last = transpose(total_endow) - ones(1,n-1)*temp ;

allocation_3_3 = [temp; x_last] 

% %% 2. Compute Pareto Efficient Allocations (changing parameters) 
% 
% % "Hyperparameters" 
% m = 10 ; 
% n = 10 ; 
% 
% % Identical Weights 
% lambda = (1/n)*ones(1,n) ;
% 
% % Not identical weights
% % lambda = ((1:n)*ones(n,1))^(-1)*(1:10) ;
% 
% % Alpha > 0 
% alpha = 0.5*ones(n,m) ; 
% 
% % Omega < 0
% omega = -0.5*ones(n,m) ; 
% 
% % Endowments 
% individual_endow = 3*ones(n,m) ; 
% total_endow = transpose(individual_endow)*ones(n,1) ; 
% 
% % Start with a guess 
% x = 3*ones(n-1,m) ;
% lb = zeros(n-1,m) ;
% 
% social_planner(x,total_endow,lambda,alpha,omega)
% 
% temp = fmincon(@(x) social_planner(x,total_endow,lambda,alpha,omega), x,A,b,Aeq,beq,lb) ; 
% x_last = transpose(total_endow) - ones(1,n-1)*temp ;
% 
% endowment_10_10 = [temp; x_last] 


%% Function appendix 
function z = social_planner(x, endow, lambda, alpha, omega)
     % Size of x is actually n-1 from above 
    [n,~] = size(x) ; 
    
    % Create variables for last person versus all 
    x_last = transpose(endow) - ones(1,n)*x ;
    
    x_all = [x; x_last] ; 

    % Utility 
    utility = (transpose(lambda).*alpha.*x_all.^omega) ; 
    z = -1*ones(1,n+1)*utility*ones(n+1,1) ; 
end 