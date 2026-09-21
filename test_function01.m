function [f_val, J] = test_function01(X)
%test_function01 Find the output of a function matrix and its Jacobian
%given a column vector X input
%   N/A
% Declare Symbolic Functions
syms x1 x2 x3

% Declare functions  
f1 = x1^2 + x2^2 - 6 - x3^5;
f2 = x1*x3 + x2 - 12;
f3 = sin(x1 + x2 + x3);

% Combine functions into F(X)
f_sym = [f1; f2; f3];

% Calculate the symbolic Jacobian
J_sym = jacobian(f_sym, [x1; x2; x3]);

% Substitute with numerical values
f_val = double(subs(f_sym, [x1; x2; x3], X));
J = double(subs(J_sym, [x1; x2; x3], X));

end