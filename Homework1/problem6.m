% Value Function Iteration 

%% 6.0 Housekeeping 
clear variables 
close all 

%% 6.1 Recursive Social Planner's Problem 
% Written in Latex 

%% 6.2 Steady State 
% Find the deterministic steady state associated with tau = 0.25 and z = 0 

% Parameters 
% beta tau z alpha
parameters = [0.97, 0.25, 0, 0.33] ;

% Initial Guess
% Consumption, Investment, Labor, Government, and Capital
i_guess = [1, 0.5, 1, 1, 1] ;

social_planner_results = fsolve(@(x) planner_ss(parameters,x),i_guess) ; 

% Full Solution 
i_guess_full = [1, 1, 1, 1] ; 

competitive_results = fsolve(@(x) comp_ss(parameters,x),i_guess_full) ; 

%% 6.3 Value Function Iteration with Fixed Grid 



%% 6.4 VFI with Endogenous Grid 

%% 6.5 Comparison of Grids 

%% 6.6 Switching between Policy and Value Function Iteration 

%% 6.7 Multigrid 

%% 6.8 Stochastic Grid

%% Function Appendix 
function eqn = planner_ss(parameters, initial_guess) 
    
    % Read in parameters (excluding tau)
    beta = parameters(1) ; 
    z = parameters(3) ;
    alpha = parameters(4) ; 
    
    % Parameters 
    c = initial_guess(1) ;
    inv = initial_guess(2) ;
    l = initial_guess(3) ;
    g = initial_guess (4) ;
    k = initial_guess(5) ; 

    % Need to pull out c, i, g, l, and k
    eqn(1) = 1/c - 0.2/g ; 
    eqn(2) = 0.1*k - (1 - 0.05*(inv/inv-1)^2)*inv ; 
    eqn(3) = c - exp(z)*(1-alpha)*k^alpha*l^(-(1+alpha)) ; 
    eqn(4) = c + inv + g - exp(z)*k^alpha*l^(1-alpha) ; 
    eqn(5) = 1/c + beta*(1/c)*alpha*exp(z)*(k/l)^(alpha-1) - 0.9*beta*1/c ; 
end 

function eqn = comp_ss(parameters,initial_guess)
     % Read in parameters 
    beta = parameters(1) ; 
    tau = parameters(2) ; 
    z = parameters(3) ;
    alpha = parameters(4) ; 
    
    % Parameters 
    c = initial_guess(1) ;
    inv = initial_guess(2) ;
    l = initial_guess(3) ;
    k = initial_guess(4) ; 

    w = (1 - alpha)*exp(z)*(k/l)^alpha ; 
    r = alpha*exp(z)*(k/l)^(alpha-1) ; 
    g = tau*w*l ; 

    eqn(1) = 0.1*k - (1 - 0.05*(inv/inv-1)^2)*inv ; 
    eqn(2) = (1-tau)*w*l + r*k - c - inv ; 
    eqn(3) = (1-tau)*(w/l) - c ; 
    eqn(4) = 1/beta - 0.9 - alpha*exp(z)*(k/l)^(alpha-1) ; 
end 