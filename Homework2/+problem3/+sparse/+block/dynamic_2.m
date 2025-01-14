function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(4, 1);
  T(1)=y(6)^(-params(4));
  residual(1)=(y(7)^params(5))-(T(1)*(1-params(2))*y(9)/y(7));
  residual(2)=(y(6)+y(8))-(y(9)+(1-params(3))*y(3));
  T(2)=exp(y(10));
  T(3)=T(2)*y(3)^params(2);
  T(4)=y(7)^(1-params(2));
  residual(3)=(y(9))-(T(3)*T(4));
  T(5)=y(11)^(-params(4));
  residual(4)=(T(1))-(params(1)*(params(2)*y(14)/y(8)+1-params(3))*T(5));
  T(6)=getPowerDeriv(y(6),(-params(4)),1);
if nargout > 3
    g1_v = NaN(14, 1);
g1_v(1)=(-(1-params(3)));
g1_v(2)=(-(T(4)*T(2)*getPowerDeriv(y(3),params(2),1)));
g1_v(3)=getPowerDeriv(y(7),params(5),1)-T(1)*(-((1-params(2))*y(9)))/(y(7)*y(7));
g1_v(4)=(-(T(3)*getPowerDeriv(y(7),1-params(2),1)));
g1_v(5)=1;
g1_v(6)=(-(T(5)*params(1)*params(2)*(-y(14))/(y(8)*y(8))));
g1_v(7)=(-(T(1)*(1-params(2))/y(7)));
g1_v(8)=(-1);
g1_v(9)=1;
g1_v(10)=(-((1-params(2))*y(9)/y(7)*T(6)));
g1_v(11)=1;
g1_v(12)=T(6);
g1_v(13)=(-(T(5)*params(1)*params(2)*1/y(8)));
g1_v(14)=(-(params(1)*(params(2)*y(14)/y(8)+1-params(3))*getPowerDeriv(y(11),(-params(4)),1)));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 4, 12);
end
end
