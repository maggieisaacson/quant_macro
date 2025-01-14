function [g1, T_order, T] = static_g1(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T_order, T)
if nargin < 8
    T_order = -1;
    T = NaN(4, 1);
end
[T_order, T] = problem3.sparse.static_g1_tt(y, x, params, T_order, T);
g1_v = NaN(14, 1);
g1_v(1)=T(4)-params(1)*(params(2)*y(4)/y(3)+1-params(3))*T(4);
g1_v(2)=(-(y(4)*(1-params(2))/y(2)*T(4)));
g1_v(3)=1;
g1_v(4)=getPowerDeriv(y(2),params(5),1)-T(1)*(-(y(4)*(1-params(2))))/(y(2)*y(2));
g1_v(5)=(-(T(2)*getPowerDeriv(y(2),1-params(2),1)));
g1_v(6)=(-(T(1)*params(1)*params(2)*(-y(4))/(y(3)*y(3))));
g1_v(7)=1-(1-params(3));
g1_v(8)=(-(T(3)*exp(y(5))*getPowerDeriv(y(3),params(2),1)));
g1_v(9)=(-(T(1)*params(1)*params(2)*1/y(3)));
g1_v(10)=(-(T(1)*(1-params(2))/y(2)));
g1_v(11)=(-1);
g1_v(12)=1;
g1_v(13)=(-(T(2)*T(3)));
g1_v(14)=1-params(6);
if ~isoctave && matlab_ver_less_than('9.8')
    sparse_rowval = double(sparse_rowval);
    sparse_colval = double(sparse_colval);
end
g1 = sparse(sparse_rowval, sparse_colval, g1_v, 5, 5);
end
