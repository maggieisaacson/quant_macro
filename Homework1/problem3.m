% Optimization: Basic Problem 
% Use the Newton-Raphson, BFGS, steepest descent, and conjugate descent
% method to solve the equation 
%  min_{x,y} 100(y - x^2)^2 + (1 - x)^2 

%% 0. Housekeeping 
clear variables 
close all 

% For consistency across methods, maximum iterations allowed and the initial guess will be the
% same and set here 
maxit = 50000 ; 
initial_guess = [1.3; 2] ; 

% Comparison 
times = zeros(4,1) ;
iterations = zeros(4,1) ; 

%% 1. Steepest Descent 

% Start with an initial guess of x and y 
% After looking at a 3D graph of the function, the minimum looks like it's
% around (1,1) so that's where I'll start
tol = 10^-8 ; 
alpha = 0.0001; 

% Ok so it is possibly exactly (1,1) so let's start somewhere else 
x_y_sd = initial_guess ;  
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

times(1,1) = toc ;
iterations(1,1) = it ;

%% 2. Conjugate Descent  

% Initial Guess 
x_y_cd = initial_guess ;  

% Initialize the loop 
n = 100 ; 
it = 0 ; 
beta = 0 ;
d = 0 ;

tic
while n > tol && it < maxit
    % Condition for stopping
    gradient = grad(x_y_cd) ; 
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
    beta = (transpose(gplus)*gplus)/(transpose(g)*g) ;
end

times(2,1) = toc ;  
iterations(2,1) = it ;

%% 3. Newton-Raphson 
% The relationship between x and x+1 will be x+1 = x - gradient/hessian 
% Initial Guess 
x_y_nr = initial_guess ;  

% Initialize the loop 
n = 100 ; 
it = 0 ; 

tic 
while n > tol && it < maxit 
    gradient = grad(x_y_nr) ;
    n = norm(gradient) ; 
    
    hess1 = hess(x_y_nr) ;
    
    x_y_nr = x_y_nr - inv(hess1)*gradient ; 
    it = it + 1 ;
end 
times(3,1) = toc ; 
iterations(3,1) = it ;


%% 4. BFGS 

% Initial Guess 
x_y_bfgs = initial_guess ; 

% Loop Setup 
n = 100 ; 
it = 0 ;
H = [1,2;3,4] ; 

tic
while n > tol && it < maxit 
    gradient = grad(x_y_bfgs) ; 
    n = norm(gradient) ; 
    
    xn = x_y_bfgs ; 
    gradn = gradient ; 
    x_y_bfgs = x_y_bfgs - inv(H)*gradient; 
    
    gradient = grad(x_y_bfgs) ; 
    s = x_y_bfgs - xn ; 
    y = gradient - gradn ;  
    
    H = H + (y*transpose(y))/(transpose(y)*s) - (H*s*transpose(s)*transpose(H))/(transpose(s)*H*s);

    it = it + 1 ; 
end 
times(4,1) = toc ; 
iterations(4,1) = it ;

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
    z = [z1; z2] ;
end 

function z = hess(pair) 
    x = pair(1) ;
    y = pair(2) ; 
    dxx = -400*y + 1200*x^2 + 2;
    dxy = -400*x ; 
    dyy = 200 ;
    z = [dxx, dxy ; dxy, dyy] ; 
end 