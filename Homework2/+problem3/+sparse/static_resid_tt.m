function [T_order, T] = static_resid_tt(y, x, params, T_order, T)
if T_order >= 0
    return
end
T_order = 0;
if size(T, 1) < 3
    T = [T; NaN(3 - size(T, 1), 1)];
end
T(1) = y(1)^(-params(4));
T(2) = exp(y(5))*y(3)^params(2);
T(3) = y(2)^(1-params(2));
end
