% Hw 2 Problem 1 
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
N = 3 ; 
m = 1 ; 
rho = 0.95 ; 
sigma_e = 0.007 ; 

[Z,Zprob] = tauchen(N,mu_z,rho,sigma_e,m) ; 

% Steady State 
psi = ((1/beta - 0.9)*exp(-Z)).^(1/(alpha-1)) ; 
w_ss = (psi.^alpha).*exp(Z) ; 
r_ss = (psi.^(alpha-1)).*exp(Z) ;

guess = ones(1,3) ; 
l_ss = fsolve(@(l) steady_state(l, w_ss, r_ss, psi,Z,alpha),guess) ; 
k_ss = l_ss.*psi ; 
i_ss = 0.1*k_ss ; 
c_ss = w_ss./l_ss ; 

%% 
% Algorithm for Projection using Chebyshev polynomials 
% Define Basis Functions (here, Chebyshev polynomials) 

% Define a vector of coefficients 




%% 
% Function Appendix 
function [Z,Zprob] = tauchen(N,mu,rho,sigma,m)
    Z     = zeros(N,1);
    Zprob = zeros(N,N);
    a     = (1-rho)*mu;

    Z(N)  = m*sqrt(sigma^2/(1-rho^2));
    Z(1)  = -Z(N);
    zstep = (Z(N)-Z(1))/(N-1);

    for i=2:(N-1)
        Z(i) = Z(1)+zstep*(i-1);
    end 

    Z = Z+a/(1-rho);

    for j = 1:N
        for k = 1:N
            if k == 1
                Zprob(j,k) = normcdf((Z(1)-a-rho*Z(j)+zstep/2)/sigma);
            elseif k == N
                Zprob(j,k) = 1-normcdf((Z(N)-a-rho*Z(j)-zstep/2)/ sigma);
            else
                Zprob(j,k) = normcdf((Z(k)-a-rho*Z(j)+zstep/2)/sigma)-...
                             normcdf((Z(k)-a-rho*Z(j)-zstep/2)/sigma);
            end
        end
    end

    Z=Z';
end 

function [output] = steady_state(l_ss, w_ss, r_ss, psi,Z,alpha) 
   output = w_ss.*l_ss + r_ss.*psi.*l_ss - exp(Z).*((psi.*l_ss).^(alpha)).*(l_ss.^(-(1+alpha))) - 0.1*(psi.*l_ss)  ; 
end 

%% 
% Function Graveyard 

%     sigma_z = sigma_e/(1 - rho^2) ; 
%     z_start = mu_z + m*sigma_z ; 
%     z_end = -z_start ; 
% 
%     z = linspace(z_start,z_end,N) ; 
% 
%     for i = 1:N 
%         for j = 1:N 
%             d_i_j = z(j) - z(i) ; 
%             pi_i_j = (j==N)*(1 - normcdf(z(N) - (d_i_j/2))) ; 
%         end 
%     end 
% %[test,testprob] = tauchen()