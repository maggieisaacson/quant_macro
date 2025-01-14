function [T_order, T] = static_g1_tt(y, x, params, T_order, T)
if T_order >= 1
    return
end
[T_order, T] = problem3.sparse.static_resid_tt(y, x, params, T_order, T);
T_order = 1;
if size(T, 1) < 4
    T = [T; NaN(4 - size(T, 1), 1)];
end
T(4) = getPowerDeriv(y(1),(-params(4)),1);
end
