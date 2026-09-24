clear; clc; close all;

% test_function02 (2 outputs, 3 inputs)

% analytical Jacobian
p = struct();
p.numerical_diff = 0;
[x_a, flag_a] = multi_newton_solver(@test_function02, [1; 2; 3], p)
test_function02(x_a)

% numerical Jacobian (default)
[x_n, flag_n] = multi_newton_solver(@test_function02, [1; 2; 3])
test_function02(x_n)

% different guesses give different roots
[x1, f1] = multi_newton_solver(@test_function02, [5; 5; 5])
test_function02(x1)

[x2, f2] = multi_newton_solver(@test_function02, [-3; 1; -2])
test_function02(x2)

[x3, f3] = multi_newton_solver(@test_function02, [0; 10; 0])
test_function02(x3)

% projectile problem

% wrapper: input is [theta; t], output is projectile pos - target pos
collision_fun = @(X) projectile_traj(X(1), X(2)) - target_traj(X(2));

[X_sol, flag] = multi_newton_solver(collision_fun, [pi/4; 10])
collision_fun(X_sol)

theta = X_sol(1)
t_c = X_sol(2)

projectile_simulation(theta, t_c);
