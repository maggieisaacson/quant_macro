% After fighting with the full model VFI, I have pivoted. I am going to try
% VFI using a stripped down model to try to get some of the intuition and
% build from there.

% Labor = 1, no taxes, no government spending, no productivity shock 

%% 6.0 Housekeeping 
clear variables 
close all 

% From 6.2 
i_ss = 0.3698 ; 
k_ss = 3.6975 ; 

% Parameters 
alpha = 0.33 ;
beta = 0.97 ;
delta = 0.1 ;
phi = 2*0.05 ; 
maxit = 100 ; 
tolerance = 10^-4 ; 

% Lower and Upper Bound Factors 
lb_factor = 0.75 ; 
ub_factor = 1.25 ; 

% Create grids 
nk = 250 ; 
% Will likely make them the same for a square matrix, but here we are 
ni = 50 ;  

% Time discount rate 
rho = 1/beta - 1 ; 

%% VFI 

% Wage and Rental Rate 
w_ss = (1-alpha)*k_ss ; 
r_ss = rho + delta ;

k_ss = (r_ss/alpha)^(1/(1-alpha)) ; 
i_ss = 0.1*k_ss ; 
c_ss = k_ss^alpha - i_ss ; 

cap_grid = linspace(lb_factor*k_ss, ub_factor*k_ss,nk) ; 
i_grid = linspace(lb_factor*i_ss,ub_factor*i_ss,ni) ;

% Investment Adjustment Cost over (i,i-) 
adj_cost = (1 - phi/2*(transpose(i_grid)./i_grid - 1).^2 ).* transpose(i_grid) ; 

V_0 = zeros(ni, nk) ;

r_grid = ones(1,1)*ones(ni,nk)*r_ss ; 
w_grid = ones(1,1)*ones(ni,nk)*w_ss ; 

[xx,yy]= ndgrid(i_grid,cap_grid);

tic 
for time = 1:maxit 
    for t = 1:maxit 
        c_grid = r_grid.*cap_grid + w_grid - xx ;
        
        U = log(c_grid) ; 
        
        V_1 = zeros(ni,nk) ; 
        iIpf = zeros(ni,nk) ; 
        ipol = zeros(ni,nk) ; 
        
        Interpolant = griddedInterpolant(xx,yy,V_0) ; 
        
        for ik = 1:nk
            kp = (1- delta)*cap_grid(ik) + adj_cost ;
            cont_value = Interpolant(ones(ni,1)*((i_grid)), kp) ;
             
            obj_func = (1-beta)*U(:,ik)' + beta*cont_value ; 
            
            [Vk, iI] = max(obj_func,[],2) ; 
            
            V_1(:,ik) = Vk ; 
            iIpf(:,ik) = iI; 
            ipol(:,ik) = i_grid(iI) ; 
        
        end 
        err= max(max(abs(V_0-V_1)));
        if (err<tolerance), break; end
        
        V_0 = V_1 ; 
    end 
    
    % Policy Functions 
    kpol = zeros(ni,nk) ; 
    cpol = zeros(ni,nk) ; 
    
    for ik = 1:nk 
        for ii = 1:ni 
            kpol(ii,ik) = (1-delta)*cap_grid(ik) + adj_cost(ii,iIpf(ii,ik)) ;
            cpol(ii,ik) = cap_grid(ik)^alpha - ipol(ii,ik) ; 
        end 
    end 
    
    % Prices 
    r_vfi = alpha*(ones(ni,1)*cap_grid).^(alpha-1) ; 
    w_vfi = (1-alpha)*(ones(ni,1)*cap_grid).^(alpha) ;

    err_r=  max(max(abs(r_grid-r_vfi)));
    err_w=  max(max(abs(w_grid-w_vfi)));
    
    error = max(err_r,err_w) ; 

    if (error<tolerance), break; end
    
    % Price Update
    adjustment = 0.15 ; 
    r_grid = adjustment*r_vfi + (1-adjustment)*r_grid ;
    w_grid = adjustment*w_vfi + (1-adjustment)*w_grid ; 
end 

toc 