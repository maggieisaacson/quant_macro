function [g3_v, T_order, T] = dynamic_g3(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(17, 1);
end
[T_order, T] = problem3.sparse.dynamic_g3_tt(y, x, params, steady_state, T_order, T);
g3_v = NaN(25, 1);
g3_v(1)=T(17);
g3_v(2)=(-(T(2)*getPowerDeriv(y(11),(-params(4)),3)));
g3_v(3)=(-(T(12)*T(14)));
g3_v(4)=(-(params(1)*params(2)*1/y(8)*T(14)));
g3_v(5)=(-(T(8)*params(1)*params(2)*(-((-y(14))*(y(8)+y(8))))/(y(8)*y(8)*y(8)*y(8))));
g3_v(6)=(-(T(8)*params(1)*params(2)*(-1)/(y(8)*y(8))));
g3_v(7)=(-(T(3)*params(1)*params(2)*(y(8)*y(8)*y(8)*y(8)*(-(2*(-y(14))))-(-((-y(14))*(y(8)+y(8))))*(y(8)*y(8)*(y(8)+y(8))+y(8)*y(8)*(y(8)+y(8))))/(y(8)*y(8)*y(8)*y(8)*y(8)*y(8)*y(8)*y(8))));
g3_v(8)=(-(T(3)*params(1)*params(2)*(y(8)+y(8))/(y(8)*y(8)*y(8)*y(8))));
g3_v(9)=(-(T(4)*T(17)));
g3_v(10)=(-(T(9)*T(13)));
g3_v(11)=(-((1-params(2))/y(7)*T(13)));
g3_v(12)=(-(T(7)*(-((-((1-params(2))*y(9)))*(y(7)+y(7))))/(y(7)*y(7)*y(7)*y(7))));
g3_v(13)=(-(T(7)*(-(1-params(2)))/(y(7)*y(7))));
g3_v(14)=getPowerDeriv(y(7),params(5),3)-T(1)*(y(7)*y(7)*y(7)*y(7)*(-(2*(-((1-params(2))*y(9)))))-(-((-((1-params(2))*y(9)))*(y(7)+y(7))))*(y(7)*y(7)*(y(7)+y(7))+y(7)*y(7)*(y(7)+y(7))))/(y(7)*y(7)*y(7)*y(7)*y(7)*y(7)*y(7)*y(7));
g3_v(15)=(-(T(1)*(-((y(7)+y(7))*(-(1-params(2)))))/(y(7)*y(7)*y(7)*y(7))));
g3_v(16)=(-(T(5)*getPowerDeriv(y(7),1-params(2),3)));
g3_v(17)=(-(T(11)*T(15)));
g3_v(18)=(-(T(5)*T(15)));
g3_v(19)=(-(T(10)*T(16)));
g3_v(20)=(-(T(10)*T(11)));
g3_v(21)=(-(T(5)*T(10)));
g3_v(22)=(-(T(6)*exp(y(10))*getPowerDeriv(y(3),params(2),3)));
g3_v(23)=(-(T(6)*T(16)));
g3_v(24)=(-(T(6)*T(11)));
g3_v(25)=(-(T(5)*T(6)));
end
