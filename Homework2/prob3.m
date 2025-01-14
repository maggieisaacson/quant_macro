% HW 2 Problem 3: Perturbation 
% Find a third-order perturbation solution to the model.
% Maggie Isaacson 

clear all 
clc 

% Ensure that we're in the right folder- I had issues calling it for awhile
cd C:\Users\misaa\Documents\Year2\quant_macro\quant_macro\Homework2 ;

% Shocks 
mu_z = 0 ;
n_z = 3 ; 
m = 1 ; 
rho = 0.95 ; 
sigma_e = 0.007 ; 
[Z,Zprob] = tauchen(n_z,mu_z,rho,sigma_e,m) ; 

% Capital Grid 
k_ss = 3.7612 ; 
kss_fac  = 0.25;
dn_k = 1001 ; 
k_min=   (1-kss_fac)*k_ss;
k_max=   (1+kss_fac)*k_ss;
dk_grid=    linspace(k_min,k_max,dn_k)';

% Call and execute dynare file 
dynare problem3.mod ;

% Read in decision rules  and approximation order 
decision_rules = oo_.dr ; 
approx_order=   options_.order;
% State grids 
z_dev = Z ; 
k_dev = dk_grid - k_ss ; 

% Policy Functions 
g_c = perturbed(k_dev, z_dev, decision_rules, 4, approx_order) ; 
g_l = perturbed(k_dev, z_dev, decision_rules, 1, approx_order) ; 
g_kp = perturbed(k_dev, z_dev, decision_rules, 2, approx_order) ;
value_function = log(g_c) - (g_l.^2)/2 ; 

%% Figures 
figure(1)
subplot(2,2,1)
plot(dk_grid,value_function)
title('Value Function')
subplot(2,2,2)
plot(dk_grid,g_c)
title('Consumption Decision Rule')
subplot(2,2,3)
plot(dk_grid,g_l)
title('Labor Decision Rule')
subplot(2,2,4)
plot(dk_grid,g_kp)
title('Capital Decision Rule')


%% Function Appendix 
function policy_function = perturbed(k_dev, z_dev, decision_rule,index, approx_order) 
    % Coefficients 
    G0 = decision_rule.ys(decision_rule.order_var) ; 

    if (approx_order > 1) 
        GS2 = decision_rule.ghs2(decision_rule.order_var) ; 
    else 
        GS2 = 0*G0 ; 
    end 

    G1 = decision_rule.ghx ; 

    % Terms  
    constants = G0(index) + (1/2)*(GS2(index)) ; 

    g_k = G1(index,1)*k_dev ; 
    g_z = G1(index,2)*z_dev ; 
    order1 = g_k + g_z ; 

    order2 =  0; 
    if (approx_order > 1) 
        G2 = decision_rule.ghxx ; 
        g_k2 = G2(index,1)*k_dev.^2 ; 
        g_kz = (1/2)*sum( G2(index,[2 3]) )*k_dev * z_dev ; 
        g_z2 = G2(index,4) * z_dev.^2 ;

        order2 = (1/2)*(g_k2 + g_kz + g_z2) ;
    end 

    order3 = 0 ; 
    if (approx_order>2) 
        G3 = decision_rule.ghxxx ; 
        g_k3 = G3(index,1) * k_dev.^3 ; 
        g_zk2 = (1/3)* sum(G3(index,[2 3 5])) * k_dev.^2 * z_dev ; 
        g_kz2 = (1/3)*sum(G3(index,[4 6 7])) * k_dev * z_dev.^2 ; 
        g_z3 = G3(index,8) * z_dev.^3 ; 

        order3 = (1/6)*(g_k3 + g_kz2 + g_zk2 + g_z3) ; 
    end 

    policy_function = constants + order1 + order2 + order3 ; 
end 



