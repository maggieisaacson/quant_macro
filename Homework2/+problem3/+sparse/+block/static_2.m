function [y, T, residual, g1] = static_2(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(4, 1);
  T(1)=y(1)^(-params(4));
  residual(1)=(y(2)^params(5))-(T(1)*y(4)*(1-params(2))/y(2));
  residual(2)=(y(1)+y(3))-(y(4)+y(3)*(1-params(3)));
  T(2)=exp(y(5));
  T(3)=T(2)*y(3)^params(2);
  T(4)=y(2)^(1-params(2));
  residual(3)=(y(4))-(T(3)*T(4));
  residual(4)=(T(1))-(T(1)*params(1)*(params(2)*y(4)/y(3)+1-params(3)));
  T(5)=getPowerDeriv(y(1),(-params(4)),1);
if nargout > 3
    g1_v = NaN(12, 1);
g1_v(1)=getPowerDeriv(y(2),params(5),1)-T(1)*(-(y(4)*(1-params(2))))/(y(2)*y(2));
g1_v(2)=(-(T(3)*getPowerDeriv(y(2),1-params(2),1)));
g1_v(3)=(-(y(4)*(1-params(2))/y(2)*T(5)));
g1_v(4)=1;
g1_v(5)=T(5)-params(1)*(params(2)*y(4)/y(3)+1-params(3))*T(5);
g1_v(6)=(-(T(1)*(1-params(2))/y(2)));
g1_v(7)=(-1);
g1_v(8)=1;
g1_v(9)=(-(T(1)*params(1)*params(2)*1/y(3)));
g1_v(10)=1-(1-params(3));
g1_v(11)=(-(T(4)*T(2)*getPowerDeriv(y(3),params(2),1)));
g1_v(12)=(-(T(1)*params(1)*params(2)*(-y(4))/(y(3)*y(3))));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 4, 4);
end
end
