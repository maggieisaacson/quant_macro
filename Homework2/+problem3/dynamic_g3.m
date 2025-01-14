function g3 = dynamic_g3(T, y, x, params, steady_state, it_, T_flag)
% function g3 = dynamic_g3(T, y, x, params, steady_state, it_, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double   vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double   vector of endogenous variables in the order stored
%                                                     in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double   matrix of exogenous variables (in declaration order)
%                                                     for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double   vector of steady state values
%   params        [M_.param_nbr by 1]        double   vector of parameter values in declaration order
%   it_           scalar                     double   time period for exogenous variables for which
%                                                     to evaluate the model
%   T_flag        boolean                    boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   g3
%

if T_flag
    T = problem3.dynamic_g3_tt(T, y, x, params, steady_state, it_);
end
g3_i = zeros(25,1);
g3_j = zeros(25,1);
g3_v = zeros(25,1);

g3_i(1)=1;
g3_i(2)=1;
g3_i(3)=1;
g3_i(4)=1;
g3_i(5)=1;
g3_i(6)=1;
g3_i(7)=1;
g3_i(8)=1;
g3_i(9)=2;
g3_i(10)=2;
g3_i(11)=2;
g3_i(12)=2;
g3_i(13)=2;
g3_i(14)=2;
g3_i(15)=2;
g3_i(16)=4;
g3_i(17)=4;
g3_i(18)=4;
g3_i(19)=4;
g3_i(20)=4;
g3_i(21)=4;
g3_i(22)=4;
g3_i(23)=4;
g3_i(24)=4;
g3_i(25)=4;
g3_j(1)=223;
g3_j(2)=778;
g3_j(3)=775;
g3_j(4)=779;
g3_j(5)=745;
g3_j(6)=749;
g3_j(7)=445;
g3_j(8)=449;
g3_j(9)=223;
g3_j(10)=224;
g3_j(11)=226;
g3_j(12)=234;
g3_j(13)=236;
g3_j(14)=334;
g3_j(15)=336;
g3_j(16)=334;
g3_j(17)=331;
g3_j(18)=337;
g3_j(19)=301;
g3_j(20)=307;
g3_j(21)=367;
g3_j(22)=1;
g3_j(23)=7;
g3_j(24)=67;
g3_j(25)=667;
g3_v(1)=T(17);
g3_v(2)=(-(T(2)*getPowerDeriv(y(8),(-params(4)),3)));
g3_v(3)=(-(T(12)*T(14)));
g3_v(4)=(-(params(1)*params(2)*1/y(5)*T(14)));
g3_v(5)=(-(T(8)*params(1)*params(2)*(-((-y(9))*(y(5)+y(5))))/(y(5)*y(5)*y(5)*y(5))));
g3_v(6)=(-(T(8)*params(1)*params(2)*(-1)/(y(5)*y(5))));
g3_v(7)=(-(T(3)*params(1)*params(2)*(y(5)*y(5)*y(5)*y(5)*(-(2*(-y(9))))-(-((-y(9))*(y(5)+y(5))))*(y(5)*y(5)*(y(5)+y(5))+y(5)*y(5)*(y(5)+y(5))))/(y(5)*y(5)*y(5)*y(5)*y(5)*y(5)*y(5)*y(5))));
g3_v(8)=(-(T(3)*params(1)*params(2)*(y(5)+y(5))/(y(5)*y(5)*y(5)*y(5))));
g3_v(9)=(-(T(4)*T(17)));
g3_v(10)=(-(T(9)*T(13)));
g3_v(11)=(-((1-params(2))/y(4)*T(13)));
g3_v(12)=(-(T(7)*(-((-((1-params(2))*y(6)))*(y(4)+y(4))))/(y(4)*y(4)*y(4)*y(4))));
g3_v(13)=(-(T(7)*(-(1-params(2)))/(y(4)*y(4))));
g3_v(14)=getPowerDeriv(y(4),params(5),3)-T(1)*(y(4)*y(4)*y(4)*y(4)*(-(2*(-((1-params(2))*y(6)))))-(-((-((1-params(2))*y(6)))*(y(4)+y(4))))*(y(4)*y(4)*(y(4)+y(4))+y(4)*y(4)*(y(4)+y(4))))/(y(4)*y(4)*y(4)*y(4)*y(4)*y(4)*y(4)*y(4));
g3_v(15)=(-(T(1)*(-((y(4)+y(4))*(-(1-params(2)))))/(y(4)*y(4)*y(4)*y(4))));
g3_v(16)=(-(T(5)*getPowerDeriv(y(4),1-params(2),3)));
g3_v(17)=(-(T(11)*T(15)));
g3_v(18)=(-(T(5)*T(15)));
g3_v(19)=(-(T(10)*T(16)));
g3_v(20)=(-(T(10)*T(11)));
g3_v(21)=(-(T(5)*T(10)));
g3_v(22)=(-(T(6)*exp(y(7))*getPowerDeriv(y(1),params(2),3)));
g3_v(23)=(-(T(6)*T(16)));
g3_v(24)=(-(T(6)*T(11)));
g3_v(25)=(-(T(5)*T(6)));
g3 = sparse(g3_i,g3_j,g3_v,5,1000);
end
