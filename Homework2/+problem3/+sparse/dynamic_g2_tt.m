function [T_order, T] = dynamic_g2_tt(y, x, params, steady_state, T_order, T)
if T_order >= 2
    return
end
[T_order, T] = problem3.sparse.dynamic_g1_tt(y, x, params, steady_state, T_order, T);
T_order = 2;
if size(T, 1) < 16
    T = [T; NaN(16 - size(T, 1), 1)];
end
T(13) = getPowerDeriv(y(6),(-params(4)),2);
T(14) = getPowerDeriv(y(11),(-params(4)),2);
T(15) = getPowerDeriv(y(7),1-params(2),2);
T(16) = exp(y(10))*getPowerDeriv(y(3),params(2),2);
end
