% Value Function Iteration 

%% 6.0 Housekeeping 
clear variables 
close all 

%% 6.1 Recursive Social Planner's Problem 
% Written in Latex 

%% 6.2 Steady State 
% Find the deterministic steady state associated with tau = 0.25 and z = 0 

% Parameters 
% beta tau z 
parameters = [0.97, 0.25] ;

% Initial Guess
% Investment and Labor 
i_guess = [1, 0.5] ;

results = fsolve(@(x) steady_state(parameters,x),i_guess) ; 

steady_state(parameters,results) 

%% 6.3 Value Function Iteration with Fixed Grid 

%% 6.4 VFI with Endogenous Grid 

%% 6.5 Comparison of Grids 

%% 6.6 Switching between Policy and Value Function Iteration 

%% 6.7 Multigrid 

%% 6.8 Stochastic Grid

%% Function Appendix 
function euler = steady_state(parameters, initial_guess) 
    
    % Read in parameters 
    beta = parameters(1) ; 
    tau = parameters(2) ; 

    inv = initial_guess(1) ;
    l = initial_guess(2) ;

    k = (10*inv) ; 
    r = (k/l)^(-0.67) ; 
    w = (k/l)^(0.33) ; 
    c = (1 - tau)*w*l + r*k - inv ;

    euler(1) = [18*w*l + 4*r*k - 4*inv]/(5*w*l*(3*w*l + 4*r*k - 4*inv)) - (l/w) ; 
    euler(2) = (1/c) - (beta*(0.9-r))/c ; 
    
    %((180*inv) + 4 ((10inv)/l)^(-0.67)*10inv - 4inv)/(15*((10*inv)^(0.33)*l^(0.67))^2 + ... 
       % 20*(10inv/l)^(-0.67)*(10inv)*(10inv/l)^(0.33)*l - 20*inv*(10inv)^0.33*l^0.67) - l*(l/(10*inv))^0.33 ;
    
    % euler(2) =  1/( ((1-tau)*(10inv)^0.33*l^0.67) + ((10inv/l)^(-0.67)*10inv) - inv ) - beta*(0.9 - (10inv/l)^(-0.67) )/(((1-tau)*(10inv)^0.33*l^0.67) + (10inv/l)^(-0.67)*10inv - inv) ;  
end 