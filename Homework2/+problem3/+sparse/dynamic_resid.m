function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(6, 1);
end
[T_order, T] = problem3.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(5, 1);
    residual(1) = (T(1)) - (T(2)*T(3));
    residual(2) = (y(7)^params(5)) - (T(1)*T(4));
    residual(3) = (y(6)+y(8)) - (y(9)+(1-params(3))*y(3));
    residual(4) = (y(9)) - (T(5)*T(6));
    residual(5) = (y(10)) - (params(6)*y(5)+x(1));
end
