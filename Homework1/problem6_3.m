% Value Function Iteration

%% 6.0 Housekeeping 
clear variables 
close all 

% From 6.2 
i_ss = 0.3698 ; 
k_ss = 3.6975 ; 

% Parameter 
alpha = 0.33 ;
beta = 0.97 ;

%% 6.3 Value Function Iteration with Fixed Grid 
% Create grids 
nk = 5 ; 
ni = 2 ; 

cap_grid = linspace(0.7*k_ss, 1.3*k_ss,nk) ; 
i_grid = linspace(0.5*i_ss,1.5*i_ss,ni) ; 

tau_grid = [0.2, 0.25, 0.3] ; 
tau_prob = [0.9, 0.1, 0; 0.05, 0.9, 0.05; 0, 0.1, 0.9] ; 
z_grid = [-0.0673, -0.0336, 0, 0.0336, 0.0673] ; 
z_prob = [0.9727, 0.0273, 0,0,0 ; 0.0041, 0.9806, 0.0153, 0, 0; 0, 0.0082, 0.9836, 0.0082, 0; 0, 0, 0.0153, 0.9806, 0.0041; 0, 0, 0, 0.0273, 0.9727] ;

% Algorithm necessities 
tolerance = 10^-1 ; 

% Steps 
% 0. initial guess for r, w, k, i, z, and tau 
r0 = 0.5*ones(nk,ni,3,5) ; 
w0 = 0.2*ones(nk,ni,3,5) ;

% In order, k, i, tau, z  
values = [cap_grid(1), i_grid(1), tau_grid(1), z_grid(1)] ; 

% 1. Given r, w, do VFI on the household problem, with V0 = 0 
V0 =  zeros(nk,ni,3,5) ; 
V  =  zeros(nk,ni,3,5) ; 

% while sup norm(V_1 - V_0) > tolerance, iterate over the state space 
% Guess for capital and labor 
i_guess = [3, 0.9] ; 

% Parameters 
% beta alpha k i tau z
 
lpol = ones(nk,ni,3,5) ; 
kpol = zeros(nk,ni,3,5) ; 
maxit_all = 10 ; 
it_all = 1 ;

n_r = 100 ; 
n_w = 100 ; 

times = zeros(1,maxit_all-1) ; 
iterations = zeros(1,maxit_all-1) ;

V0(k_ss,i_ss,:,:)

% V_1 = max_(k', l) {U(c,l) + beta \sum_{tau', z') V_0(k', i', z', tau')
% argmax is the kpol and lpol
while n_r > tolerance && n_w > tolerance && it_all < maxit_all

    lpol = zeros(nk,ni,3,5) ; 
    kpol = zeros(nk,ni,3,5) ; 
    n_g = 1000 ; 
    maxit = 10 ; 
    it = 0 ;

    tic
    while n_g > tolerance && it < maxit 
        for k = 1:nk 
            for i_t = 1:ni
                for tau = 1:3 
                    for z = 1:5
                        parameters = [beta, alpha, cap_grid(k), i_grid(i_t), tau_grid(tau), z_grid(z), r0(k,i_t,tau,z), w0(k,i_t,tau,z)] ;
                        options = optimset('Display','off');
                        [pol] = fsolve(@(i_guess) utility(parameters,i_guess), i_guess, options) ; 
                        lpol(k,i_t,tau,z) = pol(2) ; 
                        kpol(k,i_t,tau,z) = pol(1) ; 
                        V(k,i_t,tau,z) = log((1-tau_grid(tau))*(w0(k,i_t,tau,z)/pol(2))) - (pol(2)^2)/2 + beta*V0(k,i_t,tau,z) ;
                    end 
                end 
            end 
        end
        n_g = norm(V-V0,"fro") ; 
        V0 = V ; 
        it = it + 1 ;
    end 
    times(1,it_all) = toc ;
    iterations(1,it_all) = it ; 
    % 2. Given V, kpol, and lpol, calculate  
    % r = alpha kpol^(alpha-1) lpol^(1-alpha) 
    % w = (1-alpha) kpol^alpha lpol^(-alpha) 
    % check sup norm(r - r0) < tolerance, sup norm(w-w0) < tolerance 
    % If yes, done 
    % If no, set r = r0, w = w0 and start over 

    r_calc = exp(z).*alpha.*(kpol.^(alpha-1)).*(lpol.^(1-alpha)) ;
    w_calc = exp(z).*(1 - alpha).*(kpol.^(alpha)).*(lpol.^(-alpha)) ; 

    r_tol = norm(r_calc - r0, "fro") ;
    w_tol = norm(w_calc-w0,"fro") ;

    w0 = w_calc ; 
    r0 = r_calc ;
    it_all = it_all + 1 ;

end 

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
    u(2) = exp(z)*k^alpha*l^(1-alpha) - c - inv - tau*w0*l ; 
 
end 

function inv = investment(inv, iminus, kprime,k)
     inv = kprime - 0.9*k - (1 - 0.05*( (inv/iminus) - 1)^2  )*inv ; 
end 