function [T_order, T] = dynamic_g1_tt(y, x, params, steady_state, T_order, T)
if T_order >= 1
    return
end
[T_order, T] = problem3.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
T_order = 1;
if size(T, 1) < 12
    T = [T; NaN(12 - size(T, 1), 1)];
end
T(7) = getPowerDeriv(y(6),(-params(4)),1);
T(8) = getPowerDeriv(y(11),(-params(4)),1);
T(9) = (-((1-params(2))*y(9)))/(y(7)*y(7));
T(10) = getPowerDeriv(y(7),1-params(2),1);
T(11) = exp(y(10))*getPowerDeriv(y(3),params(2),1);
T(12) = params(1)*params(2)*(-y(14))/(y(8)*y(8));
end
