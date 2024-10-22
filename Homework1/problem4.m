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
lambda = (1/n)*ones(n,1) ;

% Alpha > 0 
alpha = 2*ones(m,n) ; 

% Omega < 0
omega = -1.5*ones(m,n) ; 

% Endowments 
endow = ones(m,n) ; 

% Start with a guess 
x = transpose([2,0.5,0.5, 0.5, 2, 0.5, 0.5,0.5,2, 2, 3, 4]) ; 
norm_g = 100 ; 
maxit = 9 ; 
it = 0 ; 
beta = 0 ; 
alpha_step = 0.01;
d = 0 ; 
tolerance = 10^-6 ;  


x_tracker = zeros(n*(m+1),maxit +1) ; 
norm_tracker = zeros(1,maxit) ; 
gradient_tracker = zeros(n*(m+1),maxit+1) ; 
%% 

% Minimize negative utility subject to endowments 
while norm_g > tolerance && it <= maxit 
    grad = gradient(x, endow, lambda, alpha,omega) ; 
    gradient_tracker(:,it+1) = grad ; 

    norm_g = norm(grad) ;
    norm_tracker(1,it+1) = norm_g ; 

    g = gradient(x, endow, lambda, alpha,omega) ; 
    dplus = -g + beta*d;
    
    x_tracker(:,it+1) = x ; 

    x = x + alpha_step.*dplus ; 
    it = it + 1 ;
    gplus = gradient(x, endow, lambda, alpha,omega) ; 

    d = dplus ; 
 
    beta = (transpose(gplus)*gplus)/(transpose(g)*g) ; 
end  

%% 2. Compute Pareto Efficient Allocations (changing parameters) 



%% Function appendix 
% function z = utility(x, alpha, omega)
%     values = transpose(alpha)*(x.^(1 + omega))./(1+omega) ; 
%     z =  -transpose(ones(size(x)))*values ; 
% end 

function z = gradient(x, endow, lambda, alpha, omega)
    x = transpose(reshape(x,3,4)) ;
    [size_x,~] = size(x) ; 
    consumption = x(1:size_x-1,:);
    lagrange = x(size_x,:) ;
    x_values = -transpose(alpha)*(consumption.^omega) ; 
    grad1 = transpose(lambda)*ones(size_x-1,size_x-1).*x_values ;  

    grad2 = ones(1,size_x-1)*(consumption - endow) ; 
    z = [grad1; grad2] ; 
    z = z(:) ;
    %z = consumption*ones(size_x,1) ;
end 