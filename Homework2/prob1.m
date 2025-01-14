% HW 2 Problem 1 
% Compute the solution to the model when you use six
% Chebyshev polynomials on capital and a three-point finite approximation
% to zt using Tauchen s method.
% Maggie Isaacson

clear all 
clc 

%% Parameters and Grids 
% Parameters 
beta = 0.97 ; % Time discount factor 
alpha = 0.33 ; % Capital Share 
delta = 0.1 ; % Depreciation 

% Euler errors
grid_num  = 100 ;                  % Capital Grid Size (increase later) 

% Discretize the AR(1) process into 3 points using Tauchen 
% From notes, K = 1, N = 3
mu_z = 0 ;
N = 3 ; 
m = 1 ; 
rho_z = 0.95 ; 
sigma_e = 0.007 ; 
z = 0 ; 
sigma=  1;
psi=    1;

% Steady State 
% useful constants
rho=    1/beta-1;
y_k=    (rho+delta)/alpha;
k_l=    y_k^( 1/(alpha-1) );

% steady-states
c_ss=    (( k_l^alpha - delta*k_l ) *( (1-alpha)*(k_l)^alpha )^(1/psi))^( 1/( 1 + sigma/psi )) ;
l_ss=    ( (1-alpha)* k_l^alpha * c_ss^(-sigma) )^(1/psi);
k_ss=    k_l*l_ss;
y_ss=    y_k*k_ss;
x_ss=    [c_ss l_ss k_ss y_ss ]'; 

v_ss = log(c_ss) - (l_ss.^2/2) ; 

[Z,Zprob] = tauchen(N,mu_z,rho_z,sigma_e,m) ; 

%% 
% Algorithm for Projection using Chebyshev polynomials 
% Define boundaries for capital
cover_grid = 0.25;
k_min = k_ss*(1-cover_grid);
k_max = k_ss*(1+cover_grid);
interval = k_ss*2*cover_grid;

multinode_step = 1 ; 
node_num = 6 ;
M = node_num*N;

% Find Zeros of the Chebychev Polynomial on order M 
ZC = -cos((2*(1:node_num)'-1)*pi/(2*node_num));

% Define Chebychev polynomials
T_k = ones(node_num,node_num);
T_k(:,2) = ZC;
for i1 = 3:node_num
       T_k(:,i1) = 2*ZC.*T_k(:,i1-1)-T_k(:,i1-2);
end

% Project collocation points in the K space
grid_k = ((ZC+1)*(k_max-k_min))/2+k_min;

% Initial Guess for Chebyshev coefficients on labor and value 
rho_guess = zeros(2*M,1);
if(multinode_step == 1)
    for z_index = 1:N
        rho_guess((z_index-1)*node_num+1)   = v_ss;
        rho_guess((z_index-1)*node_num+M+1) = l_ss;
    end
else
    for z_index = 1:2*N
        rho_guess((z_index-1)*node_num+1:(z_index-1)*node_num+node_num_old)...
            = rho_old((z_index-1)*node_num_old+1:z_index*node_num_old);
    end
end

options = optimset('Display','Iter','TolFun',10^(-15),'TolX',10^(-15));
rho = fsolve(@(rho) residual_fcn(alpha,beta,delta,k_min,k_max,rho_guess,grid_k,T_k,Z,Zprob,node_num,N,M),rho_guess,options);
rho_old = rho;
node_num_old = node_num;

grid_k_complete = zeros(grid_num,1);

for i = 1:grid_num
    grid_k_complete(i) = k_min+(i-1)*interval/(grid_num-1);
end

[g_k,g_c,g_l,value_fcn,euler_error,max_error]= ...
    eulerr_grid_mine(alpha,beta,delta,rho,Z,Zprob,...
    k_min,k_max,grid_k_complete,N,node_num,grid_num,M);

% Decision Rules
figure(1)
subplot(2,2,1)
plot(grid_k_complete,value_fcn)
title('Value Function')
subplot(2,2,2)
plot(grid_k_complete,g_c)
title('Consumption Decision Rule')
subplot(2,2,3)
plot(grid_k_complete,g_l)
title('Labor Decision Rule')
subplot(2,2,4)
plot(grid_k_complete,g_k,grid_k_complete,grid_k_complete)
title('Capital Decision Rule')


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

function res = residual_fcn(alpha,beta,delta,k_min,k_max,rho_guess,grid_k,T_k,Z,Zprob,node_num,N,M);
    residual_section = zeros(node_num*2,1);
    res = zeros(M*2,1);
    
    rho1 = rho_guess(1:M,1);     % Coefficients for value function
    rho2 = rho_guess(M+1:2*M,1); % Coefficients for labor
        
    for z_index = 1:N 

            value = zeros(node_num,1);
            g_l   = zeros(node_num,1);
            g_k   = zeros(node_num,1);
            g_c   = zeros(node_num,1);
    
            rho1_section = rho1(((z_index-1)*node_num+1):z_index*node_num);
            rho2_section = rho2(((z_index-1)*node_num+1):z_index*node_num);

            for k_index = 1:node_num % Loop 1 over collocation point on k
        
                value(k_index) = dot(rho1_section,T_k(k_index,:));  % value function at each collocation points
                l = dot(rho2_section,T_k(k_index,:));               % labor at each collocation points
                k = grid_k(k_index);

                if(l<0.1)
                    l = 0.1;
                    disp('l break lower bound')
                elseif(l>0.9)
                    l = 0.9;
                    disp('l break upper bound')
                end
                
                g_l(k_index) = l;

                y = exp(Z(z_index))*k^alpha*l^(1-alpha);
                w = (1-alpha)*exp(Z(z_index))*(k/l)^alpha ; 
                c = w/l ;
                kp = y-c+(1-delta)*k;
                if(kp < k_min)
                    kp = k_min+0.01;
                    disp('kp break lower bound')
                elseif((kp > y+(1-delta)*k-c) || (kp > k_max))
                    kp = min(y+(1-delta)*k-c,k_max) - 0.01;
                    disp('kp break upper bound')
                end
            
                g_k(k_index) = kp;
                i = kp - (1-delta)*k ; 
                c = y - i ;
            
                if(c<0)
                    disp('warning: c < 0')
                    c = 10^(-10);
                end
            
                g_c(k_index) = c;

            end % Loop 1 over collocation point on k ends

            % scale k prime from [k_min,k_max] to [-1,1]
            g_k_scaled_down = (2*g_k-(k_min+k_max))/(k_max-k_min);
    
            % value of polynomials at each scaled k prime
            T_g_k = ones(node_num,node_num);
            T_g_k(:,2) = g_k_scaled_down;
            
            for i1=3:node_num
                T_g_k(:,i1) = 2*g_k_scaled_down.*T_g_k(:,i1-1)-T_g_k(:,i1-2);
            end


            % Calculate residual
            for k_index = 1:node_num % Loop 2 over collocation point on k
        
                vp = zeros(N,1);
                temp = zeros(N,1);
            
                for zp_index = 1:N

                    rho1_section = rho1(((zp_index-1)*node_num+1):zp_index*node_num);
                    rho2_section = rho2(((zp_index-1)*node_num+1):zp_index*node_num);
                    vp(zp_index) = dot(rho1_section,T_g_k(k_index,:));
                    lp = dot(rho2_section,T_g_k(k_index,:));     

                    if(lp<0.1)
                        lp = 0.1;
                        disp('lp break lower bound')
                    elseif(lp>0.9)
                        lp = 0.9;
                        disp('lp break upper bound')
                    end

                    yp = exp(Z(zp_index))*g_k(k_index)^alpha*lp^(1-alpha);
                    wp = (1-alpha)*exp(Z(zp_index))*(g_k(k_index)/lp)^alpha ;
                    cp = wp/lp ;
                    kpp = yp+(1-delta)*g_k(k_index)-cp;

                    if(kpp<k_min)
                        kpp = k_min+0.01;
                        disp('kpp break lower bound')
                    elseif((kpp>yp+(1-delta)*g_k(k_index)-cp) || (kpp>k_max))
                        kpp = min(yp+(1-delta)*g_k(k_index)-cp,k_max) - 0.01;
                        disp('kpp break upper bound')
                    end

                    cp = yp+(1-delta)*g_k(k_index)-kpp;
                    if(cp<0)
                        disp('warning: cp < 0')
                        cp = 10^(-10);
                    end             

                    Ucp = 1/cp ;
                    Fkp = alpha*exp(Z(zp_index))*g_k(k_index)^(alpha-1)*lp^(1-alpha);
                    temp(zp_index) = Ucp*(Fkp+1-delta);
            
                end

                euler_rhs = beta*dot(Zprob(z_index,:),temp);

                l = g_l(k_index);
                c = g_c(k_index);
                
                euler_lhs = 1/c ;
                bellman_rhs = (1-beta)*(log(c) - (l^2)/2 )...
                              +beta*dot(Zprob(z_index,:),vp);
                bellman_lhs = value(k_index);

                residual_section(k_index) = euler_rhs - euler_lhs;
                residual_section(node_num+k_index) = bellman_rhs - bellman_lhs;

            end % Loop 2 over k ends
    
            res(((z_index-1)*node_num*2+1):z_index*node_num*2) = residual_section; 
    end 
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