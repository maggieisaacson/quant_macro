% After fighting with the full model VFI, I have pivoted. I am going to try
% VFI using a stripped down model to try to get some of the intuition and
% build from there.

% Labor = 1, no taxes, no government spending, no productivity shock 

%% 6.0 Housekeeping 
clear variables 
close all 

% From 6.2 
i_ss = 0.3698 ; 
k_ss = 3.6975 ; 

% Parameter 
alpha = 0.33 ;
beta = 0.97 ;
i_ss = 0.3698 ; 
k_ss = 3.6975 ; 
alpha = 0.33 ;
beta = 0.97 ;
% Create grids 
nk = 10 ; 
% Will likely make them the same for a square matrix, but here we are 
ni = 5 ; 

cap_grid = linspace(0.7*k_ss, 1.3*k_ss,nk) ; 
i_grid = linspace(0.5*i_ss,1.5*i_ss,ni) ; 

%% VFI 
V_0 = zeros(nk,ni) ; 

params = [beta,alpha, cap_grid(1), i_grid(1)] ; 

ipol = zeros(ni,1) ; 
kpol = zeros(nk,1) ; 

for k = nk:1
    for inv = ni:1
    i_guess = [cap_grid(k),i_grid(inv)] ; 
    
    A = [];
    b = [] ;
    Aeq = [] ; 
    beq = [] ; 
    ub = [] ; 
    % nonlcon = []; 
    lb = zeros(1,2) ;
    results = fmincon(@(i_guess) utility(params,i_guess), i_guess,A,b,Aeq,beq,lb) ; 

    ipol(inv,1) = results(1) ;  
    kpol(k,1) = results(2) ; 
    end 
end 
V_1  = - utility(params, results) + beta ; 

% V(k,i-) = max_{k',i} U(k^alpha - i) + beta* V(k',i) 

%% Function appendix 


function results = utility(params,i_guess)
    % Parameters 
    alpha = params(2) ; 
    k = params(3) ; 
    iminus = params(4) ; 

    k_prime = i_guess(1) ;
    inv = i_guess(2); 

    ifunc = isreal(sqrt(20*(1 - (0.9*k - k_prime)/inv)))*(iminus*(1+sqrt(20*(1 - (0.9*k - k_prime)/inv)))) ;

    results = -log(k^alpha - ifunc) ; 
end 