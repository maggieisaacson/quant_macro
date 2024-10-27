% Problem 5
% Using the same model as in problem 4, can you find the prices? 

%% 0. Housekeeping 
clear variables 
close all 

%% 1. Find Prices 

% "Hyperparameters" 
m = 3 ; 
n = 3 ; 

% Alpha > 0 
alpha = 0.5*ones(n,m) ; 

% Omega < 0
omega = -2*ones(n,m) ; 

% Endowments 
individual_endow = ones(n,m) ; 
total_endow = transpose(individual_endow)*ones(n,1) ; 

% Start with a guess 
x0 = [2;3] ; 

% Allocation from (4) 
x1 = [0; 2.3218 ; 0.6782] ; 

setup(x0, x1, total_endow,alpha,omega) ; 

fsolve(@(x) setup(x,x1, total_endow,alpha,omega),x0)


%% Function Appendix 
function z = setup(x0, x1, total_endow, alpha, omega)
    % Read in input 
    p2 = x0(1) ; 
    p3 = x0(2) ; 
    
    alpha1 = alpha(:,1) ; 
    alphas = alpha./alpha1 ; 

    z(2) = ones(1,3)*((alphas(:,2).*p2.*x1.^omega(:,2)).^(1./omega(:,2))) - total_endow(2) ;
    z(3) = ones(1,3)*((alphas(:,3).*p2.*x1.^omega(:,3)).^(1./omega(:,3))) - total_endow(3) ; 

end 