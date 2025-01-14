function [lhs, rhs] = dynamic_resid(y, x, params, steady_state)
T = NaN(6, 1);
lhs = NaN(5, 1);
rhs = NaN(5, 1);
T(1) = y(6)^(-params(4));
T(2) = params(1)*(params(2)*y(14)/y(8)+1-params(3));
T(3) = y(11)^(-params(4));
T(4) = (1-params(2))*y(9)/y(7);
T(5) = exp(y(10))*y(3)^params(2);
T(6) = y(7)^(1-params(2));
lhs(1) = T(1);
rhs(1) = T(2)*T(3);
lhs(2) = y(7)^params(5);
rhs(2) = T(1)*T(4);
lhs(3) = y(6)+y(8);
rhs(3) = y(9)+(1-params(3))*y(3);
lhs(4) = y(9);
rhs(4) = T(5)*T(6);
lhs(5) = y(10);
rhs(5) = params(6)*y(5)+x(1);
end