% Optimization: Basic Problem 
% Use the Newton-Raphson, BFGS, steepest descent, and conjugate descent
% method to solve the equation 
%  min_{x,y} 100(y - x^2)^2 + (1 - x)^2 

%% 0. Housekeeping 
clear variables 
close all 

% For consistency across methods, maximum iterations allowed will be the
% same and set here 
maxit = 10000 ; 

%% 1. Steepest Descent 

% Start with an initial guess of x and y 
% After looking at a 3D graph of the function, the minimum looks like it's
% around (1,1) so that's where I'll start
tol = 10^-8 ; 
alpha = 0.0001; 

% Ok so it is possibly exactly (1,1) so let's start somewhere else 
x_y_sd = [0.5, 1.5] ;  
n = 100 ; 
it = 0 ; 

tic
% Check termination condition 
% Is the gradient very close to 0? 
while n > tol && it < maxit
    gradient = grad(x_y_sd) ; 
    n = norm(gradient) ;  
    
    % Determine descent direction 
    % d = - gradient(f(x_k))/norm(gradient(f(x_k))) 
    d = -gradient./n ; 
    
    % Step size 
    % Probably just do a small deterministic step size? (alpha set above) 
    
    % Next point and start over 
    % New point 
    x_y_sd = x_y_sd + alpha.*d ; 
    it = it + 1 ; 
end 

toc 

%% 2. Conjugate Descent  

% Initial Guess 
x_y_cd = [0.5, 1.5] ;  

% Initialize the loop 
n = 100 ; 
it = 0 ; 
beta = 0 ;
d = 0 ;

tic
while n > tol && it < maxit
    % Condition for stopping 
    n = norm(gradient) ; 
     
    % Calculate new direction 
    g= grad(x_y_cd) ; 
    dplus = -g + beta*d;
    
    % Create new guess 
    x_y_cd = x_y_cd + alpha.*dplus ; 
    it = it + 1 ; 
    
    % New gradient for beta 
    gplus = grad(x_y_cd) ; 

    % Save old d for next loop 
    d = dplus ; 

    % Update beta for next loop 
    beta = (gplus*transpose(gplus))/(g*transpose(g)) ;
end

toc 

%% 3. Newton-Raphson 


%% 4. BFGS 


%% Function Appendix 
function z = f(pair)
    x = pair(1) ;
    y = pair(2) ; 
    z = 100*(y -x^2)^2 + (1-x)^2 ; 
end 

function z = grad(pair)
    x = pair(1) ;
    y = pair(2) ; 
    z1 = 200*(y - x^2)*(-2*x) - 2*(1-x) ;
    z2 = 200*(y-x^2) ;
    z = [z1,z2] ;
end 
