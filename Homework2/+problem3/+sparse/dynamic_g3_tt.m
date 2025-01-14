function [T_order, T] = dynamic_g3_tt(y, x, params, steady_state, T_order, T)
if T_order >= 3
    return
end
[T_order, T] = problem3.sparse.dynamic_g2_tt(y, x, params, steady_state, T_order, T);
T_order = 3;
if size(T, 1) < 17
    T = [T; NaN(17 - size(T, 1), 1)];
end
T(17) = getPowerDeriv(y(6),(-params(4)),3);
end
