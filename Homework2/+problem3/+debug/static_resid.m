function [lhs, rhs] = static_resid(y, x, params)
T = NaN(3, 1);
lhs = NaN(5, 1);
rhs = NaN(5, 1);
T(1) = y(1)^(-params(4));
T(2) = exp(y(5))*y(3)^params(2);
T(3) = y(2)^(1-params(2));
lhs(1) = T(1);
rhs(1) = T(1)*params(1)*(params(2)*y(4)/y(3)+1-params(3));
lhs(2) = y(2)^params(5);
rhs(2) = T(1)*y(4)*(1-params(2))/y(2);
lhs(3) = y(1)+y(3);
rhs(3) = y(4)+y(3)*(1-params(3));
lhs(4) = y(4);
rhs(4) = T(2)*T(3);
lhs(5) = y(5);
rhs(5) = y(5)*params(6)+x(1);
end
