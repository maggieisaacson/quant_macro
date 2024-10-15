% Integration 
% Compute the integral from 0 to T of e^(- rho t) u(1 - e^(- lambda t) dt 
% for T = 100, rho = 0.04, lambda = 0.02, and u(.) = -e ^(-c) using
% quadrature (midpoint, trapezoid, and simpson rule) and a Monte Carlo.
% Then compare the performance. 

%% 0. Housekeeping 
clear variables
close all 

%% 1. Variable Definitions 
T = 100 ; 
rho = 0.04 ; 
lambda = 0.02 ; 

%% 2. Quadrature Methods 
% number of intervals n in quadrature method 
% Match the notation from the notes for clarity 
n = 1000 ; 
a = 0 ; 
b = T ; 
h = (b - a)/n ; 

tic
midpoint_integral = 0 ; 
for j = 1:n
    a_j = a + (j-1)*h;
    b_j = a + (j)*h;
    c_j = (a_j + b_j)/2 ; 
    % Midpoint integral (sum) 
    midpoint_integral = midpoint_integral + (b_j-a_j)*f(c_j,rho,lambda) ;
end 
toc

% Trapezoid integral 
tic
trapezoid_integral = 0 ; 
for j = 1:n-1 
    a_j = a + (j-1)*h;
    b_j = a + (j)*h;
    trapezoid_integral = trapezoid_integral + (b_j-a_j)/2*(f(a_j,rho,lambda) + f(b_j,rho,lambda)) ; 
end 
toc

% Simpson's Rule
tic
simpsons_integral = 0 ; 
for j = 1:n 
    a_j = a + (j-1)*h;
    b_j = a + (j)*h;
    c_j = (a_j + b_j)/2 ; 
    simpsons_integral = simpsons_integral + (b_j - a_j)/6*(f(a_j, rho, lambda) + 4*f(c_j,rho,lambda) + f(b_j, rho, lambda)); 
end 
toc

%% 3. Monte Carlo 
tic
rng(926) ;
mc_integral = 0 ; 
X = 100*rand(n,1) ;
f_X = arrayfun(@f,X,rho*ones(n,1),lambda*ones(n,1)) ;
mc_integral = mean(f_X, "all") ;
toc 

%% 4. Comparison 



%% Function Definitions 
function y = f(x,rho,lambda)
    y = exp(-rho*x)*(-exp(1-exp(-lambda*x)));
end 