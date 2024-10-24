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
alpha = 0.5*ones(n,m) ; 

% Omega < 0
omega = -0.5*ones(n,m) ; 

% Endowments 
individual_endow = ones(n,m) ; 
total_endow = transpose(individual_endow)*ones(n,1) ; 

% Start with a guess 
x = [0.5,0.5,0.5; 0.5, 0.5, 1.5] ;
norm_g = 100 ; 
maxit = 1000 ; 
it = 0 ; 
beta = 0 ; 
alpha_step = 0.01;
d = 0 ; 
tolerance = 10^-5 ;  
   
%% Loop 
% Minimize sum 
while norm_g > tolerance && it < maxit 

    % Gradient written on x as a matrix 
    x_col = reshape(transpose(x),(n-1)*m,1) ; 
    grad = gradient_function(x, total_endow,lambda,alpha,omega) ;

    norm_g = norm(grad) ; 

    g = gradient_function(x,total_endow,lambda,alpha,omega) ; 
    g_col = reshape(transpose(g),(n-1)*m,1) ; 

    dplus = -g_col + beta*d ; 

    x_col = x_col + alpha_step.*dplus ; 
    x = reshape(x_col,n-1,m) ; 

    it = it + 1 ; 
    gplus = gradient_function(x,total_endow,lambda,alpha,omega); 
    g_col_plus = reshape(transpose(gplus),(n-1)*m,1) ; 
    d = dplus ; 
    
    beta = (transpose(g_col_plus)*g_col_plus)/(transpose(g_col)*g_col) ; 
end 

%% 2. Compute Pareto Efficient Allocations (changing parameters) 



%% Function appendix 
function z = gradient_function(x, endow,lambda,alpha,omega)
    % Size of x is actually n-1 from above 
    [n,~] = size(x) ; 
    
    % Create variables for last person versus all 
    x_last = transpose(endow) - ones(1,n)*x ; 
    alpha_1_nminus = alpha(1:n,:) ; 
    alpha_n = alpha(n+1,:) ; 
    omega_1_nminus = omega(1:n,:) ; 
    omega_n = omega(n+1,:) ; 
    lambda_1_nminus = lambda(1:n) ; 
    lambda_n = lambda(n+1) ; 

    impact = lambda_n*alpha_n.*x_last.^omega_n ; 
    impact = [impact; impact] ;

    z = impact - transpose(lambda_1_nminus).*alpha_1_nminus.*x.^omega_1_nminus ;
end
