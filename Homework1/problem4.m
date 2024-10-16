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

% Alpha > 0 
alpha = 2*ones(m,n) ; 

% Omega < 0
omega = -1.5*ones(m,n) ; 

% Endowments 
e = ones(m,n) ; 

% Start with a guess 
x = 3*diag(ones(3,1)) ; 

for j = 1:n
    utility(x(:,j),alpha(:,j),omega(:,j))
end 

%% 2. Compute Pareto Efficient Allocations (changing parameters) 



%% Function appendix 
function z = utility(x, alpha, omega)
    values = transpose(alpha)*(x.^(1 + omega))./(1+omega) ; 
    z =  transpose(ones(size(x)))*values ; 
end 