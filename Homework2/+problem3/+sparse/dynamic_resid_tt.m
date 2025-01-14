function [T_order, T] = dynamic_resid_tt(y, x, params, steady_state, T_order, T)
if T_order >= 0
    return
end
T_order = 0;
if size(T, 1) < 6
    T = [T; NaN(6 - size(T, 1), 1)];
end
T(1) = y(6)^(-params(4));
T(2) = params(1)*(params(2)*y(14)/y(8)+1-params(3));
T(3) = y(11)^(-params(4));
T(4) = (1-params(2))*y(9)/y(7);
T(5) = exp(y(10))*y(3)^params(2);
T(6) = y(7)^(1-params(2));
end
