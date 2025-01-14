// Dynare Model for Problem 3  

// Parameters 
parameters beta, alpha, delta, sigma, psi, phi, sd_e
 rho, y_k, k_l ; 

beta = 0.97 ; 
alpha = 0.33 ; 
delta = 0.1 ; 
psi = 1 ; 
sigma = 1 ;
 
phi = 0.95 ; 
sd_e = 0.007 ; 

// constants 
rho = (1/beta) - 1 ; 
y_k = (rho + delta)/alpha ; 
k_l = y_k^(1/(alpha-1)) ;

// Declare Variables 
var c, l, k, y, z ; 
varexo e ;

// Optimality 

model ; 

// Euler Equation 
c^(-sigma) = beta*(alpha*(y(+1)/k) + (1-delta)) * c(+1)^(-sigma) ; 

// Labor FOC 
l^psi = (1-alpha)*y/l * c^(-sigma) ;  

// budget constraint 
c + k = y + (1-delta)*k(-1) ;

// Output 
y = exp(z)*k(-1)^alpha*l^(1-alpha) ; 

// productivity 
z = phi*z(-1) + e ;

end ; 

// Shocks 
shocks ; 
var e ; 
stderr sd_e ; 
end ; 

stoch_simul(order=3,irf=0) ; 

// steady state 

initval; 
c = ((k_l^alpha - delta*k_l) * ((1-alpha)*(k_l)^alpha)^(1/psi))^(1/(1+sigma/psi)) ; 
l = ((1-alpha)*k_l^alpha * c^(-sigma))^(1/psi) ; 
k = k_l*l ; 
y = y_k*k ; 
e = 0 ; 
end ; 