function [g1, T_order, T] = dynamic_g1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T_order, T)
if nargin < 9
    T_order = -1;
    T = NaN(12, 1);
end
[T_order, T] = problem3.sparse.dynamic_g1_tt(y, x, params, steady_state, T_order, T);
g1_v = NaN(18, 1);
g1_v(1)=(-(1-params(3)));
g1_v(2)=(-(T(6)*T(11)));
g1_v(3)=(-params(6));
g1_v(4)=T(7);
g1_v(5)=(-(T(4)*T(7)));
g1_v(6)=1;
g1_v(7)=getPowerDeriv(y(7),params(5),1)-T(1)*T(9);
g1_v(8)=(-(T(5)*T(10)));
g1_v(9)=(-(T(3)*T(12)));
g1_v(10)=1;
g1_v(11)=(-(T(1)*(1-params(2))/y(7)));
g1_v(12)=(-1);
g1_v(13)=1;
g1_v(14)=(-(T(5)*T(6)));
g1_v(15)=1;
g1_v(16)=(-(T(2)*T(8)));
g1_v(17)=(-(T(3)*params(1)*params(2)*1/y(8)));
g1_v(18)=(-1);
if ~isoctave && matlab_ver_less_than('9.8')
    sparse_rowval = double(sparse_rowval);
    sparse_colval = double(sparse_colval);
end
g1 = sparse(sparse_rowval, sparse_colval, g1_v, 5, 16);
end
