function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(3, 1);
end
[T_order, T] = problem3.sparse.static_resid_tt(y, x, params, T_order, T);
residual = NaN(5, 1);
    residual(1) = (T(1)) - (T(1)*params(1)*(params(2)*y(4)/y(3)+1-params(3)));
    residual(2) = (y(2)^params(5)) - (T(1)*y(4)*(1-params(2))/y(2));
    residual(3) = (y(1)+y(3)) - (y(4)+y(3)*(1-params(3)));
    residual(4) = (y(4)) - (T(2)*T(3));
    residual(5) = (y(5)) - (y(5)*params(6)+x(1));
end
