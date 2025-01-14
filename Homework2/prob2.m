% HW2 Problem 2: Finite Elements 
% Compute the solution to the model when you use
% eight finite elements on capital and a three-point finite approximation
% to zt using Tauchen s method. Use a Galerkin weighting scheme.
% Maggie Isaacson 

clear all 
clc 

%% Parameters and Grids 
% Parameters 
beta = 0.97 ; % Time discount factor 
alpha = 0.33 ; % Capital Share 
delta = 0.1 ; % Depreciation 

% Discretize the AR(1) process into 3 points using Tauchen 
% From notes, K = 1, N = 3
mu_z = 0 ;
n_z = 3 ; 
m = 1 ; 
rho = 0.95 ; 
sigma_e = 0.007 ; 
z = 0 ; 
eta=    1;

% Options 
options= optimset('Display','Iter','TolFun',1e-15,'TolX',1e-15);

[Z,Zprob] = tauchen(n_z,mu_z,rho,sigma_e,m) ; 

% Build capital grid centered around k_ss from problem 1 
% k_ss from problem 1 
k_ss = 2.0514 ; 
n= 9*0 + 71;
grid_num = n ; 
cover_grid = 0.25;
k_min = k_ss*(1-cover_grid);
k_max = k_ss*(1+cover_grid);
interval = k_ss*2*cover_grid;
k_grid = zeros(grid_num,1) ; 

for i = 1:grid_num
    k_grid(i) = k_min+(i-1)*interval/(grid_num-1);
end

dnk=    1001;
dkg=    linspace(k_min,k_max,dnk)';

%% Finite Elements with Galerkin Weighting 
% Gauss-Legendre Quadrature 
quad_num = 10 ; 
x_grid = zeros(quad_num,grid_num-1) ; 
w_grid = zeros(quad_num,grid_num-1) ; 

for i = 1:(n-1)
   [x_grid(:,i), w_grid(:,i)] = gl_quad(k_grid(i), k_grid(i+1)) ;
end

% Initial Guess 
ths = initial_guess(k_grid, grid_num,Z, n_z, Zprob, beta, eta, alpha,delta,0,options) ; 
th0 = ths(:) ; % Vectorize 

theta = th0 ; 
    % Undo vectorizing of THS 
    theta = reshape(theta,grid_num,n_z ) ; 
    
    % Vectorize 
    x = x_grid(:) ; 
    w = w_grid(:) ; 
    nq = quad_num*(n-1) ; 

    psi_q = tent_basis(x, nq, k_grid, n) ; 
    c_hat = psi_q*theta ; 

    L = ((1 - alpha)*x.^alpha * exp(Z)) ./c_hat ; 
    L = L.^(1/(eta+alpha)) ; 

% Finite Elements 
% fsolve(@(theta) FE_residual(theta,n, x_grid, w_grid, quad_num, k_grid, n_k,Z, N, Zprob, beta, eta, alpha,delta), th0, options) ; 

%% Euler Residuals 

%% Plotting
% Build a denser capital grid to plot with 


%% Function Appendix
function [psi_i] = tent_basis(x_grid, n_x, k_grid, grid_num) 
    psi_i = zeros(n_x, grid_num) ; 

    for i=1:grid_num 
        if (i==1) 
            k1 = k_grid(i) ; 
            k2 = k_grid(i+1) ; 

            log_grid = (x_grid <= k2) ; 
            psi_i(:,i) = (k2 - x_grid)/(k2 - k1).*log_grid ; 
        elseif (i < grid_num) 
            k0 = k_grid(i-1) ; 
            k1 = k_grid(i) ; 
            k2 = k_grid(i+1) ;

            log_grid1 = (x_grid > k0).*(x_grid <= k1) ; 
            log_grid2 = (x_grid > k1).*(x_grid <= k2) ;

            psi_i(:,i) = (x_grid - k0)/(k1-k0).*log_grid1 + (k2 - x_grid)/(k2-k1).*log_grid2 ;
        else 
            k0 = k_grid(i-1) ; 
            k1 = k_grid(i) ; 

            log_grid = (x_grid > k0) ; 

            psi_i(:,i) = (x_grid - k0)/(k1-k0).*log_grid ; 
        end 
    end
end 

function [x_vec, w_vec] = gl_quad(vec_a, vec_b) 
    % Nodes 
    x = [ 0.1488743389  0.4333953941  0.6794095682  0.8650633666  0.9739065285 ];
    x=  [ -x(5:-1:1) x ]' ;
    
    % Weights 
    w=  [ 0.2955242247  0.2692667193  0.2190863625  0.1494513491  0.0666713443 ];
    w=  [ w(5:-1:1) w ]' ;

    % Set in interval 
    x_vec = (vec_b - vec_a)/2 *x + (vec_a + vec_b)/2 ; 
    w_vec = (vec_b - vec_a)/2 *w ; 
end 

function [theta] = initial_guess(k_grid, grid_num, Z, N, Zprob, beta, eta, alpha,delta, do_refined_guess, opt)
    % Start with the deterministic model 
    cons0 = (1 - alpha*beta)*k_grid.^alpha *exp(Z) ; 
    theta = cons0(:) ; 

end 

function error = FE_residual(theta,n, x_grid, w_grid, quad_num, k_grid, grid_num,Z, n_z, Zprob, beta, eta, alpha,delta)
    % Undo vectorizing of THS 
    theta = reshape(theta,grid_num, n_z) ; 
    
    % Vectorize 
    x = x_grid(:) ; 
    w = w_grid(:) ; 
    nq = quad_num*(n-1) ; 

    psi_q = tent_basis(x, nq, k_grid, n) ; 
    c_hat = psi_q*theta ; 

    L = ((1 - alpha)*k.^alpha * exp(Z)) ./c_hat ; 
    L = L.^(1/(eta+alpha)) ; 

    kp = k.^alpha .*L ;

end 
