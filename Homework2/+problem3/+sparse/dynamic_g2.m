function [g2_v, T_order, T] = dynamic_g2(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(16, 1);
end
[T_order, T] = problem3.sparse.dynamic_g2_tt(y, x, params, steady_state, T_order, T);
g2_v = NaN(17, 1);
g2_v(1)=T(13);
g2_v(2)=(-(T(2)*T(14)));
g2_v(3)=(-(T(8)*T(12)));
g2_v(4)=(-(T(8)*params(1)*params(2)*1/y(8)));
g2_v(5)=(-(T(3)*params(1)*params(2)*(-((-y(14))*(y(8)+y(8))))/(y(8)*y(8)*y(8)*y(8))));
g2_v(6)=(-(T(3)*params(1)*params(2)*(-1)/(y(8)*y(8))));
g2_v(7)=(-(T(4)*T(13)));
g2_v(8)=(-(T(7)*T(9)));
g2_v(9)=(-(T(7)*(1-params(2))/y(7)));
g2_v(10)=getPowerDeriv(y(7),params(5),2)-T(1)*(-((-((1-params(2))*y(9)))*(y(7)+y(7))))/(y(7)*y(7)*y(7)*y(7));
g2_v(11)=(-(T(1)*(-(1-params(2)))/(y(7)*y(7))));
g2_v(12)=(-(T(5)*T(15)));
g2_v(13)=(-(T(10)*T(11)));
g2_v(14)=(-(T(5)*T(10)));
g2_v(15)=(-(T(6)*T(16)));
g2_v(16)=(-(T(6)*T(11)));
g2_v(17)=(-(T(5)*T(6)));
end
