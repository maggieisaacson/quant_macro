% Value Function Iteration

%% 6.0 Housekeeping 
clear variables 
close all 

% From 6.2 
i_ss = 0.3698 ; 
k_ss = 3.6975 ; 

%% 6.3 Value Function Iteration with Fixed Grid 
% Create grids 
nk = 50 ; 
ni = 10 ; 

cap_grid = linspace(0.7*k_ss, 1.3*k_ss,nk) ; 
i_grid = linspace(0.5*i_ss,1.5*i_ss,ni) ; 
tau_grid = [0.2, 0.25, 0.3] ; 
z_grid = [-0.0673, -0.0336, 0, 0.0336, 0.0673] ; 

% Algorithm necessities 
tolerance = 10^-6 ; 
maxit = 1000 ; 

% Steps 
% 0. initial guess for r, w, k, i, z, and tau 
r0 = 0.1*ones(nk,ni) ; 
w0 = 0.2*ones(nk,ni) ;

% In order, k, i, tau, z  
values = [cap_grid(1), i_grid(1), tau_grid(1), z_grid(1)] ; 

% 1. Given r, w, do VFI on the household problem, with V0 = 0 
V0 = 0 ; 

% while sup norm(V_1 - V_0) > tolerance, iterate over the state space 
% Guess for capital and labor 
i_guess = [3, 0.9] ; 

% Parameters 
% beta alpha k i tau z

lpol = zeros(nk,ni) ; 
kpol = zeros(nk,ni) ; 

tic
for k = 1:nk 
    for i_t = 1:ni
        parameters = [0.97, 0.33, cap_grid(k), i_grid(i_t), tau_grid(1), z_grid(1), r0(nk,ni), w0(nk,ni)] ;
        options = optimset('Display','off');
        results = fsolve(@(i_guess) utility(parameters,i_guess), i_guess, options) ; 
        lpol(k,i_t) = results(2) ; 
        kpol(k,i_t) = results(1) ; 
    end 
end
toc 



% V_1 = max_(k', l) {U(c,l) + beta \sum_{tau', z') V_0(k', i', z', tau')
% argmax is the kpol and lpol


% 2. Given V, kpol, and lpol, calculate  
% r = alpha kpol^(alpha-1) lpol^(1-alpha) 
% w = (1-alpha) kpol^alpha lpol^(-alpha) 
% check sup norm(r - r0) < tolerance, sup norm(w-w0) < tolerance 
% If yes, done 
% If no, set r = r0, w = w0 and start over 

%% Function Appendix 

function u = utility(parameters,i_guess) 
    % Read in parameters 
    % beta alpha k i tau z r0 w0 
    alpha = parameters(2); 
    k = parameters(3) ; 
    iminus = parameters(4) ; 
    tau = parameters(5) ; 
    z = parameters(6) ; 
    r0 = parameters(7) ; 
    w0 = parameters(8) ; 
    
    % Initial Guess 
    kprime = i_guess(1) ;
    l = i_guess(2) ;

    % Necessary 
    c = (w0/l)*(1-tau)  ;

    guess = 0.1 ; 
    options = optimset('Display','off');
    inv = fsolve(@(inv) investment(inv, iminus, kprime, k), guess, options) ;  
    
    u(1) = (1-tau)*w0*l + r0*k - c - inv ; 
 
end 

function inv = investment(inv, iminus, kprime,k)
     inv = kprime - 0.9*k - (1 - 0.05*( (inv/iminus) - 1)^2  )*inv ; 
end 